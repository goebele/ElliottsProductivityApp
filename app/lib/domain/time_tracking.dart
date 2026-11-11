import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/database.dart';
import '../sync/change_writer.dart';
import 'ids.dart';
import 'node_repository.dart';

/// Minutes in [e], or up to [now] while it runs.
int entryMinutes(TimeEntry e, {DateTime? now}) {
  final end = e.endedAt ?? (now ?? DateTime.now()).toUtc();
  return end.difference(e.startedAt).inSeconds ~/ 60;
}

/// Seconds in [e] that fall between [from] and [to].
int overlapSeconds(TimeEntry e, DateTime from, DateTime to, {DateTime? now}) {
  final end = e.endedAt ?? (now ?? DateTime.now()).toUtc();
  final s = e.startedAt.isAfter(from) ? e.startedAt : from;
  final t = end.isBefore(to) ? end : to;
  return t.isAfter(s) ? t.difference(s).inSeconds : 0;
}

/// An item's estimate and tracked time, its own and with everything under
/// it (§6.15).
class TimeRollup {
  const TimeRollup({
    this.ownEstimate,
    this.childEstimates = 0,
    this.ownTracked = 0,
    this.childTracked = 0,
  });

  final int? ownEstimate;

  /// Sum of the estimates of the items under it (at every level).
  final int childEstimates;

  /// Minutes tracked on the item itself, and on the items under it.
  final int ownTracked;
  final int childTracked;

  int get totalTracked => ownTracked + childTracked;
  int get totalEstimate => (ownEstimate ?? 0) + childEstimates;
}

/// Done and total items under a node (at every level), or a hand-set
/// percentage (§6.16).
class Progress {
  const Progress(this.done, this.total, {this.override});
  final int done;
  final int total;

  /// 0–100, set by hand.
  final int? override;

  double get fraction =>
      override != null ? override! / 100 : (total == 0 ? 0 : done / total);
}

/// The durable history behind reports (§6.16): who did what, with the
/// item's title, top-level project and values as they were then.
class ActivityLog {
  ActivityLog(this._db, this._writer, this._nodes, {required this.spaceId});

  final AppDatabase _db;
  final ChangeWriter _writer;
  final NodeRepository _nodes;
  final String spaceId;

  Future<void> record(
    String nodeId,
    ActivityAction action, {
    String? occurrence,
    int? minutes,
    DateTime? at,
  }) async {
    final node = await _nodes.get(nodeId);
    if (node == null) return;
    final ancestors = await _nodes.ancestors(nodeId);
    final top = ancestors.isEmpty ? null : ancestors.first;
    final values = [
      for (final v in await _nodes.values.effectiveOf(nodeId)) v.value.id,
    ];
    await _writer.insert(
      _db.activity,
      ActivityCompanion(
        id: Value(newId()),
        spaceId: Value(spaceId),
        at: Value((at ?? DateTime.now()).toUtc()),
        nodeId: Value(nodeId),
        action: Value(action),
        occurrenceDate: Value(occurrence),
        titleSnapshot: Value(node.title),
        topProjectId: Value(
          top?.id ?? (node.parentId == null ? node.id : null),
        ),
        topProjectSnapshot: Value(top?.title ?? node.title),
        valuesSnapshot: Value(jsonEncode(values)),
        minutes: Value(minutes),
        deleted: const Value(false),
      ),
    );
  }

  Future<List<ActivityData>> between(DateTime from, DateTime to) =>
      (_db.select(_db.activity)
            ..where(
              (a) =>
                  a.deleted.equals(false) &
                  a.at.isBiggerOrEqualValue(from.toUtc()) &
                  a.at.isSmallerThanValue(to.toUtc()),
            )
            ..orderBy([(a) => OrderingTerm(expression: a.at)]))
          .get();
}

/// Timers, focus sessions and time entries (§6.15). Personal. One timer
/// runs at a time: starting another stops the first.
class TimeRepository {
  TimeRepository(
    this._db,
    this._writer,
    this._nodes,
    this._log, {
    required this.spaceId,
  });

  final AppDatabase _db;
  final ChangeWriter _writer;
  final NodeRepository _nodes;
  final ActivityLog _log;
  final String spaceId;

  SimpleSelectStatement<$TimeEntriesTable, TimeEntry> _runningQuery() =>
      _db.select(_db.timeEntries)
        ..where((e) => e.endedAt.isNull() & e.deleted.equals(false))
        ..orderBy([(e) => OrderingTerm.desc(e.startedAt)]);

  Future<TimeEntry?> running() async =>
      (await _runningQuery().get()).firstOrNull;

  Stream<TimeEntry?> watchRunning() =>
      _runningQuery().watch().map((rows) => rows.firstOrNull);

  /// Starts a timer on [nodeId], stopping any other first. [focusMinutes]
  /// makes it a focus session counting down from that.
  Future<String> start(
    String nodeId, {
    int? focusMinutes,
    DateTime? now,
  }) async {
    final at = (now ?? DateTime.now()).toUtc();
    await stop(now: at);
    final id = newId();
    await _writer.insert(
      _db.timeEntries,
      TimeEntriesCompanion(
        id: Value(id),
        spaceId: Value(spaceId),
        nodeId: Value(nodeId),
        startedAt: Value(at),
        source: const Value(TimeSource.timer),
        focusMinutes: Value(focusMinutes),
        deleted: const Value(false),
      ),
    );
    return id;
  }

  /// Stops the running timer, if any, and logs its time. Returns the entry.
  Future<TimeEntry?> stop({DateTime? now}) async {
    final r = await running();
    if (r == null) return null;
    final at = (now ?? DateTime.now()).toUtc();
    await _writer.update(
      _db.timeEntries,
      r.id,
      TimeEntriesCompanion(endedAt: Value(at)),
    );
    final minutes = at.difference(r.startedAt).inSeconds ~/ 60;
    if (minutes > 0) {
      await _log.record(
        r.nodeId,
        ActivityAction.timeLogged,
        minutes: minutes,
        at: at,
      );
    }
    return (_db.select(
      _db.timeEntries,
    )..where((e) => e.id.equals(r.id))).getSingle();
  }

  /// Adds time after the fact.
  Future<String> addManual(
    String nodeId, {
    required DateTime start,
    required DateTime end,
    String? note,
  }) async {
    assert(!end.isBefore(start));
    final id = newId();
    await _writer.insert(
      _db.timeEntries,
      TimeEntriesCompanion(
        id: Value(id),
        spaceId: Value(spaceId),
        nodeId: Value(nodeId),
        startedAt: Value(start.toUtc()),
        endedAt: Value(end.toUtc()),
        source: const Value(TimeSource.manual),
        note: Value(note),
        deleted: const Value(false),
      ),
    );
    final minutes = end.difference(start).inMinutes;
    if (minutes > 0) {
      await _log.record(
        nodeId,
        ActivityAction.timeLogged,
        minutes: minutes,
        at: end,
      );
    }
    return id;
  }

  Future<void> edit(
    String id, {
    DateTime? start,
    DateTime? end,
    String? note,
  }) => _writer.update(
    _db.timeEntries,
    id,
    TimeEntriesCompanion(
      startedAt: start == null ? const Value.absent() : Value(start.toUtc()),
      endedAt: end == null ? const Value.absent() : Value(end.toUtc()),
      note: note == null ? const Value.absent() : Value(note),
    ),
  );

  Future<void> delete(String id) => _writer.update(
    _db.timeEntries,
    id,
    const TimeEntriesCompanion(deleted: Value(true)),
  );

  Future<void> restore(String id) => _writer.update(
    _db.timeEntries,
    id,
    const TimeEntriesCompanion(deleted: Value(false)),
  );

  SimpleSelectStatement<$TimeEntriesTable, TimeEntry> _ofQuery(String nodeId) =>
      _db.select(_db.timeEntries)
        ..where((e) => e.nodeId.equals(nodeId) & e.deleted.equals(false))
        ..orderBy([(e) => OrderingTerm.desc(e.startedAt)]);

  Future<List<TimeEntry>> of(String nodeId) => _ofQuery(nodeId).get();
  Stream<List<TimeEntry>> watchOf(String nodeId) => _ofQuery(nodeId).watch();

  /// Live entries that overlap [from]–[to].
  Future<List<TimeEntry>> between(DateTime from, DateTime to) =>
      (_db.select(_db.timeEntries)..where(
            (e) =>
                e.deleted.equals(false) &
                e.startedAt.isSmallerThanValue(to.toUtc()) &
                (e.endedAt.isNull() |
                    e.endedAt.isBiggerThanValue(from.toUtc())),
          ))
          .get();

  /// Estimates and tracked time for [nodeId] and everything under it.
  Future<TimeRollup> rollup(String nodeId, {DateTime? now}) async {
    final node = await _nodes.get(nodeId);
    if (node == null) return const TimeRollup();
    final below = await _nodes.descendantIds(nodeId);
    var childEstimates = 0;
    for (final id in below) {
      final n = await _nodes.get(id);
      if (n != null && n.type.isItem) childEstimates += n.estimateMinutes ?? 0;
    }
    final entries =
        await (_db.select(_db.timeEntries)..where(
              (e) =>
                  e.deleted.equals(false) & e.nodeId.isIn([nodeId, ...below]),
            ))
            .get();
    var own = 0;
    var children = 0;
    for (final e in entries) {
      final m = entryMinutes(e, now: now);
      e.nodeId == nodeId ? own += m : children += m;
    }
    return TimeRollup(
      ownEstimate: node.estimateMinutes,
      childEstimates: childEstimates,
      ownTracked: own,
      childTracked: children,
    );
  }

  /// Re-reads [rollup] when entries or items change.
  Stream<TimeRollup> watchRollup(String nodeId) => _db
      .customSelect(
        'SELECT 1 AS time_rollup',
        readsFrom: {_db.timeEntries, _db.nodes},
      )
      .watch()
      .asyncMap((_) => rollup(nodeId));
}

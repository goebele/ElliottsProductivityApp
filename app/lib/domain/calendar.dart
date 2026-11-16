import 'package:drift/drift.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data/database.dart';
import '../sync/change_writer.dart';
import 'ids.dart';
import 'node_repository.dart';
import 'repeat_rule.dart';

/// The device's IANA time zone (e.g. "Europe/London"), set at startup.
/// Stored with time slots so a repeat at 18:00 stays at 18:00 across
/// daylight-saving changes (§6.5). Null until known (and in tests).
String? deviceTimeZone;

/// The zone named [id], or null if unknown (or the database isn't loaded).
tz.Location? zoneNamed(String? id) {
  if (id == null) return null;
  try {
    return tz.getLocation(id);
  } catch (_) {
    return null;
  }
}

enum CalendarEntryKind {
  /// A time slot (`start_at`/`end_at`), possibly repeating.
  event,

  /// A deadline: an all-day `due_date` or a timed `due_at`.
  deadline,

  /// A repeating item with no time slot: all day on each occurrence.
  routine,
}

/// One thing on one day of the calendar.
class CalendarEntry {
  const CalendarEntry({
    required this.node,
    required this.kind,
    required this.day,
    this.start,
    this.end,
    this.done = false,
    this.occurrence,
  });

  final Node node;
  final CalendarEntryKind kind;

  /// The local calendar day it's on.
  final DateTime day;

  /// Local start and end; null for all-day entries.
  final DateTime? start;
  final DateTime? end;

  final bool done;

  /// For a repeat: the occurrence date (`YYYY-MM-DD`) it stands for.
  final String? occurrence;

  bool get allDay => start == null;
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// What the calendar shows (§6.5). Empty sets mean "any".
class CalendarFilter {
  const CalendarFilter({
    this.kinds = const {},
    this.hideDone = false,
    this.tagIds = const {},
    this.valueIds = const {},
    this.underId,
  });

  /// Only these kinds (empty = all).
  final Set<CalendarEntryKind> kinds;
  final bool hideDone;

  /// Items with any of these tags (on the item itself).
  final Set<String> tagIds;

  /// Items with any of these values, own or inherited.
  final Set<String> valueIds;

  /// Only this item and everything under it, at any level.
  final String? underId;

  bool get isEmpty =>
      kinds.isEmpty &&
      !hideDone &&
      tagIds.isEmpty &&
      valueIds.isEmpty &&
      underId == null;

  CalendarFilter copyWith({
    Set<CalendarEntryKind>? kinds,
    bool? hideDone,
    Set<String>? tagIds,
    Set<String>? valueIds,
    String? Function()? underId,
  }) => CalendarFilter(
    kinds: kinds ?? this.kinds,
    hideDone: hideDone ?? this.hideDone,
    tagIds: tagIds ?? this.tagIds,
    valueIds: valueIds ?? this.valueIds,
    underId: underId == null ? this.underId : underId(),
  );
}

/// Expands events, deadlines and repeats into calendar entries
/// (DESIGN.md §6.5). Repeats are expanded on the fly from their rule; only
/// completions are stored. Items inside a repeating item aren't listed:
/// the repeating item stands for them (D24).
class CalendarService {
  CalendarService(this._db, this._nodes);

  final AppDatabase _db;
  final NodeRepository _nodes;

  /// Entries on the local days from [from] up to (not including) [to],
  /// all-day ones first each day, then by start time.
  Future<List<CalendarEntry>> entries(
    DateTime from,
    DateTime to, {
    CalendarFilter filter = const CalendarFilter(),
  }) async {
    final first = _day(from);
    final last = _day(to);
    final rows =
        await (_db.select(_db.nodes)..where(
              (n) =>
                  n.deleted.equals(false) &
                  n.lifecycle.equals(Lifecycle.live.name) &
                  n.type.equals(NodeType.note.name).not() &
                  (n.startAt.isNotNull() |
                      n.dueDate.isNotNull() |
                      n.dueAt.isNotNull() |
                      n.rrule.isNotNull()),
            ))
            .get();

    final out = <CalendarEntry>[];
    bool inRange(DateTime d) => !d.isBefore(first) && d.isBefore(last);

    for (final n in rows) {
      final rule = n.rrule == null ? null : RepeatRule.parse(n.rrule!);
      final start = n.startAt;
      final end = n.endAt;

      if (rule != null) {
        final seriesFrom = seriesStart(n);
        for (var d = first; d.isBefore(last); d = _addDays(d, 1)) {
          if (!rule.occursOn(d, seriesFrom)) continue;
          final key = dateKey(d);
          final done =
              isFinished(n.status) || await _nodes.occurrenceDone(n, key);
          if (start != null) {
            final s = _wallTimeOn(d, start, n.timeZone);
            final length = end == null ? Duration.zero : end.difference(start);
            out.add(
              CalendarEntry(
                node: n,
                kind: CalendarEntryKind.event,
                day: d,
                start: s,
                end: s.add(length),
                done: done,
                occurrence: key,
              ),
            );
          } else {
            out.add(
              CalendarEntry(
                node: n,
                kind: CalendarEntryKind.routine,
                day: d,
                done: done,
                occurrence: key,
              ),
            );
          }
        }
      } else if (start != null) {
        final s = start.toLocal();
        if (inRange(_day(s))) {
          out.add(
            CalendarEntry(
              node: n,
              kind: CalendarEntryKind.event,
              day: _day(s),
              start: s,
              end: end?.toLocal() ?? s,
              done: isFinished(n.status),
            ),
          );
        }
      }

      if (n.dueDate case final key?) {
        final d = parseDateKey(key);
        if (inRange(d)) {
          out.add(
            CalendarEntry(
              node: n,
              kind: CalendarEntryKind.deadline,
              day: d,
              done: isFinished(n.status),
            ),
          );
        }
      }
      if (n.dueAt case final at?) {
        final s = at.toLocal();
        if (inRange(_day(s))) {
          out.add(
            CalendarEntry(
              node: n,
              kind: CalendarEntryKind.deadline,
              day: _day(s),
              start: s,
              end: s,
              done: isFinished(n.status),
            ),
          );
        }
      }
    }

    if (!filter.isEmpty) {
      final keep = await _matcher(filter);
      out.retainWhere(
        (e) =>
            (filter.kinds.isEmpty || filter.kinds.contains(e.kind)) &&
            !(filter.hideDone && e.done) &&
            keep(e.node),
      );
    }

    out.sort((a, b) {
      final day = a.day.compareTo(b.day);
      if (day != 0) return day;
      if (a.allDay != b.allDay) return a.allDay ? -1 : 1;
      if (!a.allDay) {
        final t = a.start!.compareTo(b.start!);
        if (t != 0) return t;
      }
      return a.node.title.toLowerCase().compareTo(b.node.title.toLowerCase());
    });
    return out;
  }

  /// Re-runs [entries] whenever items or completions change.
  Stream<List<CalendarEntry>> watch(
    DateTime from,
    DateTime to, {
    CalendarFilter filter = const CalendarFilter(),
  }) => _db
      .customSelect(
        'SELECT 1 AS calendar_entries',
        readsFrom: {
          _db.nodes,
          _db.occurrenceCompletions,
          _db.nodeTags,
          _db.nodeValues,
        },
      )
      .watch()
      .asyncMap((_) => entries(from, to, filter: filter));

  /// Whether a node passes the tag, value and "under" parts of [f]. Values
  /// and "under" follow real parents (values also shortcut parents, as
  /// elsewhere).
  Future<bool Function(Node)> _matcher(CalendarFilter f) async {
    if (f.tagIds.isEmpty && f.valueIds.isEmpty && f.underId == null) {
      return (_) => true;
    }
    final parent = <String, String?>{
      for (final r
          in await _db
              .customSelect(
                'SELECT id, parent_id FROM nodes WHERE deleted = 0',
                readsFrom: {_db.nodes},
              )
              .get())
        r.read<String>('id'): r.readNullable<String>('parent_id'),
    };
    final placed = <String, List<String>>{};
    for (final p in await (_db.select(
      _db.placements,
    )..where((p) => p.deleted.equals(false))).get()) {
      if (p.parentNodeId != null) {
        (placed[p.nodeId] ??= []).add(p.parentNodeId!);
      }
    }
    final tagged = <String>{
      if (f.tagIds.isNotEmpty)
        for (final r
            in await (_db.select(_db.nodeTags)..where(
                  (r) => r.deleted.equals(false) & r.tagId.isIn(f.tagIds),
                ))
                .get())
          r.nodeId,
    };
    final valued = <String>{
      if (f.valueIds.isNotEmpty)
        for (final r
            in await (_db.select(_db.nodeValues)..where(
                  (r) => r.deleted.equals(false) & r.valueId.isIn(f.valueIds),
                ))
                .get())
          r.nodeId,
    };

    Iterable<String> above(String id) sync* {
      final seen = <String>{id};
      final stack = [id];
      while (stack.isNotEmpty && seen.length < 1000) {
        final n = stack.removeLast();
        for (final p in [?parent[n], ...?placed[n]]) {
          if (seen.add(p)) {
            yield p;
            stack.add(p);
          }
        }
      }
    }

    bool under(String id) {
      String? cur = id;
      for (var i = 0; cur != null && i < 1000; i++) {
        if (cur == f.underId) return true;
        cur = parent[cur];
      }
      return false;
    }

    return (n) =>
        (f.tagIds.isEmpty || tagged.contains(n.id)) &&
        (f.valueIds.isEmpty ||
            valued.contains(n.id) ||
            above(n.id).any(valued.contains)) &&
        (f.underId == null || under(n.id));
  }

  /// The local time on day [d] at the same wall-clock time as [startUtc]
  /// had in [zoneId] (falling back to this device's zone).
  static DateTime _wallTimeOn(DateTime d, DateTime startUtc, String? zoneId) {
    final zone = zoneNamed(zoneId);
    if (zone == null) {
      final local = startUtc.toLocal();
      return DateTime(d.year, d.month, d.day, local.hour, local.minute);
    }
    final there = tz.TZDateTime.from(startUtc, zone);
    return tz.TZDateTime(
      zone,
      d.year,
      d.month,
      d.day,
      there.hour,
      there.minute,
    ).toLocal();
  }

  static DateTime _addDays(DateTime d, int n) =>
      DateTime(d.year, d.month, d.day + n);
}

/// A reminder due to fire.
class PlannedReminder {
  const PlannedReminder(this.entry, this.at, this.minutesBefore);
  final CalendarEntry entry;
  final DateTime at;
  final int minutesBefore;
}

/// Reminders on items (§6.5): personal, as minutes before the item's start
/// (or, for all-day items, before 00:00 that day).
class ReminderRepository {
  ReminderRepository(
    this._db,
    this._writer,
    this._calendar, {
    required this.spaceId,
  });

  final AppDatabase _db;
  final ChangeWriter _writer;
  final CalendarService _calendar;
  final String spaceId;

  /// How far ahead reminders are scheduled; rescheduled on open and on
  /// changes.
  static const horizon = Duration(days: 14);

  SimpleSelectStatement<$RemindersTable, Reminder> _of(String nodeId) =>
      _db.select(_db.reminders)
        ..where((r) => r.nodeId.equals(nodeId) & r.deleted.equals(false));

  Future<Set<int>> of(String nodeId) async => {
    for (final r in await _of(nodeId).get()) r.minutesBefore,
  };

  Stream<Set<int>> watchOf(String nodeId) =>
      _of(nodeId)
          .watch()
          .map((rows) => {for (final r in rows) r.minutesBefore});

  /// Makes [nodeId]'s reminders exactly [minutes].
  Future<void> set(String nodeId, Set<int> minutes) =>
      _db.transaction(() async {
        final rows = await _of(nodeId).get();
        final have = <int>{};
        for (final r in rows) {
          if (minutes.contains(r.minutesBefore) && have.add(r.minutesBefore)) {
            continue;
          }
          await _writer.update(
            _db.reminders,
            r.id,
            const RemindersCompanion(deleted: Value(true)),
          );
        }
        for (final m in minutes.difference(have)) {
          await _writer.insert(
            _db.reminders,
            RemindersCompanion(
              id: Value(newId()),
              spaceId: Value(spaceId),
              nodeId: Value(nodeId),
              minutesBefore: Value(m),
              deleted: const Value(false),
            ),
          );
        }
      });

  /// Reminders that fire from [from] up to [to], skipping entries already
  /// done, earliest first.
  Future<List<PlannedReminder>> planned(DateTime from, DateTime to) async {
    final all = <String, Set<int>>{};
    for (final r in await (_db.select(
      _db.reminders,
    )..where((r) => r.deleted.equals(false))).get()) {
      (all[r.nodeId] ??= {}).add(r.minutesBefore);
    }
    if (all.isEmpty) return const [];
    // Offsets reach up to a few days back from the anchor.
    final entries = await _calendar.entries(
      from.subtract(const Duration(days: 1)),
      to.add(const Duration(days: 8)),
    );
    final out = <PlannedReminder>[];
    for (final e in entries) {
      final minutes = all[e.node.id];
      if (minutes == null || e.done) continue;
      final anchor = e.start ?? e.day;
      for (final m in minutes) {
        final at = anchor.subtract(Duration(minutes: m));
        if (!at.isBefore(from) && at.isBefore(to)) {
          out.add(PlannedReminder(e, at, m));
        }
      }
    }
    out.sort((a, b) => a.at.compareTo(b.at));
    return out;
  }

  /// Fires whenever reminders, items or completions change.
  Stream<void> watchChanges() => _db
      .customSelect(
        'SELECT 1 AS reminder_changes',
        readsFrom: {_db.reminders, _db.nodes, _db.occurrenceCompletions},
      )
      .watch()
      .map((_) {});
}

/// Personal per-item settings (§5.0).
class PrefsRepository {
  PrefsRepository(this._db, this._writer, {required this.spaceId});

  final AppDatabase _db;
  final ChangeWriter _writer;
  final String spaceId;

  Future<NodeUserPref?> _row(String nodeId) =>
      (_db.select(_db.nodeUserPrefs)
            ..where((r) => r.nodeId.equals(nodeId) & r.deleted.equals(false))
            ..limit(1))
          .getSingleOrNull();

  Future<bool> icsExport(String nodeId) async =>
      (await _row(nodeId))?.icsExport ?? false;

  Stream<bool> watchIcsExport(String nodeId) =>
      (_db.select(_db.nodeUserPrefs)
            ..where((r) => r.nodeId.equals(nodeId) & r.deleted.equals(false))
            ..limit(1))
          .watchSingleOrNull()
          .map((r) => r?.icsExport ?? false);

  Future<void> setIcsExport(String nodeId, bool on) async {
    final row = await _row(nodeId);
    if (row != null) {
      await _writer.update(
        _db.nodeUserPrefs,
        row.id,
        NodeUserPrefsCompanion(icsExport: Value(on)),
      );
    } else {
      await _writer.insert(
        _db.nodeUserPrefs,
        NodeUserPrefsCompanion(
          id: Value(newId()),
          spaceId: Value(spaceId),
          nodeId: Value(nodeId),
          icsExport: Value(on),
          deleted: const Value(false),
        ),
      );
    }
  }

  /// Live items you chose to include in "Export calendar".
  Future<List<Node>> icsExportNodes() async {
    final q =
        _db.select(_db.nodes).join([
          innerJoin(
            _db.nodeUserPrefs,
            _db.nodeUserPrefs.nodeId.equalsExp(_db.nodes.id),
          ),
        ])..where(
          _db.nodeUserPrefs.icsExport.equals(true) &
              _db.nodeUserPrefs.deleted.equals(false) &
              _db.nodes.deleted.equals(false) &
              _db.nodes.lifecycle.equals(Lifecycle.live.name),
        );
    final seen = <String>{};
    return [
      for (final r in await q.get())
        if (seen.add(r.readTable(_db.nodes).id)) r.readTable(_db.nodes),
    ];
  }
}

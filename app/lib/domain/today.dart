import 'dart:convert';
import 'dart:math' as math;

import 'package:drift/drift.dart';

import '../data/database.dart';
import '../sync/change_writer.dart';
import 'ids.dart';
import 'node_repository.dart';
import 'repeat_rule.dart';
import 'search.dart';
import 'sort_keys.dart';

/// Why something is on Today (DESIGN.md §6.7).
enum TodaySource {
  /// You added it.
  picked,

  /// A repeat due today (with its items, if it has any).
  routine,

  /// Its deadline is today.
  dueToday,

  /// Its deadline has passed.
  overdue,

  /// It has a time slot today.
  event,

  /// Its status is Active ("in progress").
  active,
}

/// Which kinds Today adds by itself. Routines and deadlines by default.
class TodaySettings {
  const TodaySettings({
    this.routines = true,
    this.dueToday = true,
    this.overdue = true,
    this.events = true,
    this.active = false,
  });

  factory TodaySettings.fromJson(Map<String, dynamic> j) => TodaySettings(
    routines: j['routines'] as bool? ?? true,
    dueToday: j['dueToday'] as bool? ?? true,
    overdue: j['overdue'] as bool? ?? true,
    events: j['events'] as bool? ?? true,
    active: j['active'] as bool? ?? false,
  );

  final bool routines;
  final bool dueToday;
  final bool overdue;
  final bool events;
  final bool active;

  bool includes(TodaySource s) => switch (s) {
    TodaySource.picked => true,
    TodaySource.routine => routines,
    TodaySource.dueToday => dueToday,
    TodaySource.overdue => overdue,
    TodaySource.event => events,
    TodaySource.active => active,
  };

  Map<String, dynamic> toJson() => {
    'routines': routines,
    'dueToday': dueToday,
    'overdue': overdue,
    'events': events,
    'active': active,
  };

  TodaySettings copyWith({
    bool? routines,
    bool? dueToday,
    bool? overdue,
    bool? events,
    bool? active,
  }) => TodaySettings(
    routines: routines ?? this.routines,
    dueToday: dueToday ?? this.dueToday,
    overdue: overdue ?? this.overdue,
    events: events ?? this.events,
    active: active ?? this.active,
  );
}

/// One item on Today.
class TodayItem {
  const TodayItem({
    required this.node,
    required this.source,
    required this.done,
    this.start,
    this.overdueDays = 0,
  });

  final Node node;

  /// Why it's here; a picked item that also qualifies on its own shows
  /// that reason instead.
  final TodaySource source;
  final bool done;

  /// For an event: when it starts today (local).
  final DateTime? start;

  /// For an overdue item: how many days late.
  final int overdueDays;
}

/// Today's list, and picks from earlier days that were left unfinished.
class TodayList {
  const TodayList(this.day, this.items, this.leftOver);
  final DateTime day;
  final List<TodayItem> items;

  /// Picked on an earlier day, not done, not yet kept or dropped.
  final List<Node> leftOver;

  int get doneCount => items.where((i) => i.done).length;
}

/// Builds Today and keeps its picks, order and hidden items (§6.7).
/// Personal: rows live in your personal space.
class TodayService {
  TodayService(this._db, this._writer, this._nodes, {required this.spaceId});

  final AppDatabase _db;
  final ChangeWriter _writer;
  final NodeRepository _nodes;
  final String spaceId;

  static const _settingsKey = 'today.sources';

  // ---------------------------------------------------------------- settings

  Future<UserSetting?> _settingRow() =>
      (_db.select(_db.userSettings)
            ..where((s) => s.key.equals(_settingsKey) & s.deleted.equals(false))
            ..limit(1))
          .getSingleOrNull();

  Future<TodaySettings> settings() async {
    final row = await _settingRow();
    if (row == null) return const TodaySettings();
    try {
      return TodaySettings.fromJson(
        jsonDecode(row.value) as Map<String, dynamic>,
      );
    } catch (_) {
      return const TodaySettings();
    }
  }

  Future<void> setSettings(TodaySettings s) async {
    final row = await _settingRow();
    final json = jsonEncode(s.toJson());
    if (row != null) {
      await _writer.update(
        _db.userSettings,
        row.id,
        UserSettingsCompanion(value: Value(json)),
      );
    } else {
      await _writer.insert(
        _db.userSettings,
        UserSettingsCompanion(
          id: Value(newId()),
          spaceId: Value(spaceId),
          key: const Value(_settingsKey),
          value: Value(json),
          deleted: const Value(false),
        ),
      );
    }
  }

  // ------------------------------------------------------------------- rows

  Future<List<TodayEntry>> _rows(String date) =>
      (_db.select(_db.todayEntries)
            ..where((r) => r.date.equals(date) & r.deleted.equals(false))
            ..orderBy([
              (r) => OrderingTerm(expression: r.sortKey),
              (r) => OrderingTerm(expression: r.id),
            ]))
          .get();

  Future<TodayEntry?> _row(String date, String nodeId) async =>
      (await _rows(date)).where((r) => r.nodeId == nodeId).firstOrNull;

  /// Adds [nodeId] to [day]'s list (at the end), or brings it back if it
  /// was removed.
  Future<void> add(String nodeId, {DateTime? day}) async {
    final date = dateKey(day ?? DateTime.now());
    final row = await _row(date, nodeId);
    if (row != null) {
      if (row.hidden) {
        await _writer.update(
          _db.todayEntries,
          row.id,
          const TodayEntriesCompanion(hidden: Value(false)),
        );
      }
      return;
    }
    final last = (await _rows(date)).lastOrNull;
    await _insert(date, nodeId, keyBetween(last?.sortKey, null));
  }

  /// Takes [nodeId] off [day]'s list: unpicks it, and hides it if Today
  /// would add it by itself.
  Future<void> remove(String nodeId, {DateTime? day}) async {
    final date = dateKey(day ?? DateTime.now());
    final row = await _row(date, nodeId);
    if (row != null) {
      await _writer.update(
        _db.todayEntries,
        row.id,
        const TodayEntriesCompanion(hidden: Value(true)),
      );
    } else {
      await _insert(date, nodeId, keyBetween(null, null), hidden: true);
    }
  }

  /// Saves the list's order after a drag: [nodeIds] top to bottom.
  Future<void> reorder(List<String> nodeIds, {DateTime? day}) =>
      _db.transaction(() async {
        final date = dateKey(day ?? DateTime.now());
        final rows = {for (final r in await _rows(date)) r.nodeId: r};
        final keys = keysBetween(null, null, nodeIds.length);
        for (final (i, id) in nodeIds.indexed) {
          final row = rows[id];
          if (row == null) {
            await _insert(date, id, keys[i]);
          } else if (row.sortKey != keys[i]) {
            await _writer.update(
              _db.todayEntries,
              row.id,
              TodayEntriesCompanion(sortKey: Value(keys[i])),
            );
          }
        }
      });

  /// Answers "keep or drop" for picks left over from earlier days.
  Future<void> resolveLeftOver(List<String> nodeIds, {required bool keep}) =>
      _db.transaction(() async {
        final today = dateKey(DateTime.now());
        for (final r in await _leftOverRows(today)) {
          if (!nodeIds.contains(r.nodeId)) continue;
          await _writer.update(
            _db.todayEntries,
            r.id,
            const TodayEntriesCompanion(resolved: Value(true)),
          );
        }
        if (keep) {
          for (final id in nodeIds) {
            await add(id);
          }
        }
      });

  Future<void> _insert(
    String date,
    String nodeId,
    String sortKey, {
    bool hidden = false,
  }) => _writer.insert(
    _db.todayEntries,
    TodayEntriesCompanion(
      id: Value(newId()),
      spaceId: Value(spaceId),
      date: Value(date),
      nodeId: Value(nodeId),
      sortKey: Value(sortKey),
      hidden: Value(hidden),
      deleted: const Value(false),
    ),
  );

  Future<List<TodayEntry>> _leftOverRows(String today) =>
      (_db.select(_db.todayEntries)..where(
            (r) =>
                r.date.isSmallerThanValue(today) &
                r.deleted.equals(false) &
                r.hidden.equals(false) &
                r.resolved.equals(false),
          ))
          .get();

  // ------------------------------------------------------------------ build

  /// Today's list for [now]'s local day: what Today adds by itself (per
  /// [settings]), plus picks, minus what was removed, in the dragged order
  /// (the rest after: overdue, due, events by time, routines, active).
  Future<TodayList> build({DateTime? now}) async {
    final at = now ?? DateTime.now();
    final today = DateTime(at.year, at.month, at.day);
    final key = dateKey(today);
    final prefs = await settings();
    final rows = await _rows(key);
    final hidden = {
      for (final r in rows)
        if (r.hidden) r.nodeId,
    };

    final auto = <String, TodayItem>{};
    void offer(TodayItem i) {
      if (!prefs.includes(i.source) || hidden.contains(i.node.id)) return;
      auto.putIfAbsent(i.node.id, () => i);
    }

    final live =
        await (_db.select(_db.nodes)..where(
              (n) =>
                  n.deleted.equals(false) &
                  n.lifecycle.equals(Lifecycle.live.name) &
                  n.type.equals(NodeType.note.name).not(),
            ))
            .get();
    bool completedToday(Node n) {
      final c = n.completedAt?.toLocal();
      return c != null &&
          !c.isBefore(today) &&
          c.isBefore(today.add(const Duration(days: 1)));
    }

    for (final n in live) {
      // Items inside a repeat come with it, not on their own.
      final rule = n.rrule == null ? null : RepeatRule.parse(n.rrule!);
      if (rule != null && rule.occursOn(today, seriesStart(n))) {
        final done = await _nodes.occurrenceDone(n, key);
        offer(
          TodayItem(
            node: n,
            source: n.startAt != null ? TodaySource.event : TodaySource.routine,
            done: done,
            start: n.startAt == null
                ? null
                : _sameTime(today, n.startAt!.toLocal()),
          ),
        );
        continue;
      }
      if (rule != null) continue;
      final finished = isFinished(n.status);
      if (finished && !completedToday(n)) continue;

      if (n.dueDate case final due?) {
        final d = parseDateKey(due);
        if (d == today) {
          offer(
            TodayItem(node: n, source: TodaySource.dueToday, done: finished),
          );
        } else if (d.isBefore(today) && !finished) {
          offer(
            TodayItem(
              node: n,
              source: TodaySource.overdue,
              done: false,
              overdueDays: today.difference(d).inDays,
            ),
          );
        }
      }
      if (n.startAt case final s?) {
        final local = s.toLocal();
        if (DateTime(local.year, local.month, local.day) == today) {
          offer(
            TodayItem(
              node: n,
              source: TodaySource.event,
              done: finished,
              start: local,
            ),
          );
        }
      }
      if (n.status == NodeStatus.active) {
        offer(TodayItem(node: n, source: TodaySource.active, done: false));
      }
    }

    // Picks (and auto items that were dragged into place).
    final byId = {for (final n in live) n.id: n};
    final ordered = <TodayItem>[];
    final seen = <String>{};
    for (final r in rows) {
      if (r.hidden || !seen.add(r.nodeId)) continue;
      final n = byId[r.nodeId];
      if (n == null) continue;
      ordered.add(
        auto[r.nodeId] ??
            TodayItem(
              node: n,
              source: TodaySource.picked,
              done: await _doneToday(n, today),
            ),
      );
    }

    int rank(TodayItem i) => switch (i.source) {
      TodaySource.overdue => 0,
      TodaySource.dueToday => 1,
      TodaySource.event => 2,
      TodaySource.routine => 3,
      TodaySource.active => 4,
      TodaySource.picked => 5,
    };
    final rest =
        [
          for (final i in auto.values)
            if (!seen.contains(i.node.id)) i,
        ]..sort((a, b) {
          final r = rank(a).compareTo(rank(b));
          if (r != 0) return r;
          if (a.start != null && b.start != null) {
            return a.start!.compareTo(b.start!);
          }
          return a.node.title.toLowerCase().compareTo(
            b.node.title.toLowerCase(),
          );
        });

    // Left over: earlier picks, unfinished, not on today already.
    final onToday = {...seen, ...auto.keys};
    final leftOver = <Node>[];
    final leftSeen = <String>{};
    for (final r in await _leftOverRows(key)) {
      final n = byId[r.nodeId];
      if (n == null || onToday.contains(n.id) || !leftSeen.add(n.id)) continue;
      if (hidden.contains(n.id) || isFinished(n.status)) continue;
      leftOver.add(n);
    }

    return TodayList(today, [...ordered, ...rest], leftOver);
  }

  /// Re-builds when items, completions or Today's rows change.
  Stream<TodayList> watch() => _db
      .customSelect(
        'SELECT 1 AS today_list',
        readsFrom: {
          _db.nodes,
          _db.occurrenceCompletions,
          _db.todayEntries,
          _db.userSettings,
        },
      )
      .watch()
      .asyncMap((_) => build());

  Future<bool> _doneToday(Node n, DateTime today) async {
    final occ = await _nodes.occurrenceStatus(n.id, today: today);
    return occ != null ? occ.done : isFinished(n.status);
  }

  static DateTime _sameTime(DateTime day, DateTime t) =>
      DateTime(day.year, day.month, day.day, t.hour, t.minute);

  /// A random open item that isn't on Today yet, matching [filters]
  /// (tags, values, under a top-level item). Null if there's none.
  Future<Node?> pickOne({
    SearchFilters filters = const SearchFilters(),
    Set<String> exclude = const {},
    math.Random? random,
  }) async {
    final today = await build();
    final skip = {...exclude, for (final i in today.items) i.node.id};
    final f = filters.copyWith(
      statuses: {NodeStatus.open, NodeStatus.active},
      types: filters.types.isEmpty
          ? {NodeType.task, NodeType.project, NodeType.goal}
          : filters.types,
    );
    final results = await _nodes.search.search(const SearchQuery(), filters: f);
    final candidates = <Node>[];
    for (final r in results) {
      final n = r.node;
      if (skip.contains(n.id) || r.attachment != null) continue;
      // Items inside a repeat come with it.
      if (n.rrule == null && await _nodes.repeatSource(n) != null) continue;
      candidates.add(n);
    }
    if (candidates.isEmpty) return null;
    return candidates[(random ?? math.Random()).nextInt(candidates.length)];
  }
}

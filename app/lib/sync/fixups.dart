import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/database.dart';
import '../domain/ids.dart';
import 'change_writer.dart';

/// Merge rules that run after a batch from a peer is applied (§7.6). Each
/// writes ordinary ops, chosen the same way on every device, so devices
/// that both run a fix-up end up the same.
class SyncFixups {
  SyncFixups(this._db, this._writer);

  final AppDatabase _db;
  final ChangeWriter _writer;

  Future<void> run({
    Set<String> movedNodes = const {},
    Set<String> tables = const {},
  }) async {
    if (movedNodes.isNotEmpty) await breakCycles(movedNodes);
    if (tables.contains('tags') || tables.contains('node_tags')) {
      await mergeTags();
    }
    if (tables.contains('core_values') || tables.contains('node_values')) {
      await mergeValues();
    }
    if (tables.contains('time_entries')) await oneRunningTimer();
  }

  // ------------------------------------------------------------- cycles (L4)

  Future<String?> _parentOf(String id) async =>
      (await _db
              .customSelect(
                'SELECT parent_id FROM nodes WHERE id = ?',
                variables: [Variable.withString(id)],
              )
              .getSingleOrNull())
          ?.readNullable<String>('parent_id');

  /// The nodes on a loop through [start], or null if there's none.
  Future<List<String>?> _cycleThrough(String start) async {
    final path = <String>[start];
    var at = await _parentOf(start);
    while (at != null) {
      if (at == start) return path;
      if (path.contains(at) || path.length > 100000) return null;
      path.add(at);
      at = await _parentOf(at);
    }
    return null;
  }

  /// Two moves on different devices can make a loop (A under B, B under A).
  /// The move with the older HLC is undone: that node goes back to the
  /// parent it had before (or the top level, if that would loop too).
  Future<void> breakCycles(Set<String> moved) async {
    for (final id in moved) {
      final cycle = await _cycleThrough(id);
      if (cycle == null) continue;
      String? victim;
      String? oldest;
      for (final n in cycle) {
        final h = await _moveHlc(n);
        if (h != null && (oldest == null || h.compareTo(oldest) < 0)) {
          oldest = h;
          victim = n;
        }
      }
      victim ??= cycle.first;
      final before = await _previousParent(victim);
      String? target = before;
      if (target != null && await _wouldLoop(victim, target)) target = null;
      await _writer.update(
        _db.nodes,
        victim,
        NodesCompanion(parentId: Value(target)),
      );
    }
  }

  Future<String?> _moveHlc(String nodeId) async =>
      (await _db
              .customSelect(
                "SELECT MAX(hlc) AS h FROM change_log WHERE table_name = 'nodes' "
                "AND row_id = ? AND column_name = 'parent_id'",
                variables: [Variable.withString(nodeId)],
              )
              .getSingle())
          .readNullable<String>('h');

  /// The parent [nodeId] had before its latest move.
  Future<String?> _previousParent(String nodeId) async {
    final rows = await _db
        .customSelect(
          "SELECT value FROM change_log WHERE table_name = 'nodes' "
          "AND row_id = ? AND column_name = 'parent_id' ORDER BY hlc DESC "
          'LIMIT 2',
          variables: [Variable.withString(nodeId)],
        )
        .get();
    if (rows.length < 2) return null;
    return jsonDecode(rows[1].read<String>('value')) as String?;
  }

  Future<bool> _wouldLoop(String nodeId, String parentId) async {
    var at = parentId as String?;
    final seen = <String>{};
    while (at != null) {
      if (at == nodeId || !seen.add(at)) return true;
      at = await _parentOf(at);
    }
    return false;
  }

  // ------------------------------------------------------- same names (L3)

  /// Two devices can each make `#work` before syncing. Live tags with one
  /// name (ignoring case) in a space merge into the one with the smallest
  /// id: their uses move over, colour and favourite carry over.
  Future<void> mergeTags() async {
    final tags = await (_db.select(
      _db.tags,
    )..where((t) => t.deleted.equals(false))).get();
    final groups = <String, List<Tag>>{};
    for (final t in tags) {
      (groups['${t.spaceId}\u0000${t.name.toLowerCase()}'] ??= []).add(t);
    }
    for (final group in groups.values.where((g) => g.length > 1)) {
      group.sort((a, b) => a.id.compareTo(b.id));
      final keep = group.first;
      var favorite = keep.favorite;
      var kept = keep.kept;
      var color = keep.color;
      for (final other in group.skip(1)) {
        favorite |= other.favorite;
        kept |= other.kept;
        color ??= other.color;
        for (final use
            in await (_db.select(_db.nodeTags)..where(
                  (r) => r.tagId.equals(other.id) & r.deleted.equals(false),
                ))
                .get()) {
          await _writer.upsert(
            _db.nodeTags,
            NodeTagsCompanion(
              id: Value(pairId('node_tags', [use.nodeId, keep.id])),
              spaceId: Value(use.spaceId),
              nodeId: Value(use.nodeId),
              tagId: Value(keep.id),
              origin: Value(use.origin),
              deleted: const Value(false),
            ),
          );
          await _writer.update(
            _db.nodeTags,
            use.id,
            const NodeTagsCompanion(deleted: Value(true)),
          );
        }
        await _writer.update(
          _db.tags,
          other.id,
          const TagsCompanion(deleted: Value(true)),
        );
      }
      if (favorite != keep.favorite ||
          kept != keep.kept ||
          color != keep.color) {
        await _writer.update(
          _db.tags,
          keep.id,
          TagsCompanion(
            favorite: Value(favorite),
            kept: Value(kept),
            color: Value(color),
          ),
        );
      }
    }
  }

  /// Same for values: one name, one value.
  Future<void> mergeValues() async {
    final values = await (_db.select(
      _db.coreValues,
    )..where((v) => v.deleted.equals(false))).get();
    final groups = <String, List<CoreValue>>{};
    for (final v in values) {
      (groups['${v.spaceId}\u0000${v.name.trim().toLowerCase()}'] ??= []).add(
        v,
      );
    }
    for (final group in groups.values.where((g) => g.length > 1)) {
      group.sort((a, b) => a.id.compareTo(b.id));
      final keep = group.first;
      var statement = keep.statement;
      for (final other in group.skip(1)) {
        if (statement.trim().isEmpty) statement = other.statement;
        for (final tie
            in await (_db.select(_db.nodeValues)..where(
                  (r) => r.valueId.equals(other.id) & r.deleted.equals(false),
                ))
                .get()) {
          await _writer.upsert(
            _db.nodeValues,
            NodeValuesCompanion(
              id: Value(pairId('node_values', [tie.nodeId, keep.id])),
              spaceId: Value(tie.spaceId),
              nodeId: Value(tie.nodeId),
              valueId: Value(keep.id),
              deleted: const Value(false),
            ),
          );
          await _writer.update(
            _db.nodeValues,
            tie.id,
            const NodeValuesCompanion(deleted: Value(true)),
          );
        }
        await _writer.update(
          _db.coreValues,
          other.id,
          const CoreValuesCompanion(deleted: Value(true)),
        );
      }
      if (statement != keep.statement) {
        await _writer.update(
          _db.coreValues,
          keep.id,
          CoreValuesCompanion(statement: Value(statement)),
        );
      }
    }
  }

  // ------------------------------------------------------------ timers (L5)

  /// One running timer per user: if two devices each started one, the
  /// older ends where the newer began.
  Future<void> oneRunningTimer() async {
    final running =
        await (_db.select(_db.timeEntries)
              ..where((e) => e.endedAt.isNull() & e.deleted.equals(false))
              ..orderBy([(e) => OrderingTerm.desc(e.startedAt)]))
            .get();
    if (running.length < 2) return;
    final newest = running.first;
    for (final e in running.skip(1)) {
      final end = e.startedAt.isAfter(newest.startedAt)
          ? e.startedAt
          : newest.startedAt;
      await _writer.update(
        _db.timeEntries,
        e.id,
        TimeEntriesCompanion(endedAt: Value(end)),
      );
    }
  }
}

import 'package:drift/drift.dart';

import '../data/database.dart';
import '../sync/change_writer.dart';
import 'ids.dart';
import 'sort_keys.dart';

/// A value on a node: tied to it directly ([from] null), or inherited from
/// the nearest item above it that has it.
class EffectiveValue {
  const EffectiveValue(this.value, this.from);
  final CoreValue value;
  final Node? from;

  bool get inherited => from != null;
}

/// Core values and the nodes tied to them (DESIGN.md §6.2, D6). Personal:
/// values, and which nodes they are tied to, live in your personal space.
class ValueRepository {
  ValueRepository(this._db, this._writer, {required this.spaceId});

  final AppDatabase _db;
  final ChangeWriter _writer;
  final String spaceId;

  static const _maxDepth = 1000;

  SimpleSelectStatement<$CoreValuesTable, CoreValue> _allQuery() =>
      _db.select(_db.coreValues)
        ..where((v) => v.deleted.equals(false))
        ..orderBy([
          (v) => OrderingTerm(expression: v.sortKey),
          (v) => OrderingTerm(expression: v.id),
        ]);

  Future<List<CoreValue>> all() => _allQuery().get();
  Stream<List<CoreValue>> watchAll() => _allQuery().watch();

  Future<CoreValue?> get(String id) => (_db.select(
    _db.coreValues,
  )..where((v) => v.id.equals(id))).getSingleOrNull();

  /// The live value called [name] (any case), if there is one.
  Future<CoreValue?> byName(String name) async {
    final lower = name.toLowerCase();
    return (await all())
        .where((v) => v.name.toLowerCase() == lower)
        .firstOrNull;
  }

  /// Adds a value at the end of the list. Returns its id.
  Future<String> create(
    String name, {
    String statement = '',
    int? color,
    String? icon,
  }) async {
    final last = (await all()).lastOrNull;
    final id = newId();
    await _writer.insert(
      _db.coreValues,
      CoreValuesCompanion(
        id: Value(id),
        spaceId: Value(spaceId),
        name: Value(name.trim()),
        statement: Value(statement),
        color: Value(color),
        icon: Value(icon),
        sortKey: Value(keyBetween(last?.sortKey, null)),
        deleted: const Value(false),
      ),
    );
    return id;
  }

  Future<void> update(String id, CoreValuesCompanion changes) =>
      _writer.update(_db.coreValues, id, changes);

  /// Moves [id] to [index] in the list.
  Future<void> move(String id, int index) async {
    final others = [
      for (final v in await all())
        if (v.id != id) v,
    ];
    final i = index.clamp(0, others.length);
    await update(
      id,
      CoreValuesCompanion(
        sortKey: Value(
          keyBetween(
            i == 0 ? null : others[i - 1].sortKey,
            i == others.length ? null : others[i].sortKey,
          ),
        ),
      ),
    );
  }

  /// Deletes a value, and unties it from every node.
  Future<void> delete(String id) => _db.transaction(() async {
    for (final r in await (_db.select(
      _db.nodeValues,
    )..where((r) => r.valueId.equals(id) & r.deleted.equals(false))).get()) {
      await _writer.update(
        _db.nodeValues,
        r.id,
        const NodeValuesCompanion(deleted: Value(true)),
      );
    }
    await update(id, const CoreValuesCompanion(deleted: Value(true)));
  });

  /// Ties [valueId] to [nodeId]. Already tied: no change.
  Future<void> tie(String nodeId, String valueId) => _db.transaction(() async {
    if ((await _ties(nodeId, valueId)).isNotEmpty) return;
    await _writer.insert(
      _db.nodeValues,
      NodeValuesCompanion(
        id: Value(newId()),
        spaceId: Value(spaceId),
        nodeId: Value(nodeId),
        valueId: Value(valueId),
        deleted: const Value(false),
      ),
    );
  });

  Future<void> untie(String nodeId, String valueId) =>
      _db.transaction(() async {
        for (final r in await _ties(nodeId, valueId)) {
          await _writer.update(
            _db.nodeValues,
            r.id,
            const NodeValuesCompanion(deleted: Value(true)),
          );
        }
      });

  Future<List<NodeValue>> _ties(String nodeId, String valueId) =>
      (_db.select(_db.nodeValues)..where(
            (r) =>
                r.nodeId.equals(nodeId) &
                r.valueId.equals(valueId) &
                r.deleted.equals(false),
          ))
          .get();

  /// The values tied directly to [nodeId], in list order.
  Future<List<CoreValue>> explicitOf(String nodeId) async {
    final q =
        _db.select(_db.coreValues).join([
            innerJoin(
              _db.nodeValues,
              _db.nodeValues.valueId.equalsExp(_db.coreValues.id),
            ),
          ])
          ..where(
            _db.nodeValues.nodeId.equals(nodeId) &
                _db.nodeValues.deleted.equals(false) &
                _db.coreValues.deleted.equals(false),
          )
          ..orderBy([OrderingTerm(expression: _db.coreValues.sortKey)]);
    final seen = <String>{};
    return [
      for (final r in await q.get())
        if (seen.add(r.readTable(_db.coreValues).id))
          r.readTable(_db.coreValues),
    ];
  }

  /// [nodeId]'s values: its own first, then inherited ones, nearest item
  /// above first. "Above" follows the real parent and, for you, the parents
  /// of your shortcuts to it (§5.2).
  Future<List<EffectiveValue>> effectiveOf(String nodeId) async {
    final out = <EffectiveValue>[];
    final seenValues = <String>{};
    for (final v in await explicitOf(nodeId)) {
      if (seenValues.add(v.id)) out.add(EffectiveValue(v, null));
    }
    // Breadth-first, so the nearest ancestor with a value is named.
    final visited = <String>{nodeId};
    var frontier = [nodeId];
    for (var depth = 0; frontier.isNotEmpty && depth < _maxDepth; depth++) {
      final next = <String>[];
      for (final id in frontier) {
        for (final parentId in await _parentsOf(id)) {
          if (!visited.add(parentId)) continue;
          final parent = await (_db.select(
            _db.nodes,
          )..where((n) => n.id.equals(parentId))).getSingleOrNull();
          if (parent == null || parent.deleted) continue;
          for (final v in await explicitOf(parentId)) {
            if (seenValues.add(v.id)) out.add(EffectiveValue(v, parent));
          }
          next.add(parentId);
        }
      }
      frontier = next;
    }
    return out;
  }

  /// Re-reads [effectiveOf] whenever nodes, values or shortcuts change.
  Stream<List<EffectiveValue>> watchEffective(String nodeId) => _db
      .customSelect(
        'SELECT 1 AS effective_values',
        readsFrom: {_db.nodes, _db.coreValues, _db.nodeValues, _db.placements},
      )
      .watch()
      .asyncMap((_) => effectiveOf(nodeId));

  /// Live nodes tied directly to [valueId], goals first, then by title.
  Stream<List<Node>> watchTiedTo(String valueId) {
    final q =
        _db.select(_db.nodes).join([
          innerJoin(
            _db.nodeValues,
            _db.nodeValues.nodeId.equalsExp(_db.nodes.id),
          ),
        ])..where(
          _db.nodeValues.valueId.equals(valueId) &
              _db.nodeValues.deleted.equals(false) &
              _db.nodes.deleted.equals(false) &
              _db.nodes.lifecycle.equals(Lifecycle.live.name),
        );
    return q.watch().map((rows) {
      final seen = <String>{};
      final nodes = [
        for (final r in rows)
          if (seen.add(r.readTable(_db.nodes).id)) r.readTable(_db.nodes),
      ];
      int rank(Node n) => n.type == NodeType.goal ? 0 : 1;
      nodes.sort((a, b) {
        final r = rank(a).compareTo(rank(b));
        return r != 0
            ? r
            : a.title.toLowerCase().compareTo(b.title.toLowerCase());
      });
      return nodes;
    });
  }

  Future<List<String>> _parentsOf(String id) async {
    final node = await (_db.select(
      _db.nodes,
    )..where((n) => n.id.equals(id))).getSingleOrNull();
    final placed = await (_db.select(
      _db.placements,
    )..where((p) => p.nodeId.equals(id) & p.deleted.equals(false))).get();
    return [
      if (node?.parentId != null) node!.parentId!,
      for (final p in placed)
        if (p.parentNodeId != null) p.parentNodeId!,
    ];
  }
}

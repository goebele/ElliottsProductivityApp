import 'package:drift/drift.dart';

import '../data/database.dart';
import '../sync/change_writer.dart';
import 'exclusive_picker.dart';
import 'ids.dart';
import 'repeat_rule.dart';
import 'sort_keys.dart';

export 'exclusive_picker.dart'
    show ExclusiveState, ExclusiveDue, ExclusiveDone, ExclusiveNothingDue;

/// Thrown when a move would put a node under itself or its own descendant.
class MoveWouldCreateCycleException implements Exception {
  MoveWouldCreateCycleException(this.nodeId, this.newParentId);
  final String nodeId;
  final String newParentId;

  @override
  String toString() =>
      'Cannot move $nodeId under $newParentId: it is that node or one of '
      'its ancestors.';
}

/// `YYYY-MM-DD` for an all-day date (as stored in `nodes.due_date`).
String dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// Parses a [dateKey] string to a local midnight.
DateTime parseDateKey(String key) {
  final [y, m, d] = key.split('-').map(int.parse).toList();
  return DateTime(y, m, d);
}

/// Where a node's repeat series starts: its `repeat_start`, else the day it
/// was created.
DateTime seriesStart(Node node) {
  if (node.repeatStart case final key?) return parseDateKey(key);
  final created = node.createdAt.toLocal();
  return DateTime(created.year, created.month, created.day);
}

class NodeWithChildCount {
  const NodeWithChildCount(this.node, this.childCount, {this.noteCount = 0});
  final Node node;

  /// Live items under the node (notes not counted).
  final int childCount;

  /// Live notes under the node.
  final int noteCount;
}

/// Everything the date & time dialog sets. Null fields are cleared.
class NodeDates {
  const NodeDates({
    this.dueDate,
    this.start,
    this.end,
    this.rrule,
    this.repeatStart,
    this.exclusiveChildren = false,
  }) : assert((start == null) == (end == null));

  /// All-day deadline (only the calendar date is used).
  final DateTime? dueDate;

  /// Time slot, which makes the node an event.
  final DateTime? start;
  final DateTime? end;

  /// Repeat rule, which makes the node a routine.
  final String? rrule;

  /// First day of the repeat series (only the calendar date is used).
  final DateTime? repeatStart;

  /// Children take turns, one per occurrence (D36).
  final bool exclusiveChildren;
}

/// What an exclusive set (D36) looks like right now, for the UI.
class ExclusiveStatus {
  const ExclusiveStatus(this.state, this.children, this.lastDone);

  final ExclusiveState state;

  /// The set's members in list order.
  final List<Node> children;

  /// Occurrence date of each child's latest completion (absent = never).
  final Map<String, DateTime> lastDone;

  Node? child(String id) => children.where((c) => c.id == id).firstOrNull;
}

/// Reads and writes the node tree (DESIGN.md §5.2, §5.3, §6.1).
///
/// Lists of children only include live (not archived or trashed), non-deleted
/// nodes. Positions (`index`) refer to that visible list.
/// Done or dropped: shown struck through and dimmed.
bool isFinished(NodeStatus status) =>
    status == NodeStatus.done || status == NodeStatus.dropped;

/// A repeating item's current occurrence. [period] is null before the
/// series starts on [seriesStart].
class OccurrenceStatus {
  const OccurrenceStatus(this.period, this.done, this.seriesStart);
  final DateTime? period;
  final bool done;
  final DateTime seriesStart;
}

/// A group in the Archive or Trash: the node that was removed, how many
/// items went with it, and the title of the item it was under.
class RemovedGroup {
  const RemovedGroup(this.root, {required this.others, this.parentTitle});
  final Node root;
  final int others;
  final String? parentTitle;
}

class NodeRepository {
  NodeRepository(
    this._db,
    this._writer, {
    required this.personalSpaceId,
    required this.userId,
  });

  final AppDatabase _db;
  final ChangeWriter _writer;
  final String personalSpaceId;
  final String userId;

  /// Guards ancestor walks against a cycle that slipped in via sync.
  static const _maxDepth = 1000;

  // ---------------------------------------------------------------- reads

  Future<Node?> get(String id) =>
      (_db.select(_db.nodes)..where((n) => n.id.equals(id))).getSingleOrNull();

  Stream<Node?> watch(String id) => (_db.select(
    _db.nodes,
  )..where((n) => n.id.equals(id))).watchSingleOrNull();

  /// Live items under [parentId] (null = top level), in sibling order.
  ///
  /// Notes under an item are not items: they are listed by [notes] instead.
  /// At the top level there is no notes column, so top-level notes are
  /// included here rather than vanishing.
  Future<List<Node>> children(String? parentId) =>
      _childrenQuery(parentId, notes: parentId == null ? null : false).get();

  Stream<List<Node>> watchChildren(String? parentId) =>
      _childrenQuery(parentId, notes: parentId == null ? null : false).watch();

  /// Live notes under [parentId], in sibling order.
  Future<List<Node>> notes(String parentId) =>
      _childrenQuery(parentId, notes: true).get();

  Stream<List<Node>> watchNotes(String parentId) =>
      _childrenQuery(parentId, notes: true).watch();

  /// [notes]: true = only notes, false = no notes, null = both.
  SimpleSelectStatement<$NodesTable, Node> _childrenQuery(
    String? parentId, {
    required bool? notes,
  }) {
    return _db.select(_db.nodes)
      ..where((n) {
        var where =
            (parentId == null
                ? n.parentId.isNull()
                : n.parentId.equals(parentId)) &
            n.deleted.equals(false) &
            n.lifecycle.equalsValue(Lifecycle.live);
        if (notes != null) {
          final isNote = n.type.equalsValue(NodeType.note);
          where = where & (notes ? isNote : isNote.not());
        }
        return where;
      })
      ..orderBy([
        (n) => OrderingTerm.asc(n.sortKey),
        (n) => OrderingTerm.asc(n.id),
      ]);
  }

  /// Live items under [parentId] (as [children]) with how many items and
  /// notes each has, for tree rows and item lists. Re-emits on any node
  /// change.
  Stream<List<NodeWithChildCount>> watchChildrenWithCounts(String? parentId) {
    final live = Lifecycle.live.name;
    final note = NodeType.note.name;
    String countOf(String typeTest) =>
        '''
        (SELECT COUNT(*) FROM nodes c
         WHERE c.parent_id = n.id AND c.deleted = 0 AND c.lifecycle = '$live'
           AND c.type $typeTest)''';
    return _db
        .customSelect(
          '''
      SELECT n.*,
        ${countOf("<> '$note'")} AS child_count,
        ${countOf("= '$note'")} AS note_count
      FROM nodes n
      WHERE ${parentId == null ? 'n.parent_id IS NULL' : "n.parent_id = ?1 AND n.type <> '$note'"}
        AND n.deleted = 0 AND n.lifecycle = '$live'
      ORDER BY n.sort_key, n.id
      ''',
          variables: [if (parentId != null) Variable.withString(parentId)],
          readsFrom: {_db.nodes},
        )
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              NodeWithChildCount(
                _db.nodes.map(row.data),
                row.read<int>('child_count'),
                noteCount: row.read<int>('note_count'),
              ),
          ],
        );
  }

  /// The node's ancestors from the top-level node down to its parent.
  /// Looked up on the fly; nothing is stored (D20).
  Future<List<Node>> ancestors(String id) => _ancestorsQuery(id).get();

  /// Like [ancestors], re-emitting when any node changes (renames, moves).
  Stream<List<Node>> watchAncestors(String id) => _ancestorsQuery(id).watch();

  MultiSelectable<Node> _ancestorsQuery(String id) {
    return _db
        .customSelect(
          '''
      WITH RECURSIVE anc(id, parent_id, depth) AS (
        SELECT id, parent_id, 0 FROM nodes WHERE id = ?1
        UNION ALL
        SELECT n.id, n.parent_id, anc.depth + 1
        FROM nodes n JOIN anc ON n.id = anc.parent_id
        WHERE anc.depth < ?2
      )
      SELECT nodes.* FROM anc JOIN nodes ON nodes.id = anc.id
      WHERE anc.depth > 0
      ORDER BY anc.depth DESC
      ''',
          variables: [Variable.withString(id), Variable.withInt(_maxDepth)],
          readsFrom: {_db.nodes},
        )
        .map((row) => _db.nodes.map(row.data));
  }

  // --------------------------------------------------------------- writes

  /// Creates a node under [parentId] (null = top level) at [index] among its
  /// live siblings (null = at the end). Returns the new node's ID.
  ///
  /// A child joins its parent's space, so a subtask of a shared task is
  /// shared too (§5.3).
  Future<String> create({
    required String title,
    NodeType type = NodeType.task,
    String? parentId,
    int? index,
    String bodyMd = '',
  }) async {
    final spaceId = parentId == null
        ? personalSpaceId
        : (await _require(parentId)).spaceId;
    final id = newId();
    await _writer.insert(
      _db.nodes,
      NodesCompanion(
        id: Value(id),
        spaceId: Value(spaceId),
        parentId: Value(parentId),
        sortKey: Value(await _keyAt(parentId, index)),
        type: Value(type),
        title: Value(title),
        bodyMd: Value(bodyMd),
        bodyFormat: const Value('md_lww'),
        status: const Value(NodeStatus.open),
        lifecycle: const Value(Lifecycle.live),
        deleted: const Value(false),
      ),
    );
    return id;
  }

  /// Writes the fields set in [changes]. Use the specific methods below for
  /// status, moves and archive/trash, which keep related fields in step.
  Future<void> update(String id, NodesCompanion changes) =>
      _writer.update(_db.nodes, id, changes);

  Future<void> rename(String id, String title) =>
      update(id, NodesCompanion(title: Value(title)));

  Future<void> setBody(String id, String bodyMd) =>
      update(id, NodesCompanion(bodyMd: Value(bodyMd)));

  Future<void> setType(String id, NodeType type) =>
      update(id, NodesCompanion(type: Value(type)));

  /// Sets the status, and the completion fields along with it.
  Future<void> setStatus(String id, NodeStatus status, {DateTime? now}) {
    final done = status == NodeStatus.done;
    return update(
      id,
      NodesCompanion(
        status: Value(status),
        completedAt: Value(done ? (now ?? DateTime.now()).toUtc() : null),
        completedBy: Value(done ? userId : null),
      ),
    );
  }

  /// Sets or clears (null) an all-day deadline. Only the calendar date of
  /// [date] is kept.
  Future<void> setDueDate(String id, DateTime? date) => update(
    id,
    NodesCompanion(dueDate: Value(date == null ? null : dateKey(date))),
  );

  /// Gives the node a time slot, making it an event (both null clears it).
  Future<void> setSchedule(String id, {DateTime? start, DateTime? end}) {
    assert((start == null) == (end == null));
    assert(start == null || !end!.isBefore(start));
    return update(
      id,
      NodesCompanion(
        startAt: Value(start?.toUtc()),
        endAt: Value(end?.toUtc()),
        // TODO(M5): store the device's IANA zone so repeats survive DST.
      ),
    );
  }

  /// Sets or clears the RRULE that makes the node a routine (D11, D24).
  /// Clearing it also clears the series start and one-at-a-time children.
  Future<void> setRepeat(String id, String? rrule) => update(
    id,
    NodesCompanion(
      rrule: Value(rrule),
      repeatStart: rrule == null ? const Value(null) : const Value.absent(),
      exclusiveChildren: rrule == null
          ? const Value(false)
          : const Value.absent(),
    ),
  );

  /// Saves everything from the date & time dialog in one change.
  Future<void> setDates(String id, NodeDates s) {
    assert(s.start == null || !s.end!.isBefore(s.start!));
    return update(
      id,
      NodesCompanion(
        dueDate: Value(s.dueDate == null ? null : dateKey(s.dueDate!)),
        startAt: Value(s.start?.toUtc()),
        endAt: Value(s.end?.toUtc()),
        rrule: Value(s.rrule),
        repeatStart: Value(
          s.rrule == null || s.repeatStart == null
              ? null
              : dateKey(s.repeatStart!),
        ),
        exclusiveChildren: Value(s.rrule != null && s.exclusiveChildren),
      ),
    );
  }

  // ------------------------------------------------------ archive & trash

  /// How long trashed items are kept before they are purged (§6.11).
  static const trashDays = 30;

  /// How many live items go along with [id] when it is archived or trashed
  /// (its descendants, notes included; not [id] itself).
  Future<int> subtreeSize(String id) async =>
      (await _liveDescendants(id)).length;

  /// Hides [id] and its live descendants as one group, kept indefinitely.
  Future<void> archive(String id, {DateTime? now}) =>
      _remove(id, Lifecycle.archived, now);

  /// Moves [id] and its live descendants to Trash as one group, purged after
  /// [trashDays]. An archived group moves to Trash whole.
  Future<void> trash(String id, {DateTime? now}) =>
      _remove(id, Lifecycle.trashed, now);

  Future<void> _remove(String id, Lifecycle to, DateTime? now) async {
    final node = await _require(id);
    final at = (now ?? DateTime.now()).toUtc();
    await _db.transaction(() async {
      final ids = {
        id,
        ...await _liveDescendants(id),
        if (node.lifecycle != Lifecycle.live && node.lifecycleRootId == id)
          ...await _groupIds(id),
      };
      for (final nid in ids) {
        await update(
          nid,
          NodesCompanion(
            lifecycle: Value(to),
            lifecycleAt: Value(at),
            lifecycleRootId: Value(id),
          ),
        );
      }
    });
  }

  /// Brings back the group that was archived or trashed with [rootId].
  /// Items archived separately before stay archived. If the place it came
  /// from is gone (its parent was archived, trashed or purged since), it
  /// comes back at the end of the top level; returns true in that case.
  Future<bool> restore(String rootId) async {
    final root = await _require(rootId);
    final parent = root.parentId == null ? null : await get(root.parentId!);
    final orphaned =
        root.parentId != null &&
        (parent == null ||
            parent.deleted ||
            parent.lifecycle != Lifecycle.live);
    await _db.transaction(() async {
      for (final nid in await _groupIds(rootId)) {
        await update(
          nid,
          const NodesCompanion(
            lifecycle: Value(Lifecycle.live),
            lifecycleAt: Value(null),
            lifecycleRootId: Value(null),
          ),
        );
      }
      if (orphaned) {
        await update(
          rootId,
          NodesCompanion(
            parentId: const Value(null),
            sortKey: Value(await _keyAt(null, null, excluding: rootId)),
          ),
        );
      }
    });
    return orphaned;
  }

  /// Deletes a trashed group for good: its rows become tombstones (§5.3).
  Future<void> purge(String rootId) async {
    await _db.transaction(() async {
      for (final nid in await _groupIds(rootId)) {
        await update(nid, const NodesCompanion(deleted: Value(true)));
      }
    });
  }

  /// Purges everything in Trash.
  Future<void> emptyTrash() async {
    for (final g in await removedGroups(Lifecycle.trashed)) {
      await purge(g.root.id);
    }
  }

  /// Purges groups that have been in Trash for [trashDays] or more.
  Future<void> purgeExpiredTrash({DateTime? now}) async {
    final cutoff = (now ?? DateTime.now()).toUtc().subtract(
      const Duration(days: trashDays),
    );
    for (final g in await removedGroups(Lifecycle.trashed)) {
      final at = g.root.lifecycleAt;
      if (at != null && !at.isAfter(cutoff)) await purge(g.root.id);
    }
  }

  /// The groups in the Archive or Trash, most recent first.
  Future<List<RemovedGroup>> removedGroups(Lifecycle which) =>
      _removedQuery(which).get();

  Stream<List<RemovedGroup>> watchRemovedGroups(Lifecycle which) =>
      _removedQuery(which).watch();

  /// How many groups are in the Archive and in Trash.
  Stream<Map<Lifecycle, int>> watchRemovedCounts() => _db
      .customSelect(
        'SELECT lifecycle, COUNT(*) AS n FROM nodes '
        'WHERE deleted = 0 AND lifecycle_root_id = id AND lifecycle <> ?1 '
        'GROUP BY lifecycle',
        variables: [Variable.withString(Lifecycle.live.name)],
        readsFrom: {_db.nodes},
      )
      .watch()
      .map(
        (rows) => {
          for (final r in rows)
            for (final l in Lifecycle.values)
              if (l.name == r.read<String>('lifecycle')) l: r.read<int>('n'),
        },
      );

  MultiSelectable<RemovedGroup> _removedQuery(Lifecycle which) => _db
      .customSelect(
        '''
        SELECT n.*,
          (SELECT COUNT(*) FROM nodes c
           WHERE c.lifecycle_root_id = n.id AND c.id <> n.id
             AND c.deleted = 0) AS others,
          (SELECT p.title FROM nodes p WHERE p.id = n.parent_id) AS parent_title
        FROM nodes n
        WHERE n.deleted = 0 AND n.lifecycle = ?1 AND n.lifecycle_root_id = n.id
        ORDER BY n.lifecycle_at DESC, n.id
        ''',
        variables: [Variable.withString(which.name)],
        readsFrom: {_db.nodes},
      )
      .map(
        (row) => RemovedGroup(
          _db.nodes.map(row.data),
          others: row.read<int>('others'),
          parentTitle: row.readNullable<String>('parent_title'),
        ),
      );

  Future<List<String>> _liveDescendants(String id) async {
    final rows = await _db
        .customSelect(
          '''
      WITH RECURSIVE sub(id, depth) AS (
        SELECT id, 0 FROM nodes WHERE id = ?1
        UNION ALL
        SELECT n.id, sub.depth + 1 FROM nodes n JOIN sub ON n.parent_id = sub.id
        WHERE n.deleted = 0 AND n.lifecycle = ?2 AND sub.depth < ?3
      )
      SELECT id FROM sub WHERE depth > 0
      ''',
          variables: [
            Variable.withString(id),
            Variable.withString(Lifecycle.live.name),
            Variable.withInt(_maxDepth),
          ],
          readsFrom: {_db.nodes},
        )
        .get();
    return [for (final r in rows) r.read<String>('id')];
  }

  /// Every row in the group archived or trashed with [rootId].
  Future<List<String>> _groupIds(String rootId) async {
    final rows =
        await (_db.selectOnly(_db.nodes)
              ..addColumns([_db.nodes.id])
              ..where(
                _db.nodes.lifecycleRootId.equals(rootId) &
                    _db.nodes.deleted.equals(false),
              ))
            .get();
    return [for (final r in rows) r.read(_db.nodes.id)!];
  }

  // ---------------------------------------------------------- occurrences

  /// Records that [nodeId] was done for the occurrence on [occurrenceDate].
  /// Doing it twice for the same occurrence changes nothing.
  Future<void> completeOccurrence(
    String nodeId,
    DateTime occurrenceDate, {
    DateTime? now,
  }) async {
    final node = await _require(nodeId);
    final key = dateKey(occurrenceDate);
    if (await _completion(nodeId, key) != null) return;
    final at = (now ?? DateTime.now()).toUtc();
    await _writer.insert(
      _db.occurrenceCompletions,
      OccurrenceCompletionsCompanion(
        id: Value(newId()),
        spaceId: Value(node.spaceId),
        nodeId: Value(nodeId),
        occurrenceDate: Value(key),
        completedBy: Value(userId),
        completedAt: Value(at),
        deleted: const Value(false),
      ),
      now: at,
    );
  }

  /// Undoes [completeOccurrence] (as a tombstone, so the undo syncs).
  Future<void> uncompleteOccurrence(
    String nodeId,
    DateTime occurrenceDate,
  ) async {
    final row = await _completion(nodeId, dateKey(occurrenceDate));
    if (row == null) return;
    await _writer.update(
      _db.occurrenceCompletions,
      row.id,
      const OccurrenceCompletionsCompanion(deleted: Value(true)),
    );
  }

  /// For a repeating item: its current occurrence (the latest one on or
  /// before [today]) and whether that was done. Null if the item doesn't
  /// repeat (or its rule isn't one this version understands).
  Future<OccurrenceStatus?> occurrenceStatus(
    String id, {
    required DateTime today,
  }) async {
    final node = await get(id);
    final rule = node?.rrule == null ? null : RepeatRule.parse(node!.rrule!);
    if (node == null || rule == null) return null;
    final period = rule.lastOnOrBefore(today, seriesStart(node));
    if (period == null) return OccurrenceStatus(null, false, seriesStart(node));
    final done = await _completion(id, dateKey(period)) != null;
    return OccurrenceStatus(period, done, seriesStart(node));
  }

  /// [occurrenceStatus], live; [today] is read on each emission.
  Stream<OccurrenceStatus?> watchOccurrence(
    String id, {
    DateTime Function()? today,
  }) {
    return _db
        .customSelect(
          'SELECT 1',
          readsFrom: {_db.nodes, _db.occurrenceCompletions},
        )
        .watch()
        .asyncMap(
          (_) => occurrenceStatus(id, today: (today ?? DateTime.now)()),
        );
  }

  Future<OccurrenceCompletion?> _completion(String nodeId, String key) =>
      (_db.select(_db.occurrenceCompletions)
            ..where(
              (c) =>
                  c.nodeId.equals(nodeId) &
                  c.occurrenceDate.equals(key) &
                  c.deleted.equals(false),
            )
            ..limit(1))
          .getSingleOrNull();

  /// The exclusive set under [parentId] right now, or null if the parent
  /// isn't a repeating item with one-at-a-time children. Re-emits whenever
  /// nodes or completions change; [today] is read on each emission.
  Stream<ExclusiveStatus?> watchExclusive(
    String parentId, {
    DateTime Function()? today,
  }) {
    return _db
        .customSelect(
          'SELECT 1',
          readsFrom: {_db.nodes, _db.occurrenceCompletions},
        )
        .watch()
        .asyncMap(
          (_) => exclusiveStatus(parentId, today: (today ?? DateTime.now)()),
        );
  }

  Future<ExclusiveStatus?> exclusiveStatus(
    String parentId, {
    required DateTime today,
  }) async {
    final parent = await get(parentId);
    final rrule = parent?.rrule;
    if (parent == null || !parent.exclusiveChildren || rrule == null) {
      return null;
    }
    final parentRule = RepeatRule.parse(rrule);
    if (parentRule == null) return null;

    final children = [
      for (final c in await this.children(parentId))
        if (c.status != NodeStatus.dropped) c,
    ];
    final lastDone = await _lastDone([for (final c in children) c.id]);

    final state = pickExclusive(
      parentRule: parentRule,
      parentStart: seriesStart(parent),
      today: today,
      children: [
        for (final c in children)
          ExclusiveChild(
            id: c.id,
            rule: c.rrule == null ? null : RepeatRule.parse(c.rrule!),
            start: seriesStart(c),
            lastDone: lastDone[c.id],
          ),
      ],
    );
    return ExclusiveStatus(state, children, lastDone);
  }

  Future<Map<String, DateTime>> _lastDone(List<String> nodeIds) async {
    if (nodeIds.isEmpty) return const {};
    final latest = _db.occurrenceCompletions.occurrenceDate.max();
    final rows =
        await (_db.selectOnly(_db.occurrenceCompletions)
              ..addColumns([_db.occurrenceCompletions.nodeId, latest])
              ..where(
                _db.occurrenceCompletions.nodeId.isIn(nodeIds) &
                    _db.occurrenceCompletions.deleted.equals(false),
              )
              ..groupBy([_db.occurrenceCompletions.nodeId]))
            .get();
    return {
      for (final r in rows)
        r.read(_db.occurrenceCompletions.nodeId)!: parseDateKey(
          r.read(latest)!,
        ),
    };
  }

  /// Shows the node's children as a checklist ("show as list") or panels.
  Future<void> setShowAsList(String id, bool asList) => update(
    id,
    NodesCompanion(childView: Value(asList ? ChildView.checklist : null)),
  );

  /// Moves [id] under [newParentId] (null = top level) at [index] among the
  /// new parent's live children, not counting the node itself (null = end).
  /// Reordering within the same parent is a move to the same parent.
  ///
  /// Only `parent_id` and `sort_key` change (§5.3).
  Future<void> move(String id, {String? newParentId, int? index}) async {
    await _require(id);
    if (newParentId != null) {
      if (newParentId == id ||
          (await ancestors(newParentId)).any((n) => n.id == id)) {
        throw MoveWouldCreateCycleException(id, newParentId);
      }
      await _require(newParentId);
    }
    // TODO(sharing): moving across spaces re-tags the subtree (§11.5).
    await update(
      id,
      NodesCompanion(
        parentId: Value(newParentId),
        sortKey: Value(await _keyAt(newParentId, index, excluding: id)),
      ),
    );
  }

  // -------------------------------------------------------------- helpers

  Future<Node> _require(String id) async {
    final node = await get(id);
    if (node == null || node.deleted) {
      throw StateError('No node with id $id.');
    }
    return node;
  }

  /// A sort key that places a node at [index] among [parentId]'s children.
  Future<String> _keyAt(
    String? parentId,
    int? index, {
    String? excluding,
  }) async {
    final siblings = [
      for (final n in await children(parentId))
        if (n.id != excluding) n,
    ];
    final at = (index ?? siblings.length).clamp(0, siblings.length);
    final before = at == 0 ? null : siblings[at - 1].sortKey;
    // Two devices can pick the same key for different nodes; the list then
    // orders them by id. There is no key strictly between equal keys, so use
    // the next larger one: the node lands just after the tied group.
    String? after;
    for (var i = at; i < siblings.length; i++) {
      if (before == null || siblings[i].sortKey.compareTo(before) > 0) {
        after = siblings[i].sortKey;
        break;
      }
    }
    return keyBetween(before, after);
  }
}

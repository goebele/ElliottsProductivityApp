import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/blob_store.dart';
import '../data/database.dart';
import '../sync/change_writer.dart';
import 'attachment_repository.dart';
import 'calendar.dart';
import 'exclusive_picker.dart';
import 'ids.dart';
import 'repeat_rule.dart';
import 'search.dart';
import 'sort_keys.dart';
import 'tag_repository.dart';
import 'value_repository.dart';

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
  const NodeWithChildCount(
    this.node,
    this.childCount, {
    this.noteCount = 0,
    this.doneCount = 0,
    this.placementId,
  });
  final Node node;

  /// Set when this row is one of your shortcuts (§6.12) rather than the
  /// node's real place.
  final String? placementId;
  bool get isShortcut => placementId != null;

  /// Identifies the row among its siblings: a node can show both in its real
  /// place and as a shortcut, but never twice under one parent.
  String get key => placementId ?? node.id;

  /// Live items under the node (notes not counted).
  final int childCount;

  /// How many of those are done or dropped, for progress bars.
  final int doneCount;

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

/// A repeating item's current occurrence, or that of the repeating item an
/// item sits inside (D24). [period] is null before the series starts on
/// [seriesStart].
class OccurrenceStatus {
  const OccurrenceStatus(
    this.period,
    this.done,
    this.seriesStart, {
    this.repeatsWith,
  });
  final DateTime? period;
  final bool done;
  final DateTime seriesStart;

  /// The repeating item above whose occurrences this one follows; null if
  /// it repeats itself.
  final Node? repeatsWith;
}

/// A group in the Archive or Trash: the node that was removed, how many
/// items went with it, and the title of the item it was under.
class RemovedGroup {
  const RemovedGroup(this.root, {required this.others, this.parentTitle});
  final Node root;
  final int others;
  final String? parentTitle;
}

/// One of a node's shortcuts and where it shows ([parentId] null = the top
/// level).
/// How a group is used outside itself (§6.11), shown before removing it.
class ExternalUses {
  const ExternalUses({this.linkingItems = 0, this.shortcuts = 0});

  /// Live items outside the group that link one of its notes.
  final int linkingItems;

  /// Shortcuts to items in the group placed outside it.
  final int shortcuts;

  bool get isEmpty => linkingItems == 0 && shortcuts == 0;
}

class PlacementInfo {
  const PlacementInfo(this.id, this.parentId, this.parentTitle);
  final String id;
  final String? parentId;
  final String? parentTitle;
}

/// What the "Also show in…" picker offers: live items in tree order with
/// their depth, and the ones the node can't go under.
class PlacementChoices {
  const PlacementChoices({
    required this.items,
    required this.blocked,
    required this.topLevelAllowed,
  });
  final List<(Node, int)> items;
  final Set<String> blocked;
  final bool topLevelAllowed;
}

class PlacementNotAllowedException implements Exception {
  const PlacementNotAllowedException(this.reason);
  final String reason;

  @override
  String toString() => 'PlacementNotAllowedException: $reason';
}

/// A note linked into an item (§6.10). [note] is null once the note is
/// purged; otherwise it may be live, archived or trashed. [owner] is the
/// item the note belongs to.
class LinkedNote {
  const LinkedNote(this.noteId, this.note, this.owner, {this.shared = false});
  final String noteId;
  final Node? note;
  final Node? owner;

  /// Comes from an ancestor sharing the note with all its sub-items, not
  /// from a link on this item; it can't be unlinked here.
  final bool shared;
}

class NodeRepository {
  NodeRepository(
    this._db,
    this._writer, {
    required this.personalSpaceId,
    required this.userId,
    this.blobStore,
  });

  final AppDatabase _db;

  /// Where attachment files live; only needed for [files].
  final BlobStore? blobStore;
  final ChangeWriter _writer;
  final String personalSpaceId;
  final String userId;

  /// Tags (§6.14). Inline `#tags` are kept in step on every title or text
  /// change made here.
  late final tags = TagRepository(_db, _writer, spaceId: personalSpaceId);

  /// Core values (§6.2).
  late final values = ValueRepository(_db, _writer, spaceId: personalSpaceId);

  /// Search (§6.6).
  late final search = SearchService(_db);

  /// Calendar entries (§6.5).
  late final calendar = CalendarService(_db, this);

  /// Reminders (§6.5), personal.
  late final reminders = ReminderRepository(
    _db,
    _writer,
    calendar,
    spaceId: personalSpaceId,
  );

  /// Personal per-item settings (§5.0).
  late final prefs = PrefsRepository(_db, _writer, spaceId: personalSpaceId);

  /// Attachments and markup (§6.4). Needs the blob store.
  late final files = AttachmentRepository(
    _db,
    _writer,
    blobStore ?? (throw StateError('No blob store')),
  );

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
    // Items under n: real children plus your shortcuts there.
    String countOf(String typeTest) =>
        '''
        ((SELECT COUNT(*) FROM nodes c
          WHERE c.parent_id = n.id AND c.deleted = 0 AND c.lifecycle = '$live'
            AND c.type $typeTest)
         + (SELECT COUNT(*) FROM placements pp JOIN nodes c ON c.id = pp.node_id
          WHERE pp.parent_node_id = n.id AND pp.deleted = 0 AND c.deleted = 0
            AND c.lifecycle = '$live' AND c.type $typeTest))''';
    final counts =
        '''
        ${countOf("<> '$note'")} AS child_count,
        ${countOf("= '$note'")} AS note_count,
        ${countOf("<> '$note' AND c.status IN ('done', 'dropped')")} AS done_count''';
    final top = parentId == null;
    return _db
        .customSelect(
          '''
      SELECT n.*, $counts, NULL AS placement_id,
        n.sort_key AS display_key, n.id AS entry_key
      FROM nodes n
      WHERE ${top ? 'n.parent_id IS NULL' : "n.parent_id = ?1 AND n.type <> '$note'"}
        AND n.deleted = 0 AND n.lifecycle = '$live'
      UNION ALL
      SELECT n.*, $counts, p.id AS placement_id,
        p.sort_key AS display_key, p.id AS entry_key
      FROM placements p JOIN nodes n ON n.id = p.node_id
      WHERE ${top ? 'p.parent_node_id IS NULL' : 'p.parent_node_id = ?1'}
        AND p.deleted = 0 AND n.deleted = 0 AND n.lifecycle = '$live'
        AND n.type <> '$note'
      ORDER BY display_key, entry_key
      ''',
          variables: [if (!top) Variable.withString(parentId)],
          readsFrom: {_db.nodes, _db.placements},
        )
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              NodeWithChildCount(
                _db.nodes.map(row.data),
                row.read<int>('child_count'),
                noteCount: row.read<int>('note_count'),
                doneCount: row.read<int>('done_count'),
                placementId: row.readNullable<String>('placement_id'),
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
    if (title.contains('#') || bodyMd.contains('#')) {
      await tags.syncInline(id, title, bodyMd);
    }
    return id;
  }

  /// Writes the fields set in [changes]. Use the specific methods below for
  /// status, moves and archive/trash, which keep related fields in step.
  Future<void> update(String id, NodesCompanion changes) async {
    await _writer.update(_db.nodes, id, changes);
    if (changes.title.present || changes.bodyMd.present) {
      final node = await get(id);
      if (node != null) await tags.syncInline(id, node.title, node.bodyMd);
    }
  }

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
        // The zone it was set in, so a repeat keeps its wall-clock time
        // across daylight-saving changes (§6.5).
        timeZone: Value(start == null ? null : deviceTimeZone),
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
        timeZone: Value(s.start == null ? null : deviceTimeZone),
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

  /// Items outside the group that [rootId] heads which use it: they link
  /// one of its notes, or show one of its items through a shortcut. For a
  /// live item the group is it and its live descendants; for a removed one,
  /// the group it was archived or trashed with.
  Future<ExternalUses> externalUses(String rootId) async {
    final root = await get(rootId);
    if (root == null || root.deleted) return const ExternalUses();
    final ids = root.lifecycle == Lifecycle.live
        ? {rootId, ...await _liveDescendants(rootId)}
        : {...await _groupIds(rootId)};
    final group = Variable.withString(jsonEncode(ids.toList()));

    final linking = await _db
        .customSelect(
          '''
          SELECT DISTINCT l.from_node_id AS id FROM links l
          JOIN nodes f ON f.id = l.from_node_id
          WHERE l.deleted = 0
            AND ((l.target_kind = ?2
                  AND l.target_id IN (SELECT value FROM json_each(?1)))
              OR (l.target_kind = 'attachment' AND l.target_id IN (
                  SELECT a.id FROM attachments a
                  WHERE a.deleted = 0
                    AND a.node_id IN (SELECT value FROM json_each(?1)))))
            AND f.deleted = 0 AND f.lifecycle = ?3
          ''',
          variables: [
            group,
            Variable.withString(LinkKind.note.name),
            Variable.withString(Lifecycle.live.name),
          ],
          readsFrom: {_db.links, _db.nodes, _db.attachments},
        )
        .get();

    // Shortcuts at the top level, or under a live item outside the group.
    final shortcuts = await _db
        .customSelect(
          '''
          SELECT p.parent_node_id AS parent FROM placements p
          LEFT JOIN nodes q ON q.id = p.parent_node_id
          WHERE p.deleted = 0
            AND p.node_id IN (SELECT value FROM json_each(?1))
            AND (p.parent_node_id IS NULL
                 OR (q.deleted = 0 AND q.lifecycle = ?2))
          ''',
          variables: [group, Variable.withString(Lifecycle.live.name)],
          readsFrom: {_db.placements, _db.nodes},
        )
        .get();

    return ExternalUses(
      linkingItems: linking
          .where((r) => !ids.contains(r.read<String>('id')))
          .length,
      shortcuts: shortcuts
          .where((r) => !ids.contains(r.read<String?>('parent')))
          .length,
    );
  }

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

  // ----------------------------------------------------------- placements

  /// Shows [nodeId] also under [parentId] (null = the top level), for you
  /// only (§6.12). Returns the placement id.
  Future<String> addPlacement(
    String nodeId,
    String? parentId, {
    int? index,
  }) async {
    final node = await _require(nodeId);
    await _checkPlacement(node, parentId);
    final id = newId();
    await _writer.insert(
      _db.placements,
      PlacementsCompanion(
        id: Value(id),
        spaceId: Value(personalSpaceId),
        nodeId: Value(nodeId),
        parentNodeId: Value(parentId),
        sortKey: Value(await _keyAt(parentId, index)),
        deleted: const Value(false),
      ),
    );
    return id;
  }

  /// Moves a shortcut to [index] under [newParentId]; the real node stays.
  Future<void> movePlacement(
    String placementId, {
    String? newParentId,
    int? index,
  }) async {
    final p = await _placement(placementId);
    final node = await _require(p.nodeId);
    if (newParentId != p.parentNodeId) {
      await _checkPlacement(node, newParentId);
    }
    await _writer.update(
      _db.placements,
      placementId,
      PlacementsCompanion(
        parentNodeId: Value(newParentId),
        sortKey: Value(
          await _keyAt(newParentId, index, excluding: placementId),
        ),
      ),
    );
  }

  Future<void> removePlacement(String placementId) => _writer.update(
    _db.placements,
    placementId,
    const PlacementsCompanion(deleted: Value(true)),
  );

  /// The node's shortcuts, with where each one shows.
  Stream<List<PlacementInfo>> watchPlacementsOf(String nodeId) => _db
      .customSelect(
        '''
        SELECT p.id, p.parent_node_id, parent.title AS parent_title
        FROM placements p LEFT JOIN nodes parent ON parent.id = p.parent_node_id
        WHERE p.node_id = ?1 AND p.deleted = 0
        ORDER BY p.created_at, p.id
        ''',
        variables: [Variable.withString(nodeId)],
        readsFrom: {_db.placements, _db.nodes},
      )
      .watch()
      .map(
        (rows) => [
          for (final r in rows)
            PlacementInfo(
              r.read<String>('id'),
              r.readNullable<String>('parent_node_id'),
              r.readNullable<String>('parent_title'),
            ),
        ],
      );

  /// Every live item in tree order with its depth, and which of them [nodeId]
  /// may be shown under (for the "Also show in…" picker).
  Future<PlacementChoices> placementChoices(String nodeId) async {
    final node = await _require(nodeId);
    final all =
        await (_db.select(_db.nodes)
              ..where(
                (n) =>
                    n.deleted.equals(false) &
                    n.lifecycle.equalsValue(Lifecycle.live) &
                    n.type.equalsValue(NodeType.note).not(),
              )
              ..orderBy([
                (n) => OrderingTerm.asc(n.sortKey),
                (n) => OrderingTerm.asc(n.id),
              ]))
            .get();
    final byParent = <String?, List<Node>>{};
    final ids = {for (final n in all) n.id};
    for (final n in all) {
      // A parent that isn't listed (archived, say) hides its subtree.
      if (n.parentId == null || ids.contains(n.parentId)) {
        byParent.putIfAbsent(n.parentId, () => []).add(n);
      }
    }
    final ordered = <(Node, int)>[];
    void walk(String? parent, int depth) {
      for (final n in byParent[parent] ?? const <Node>[]) {
        ordered.add((n, depth));
        if (depth < _maxDepth) walk(n.id, depth + 1);
      }
    }

    walk(null, 0);
    final placed = {
      for (final p in await _livePlacements(nodeId: nodeId)) p.parentNodeId,
    };
    final blocked = {
      nodeId,
      ...await _shownUnder(nodeId),
      ?node.parentId,
      for (final p in placed) ?p,
    };
    return PlacementChoices(
      items: ordered,
      blocked: blocked,
      topLevelAllowed: node.parentId != null && !placed.contains(null),
    );
  }

  Future<void> _checkPlacement(Node node, String? parentId) async {
    if (node.type == NodeType.note) {
      throw const PlacementNotAllowedException('Notes have no shortcuts.');
    }
    if (parentId == node.parentId) {
      throw const PlacementNotAllowedException('That is where it really is.');
    }
    if ((await _livePlacements(nodeId: node.id))
        .any((p) => p.parentNodeId == parentId)) {
      throw const PlacementNotAllowedException('It already shows there.');
    }
    if (parentId != null) {
      if (parentId == node.id ||
          (await _shownUnder(node.id)).contains(parentId)) {
        throw MoveWouldCreateCycleException(node.id, parentId);
      }
      final parent = await _require(parentId);
      if (parent.type == NodeType.note) {
        throw const PlacementNotAllowedException('Notes hold no items.');
      }
    }
  }

  Future<Placement> _placement(String id) async {
    final p = await (_db.select(
      _db.placements,
    )..where((p) => p.id.equals(id))).getSingleOrNull();
    if (p == null || p.deleted) throw StateError('No placement with id $id.');
    return p;
  }

  /// Live placements of [nodeId], or (with [under]) under [parentId].
  Future<List<Placement>> _livePlacements({
    String? nodeId,
    String? parentId,
    bool under = false,
  }) =>
      (_db.select(_db.placements)..where((p) {
            var w = p.deleted.equals(false);
            if (nodeId != null) w = w & p.nodeId.equals(nodeId);
            if (under) {
              w =
                  w &
                  (parentId == null
                      ? p.parentNodeId.isNull()
                      : p.parentNodeId.equals(parentId));
            }
            return w;
          }))
          .get();

  /// Every node shown anywhere under [id]: real descendants and, through
  /// shortcuts, theirs. Placing or moving [id] under one of these would
  /// make the tree loop.
  Future<Set<String>> _shownUnder(String id) async {
    final rows = await _db
        .customSelect(
          '''
      WITH RECURSIVE
        edges(parent, child) AS (
          SELECT parent_id, id FROM nodes
          WHERE deleted = 0 AND parent_id IS NOT NULL
          UNION ALL
          SELECT parent_node_id, node_id FROM placements
          WHERE deleted = 0 AND parent_node_id IS NOT NULL
        ),
        reach(id) AS (
          SELECT ?1
          UNION
          SELECT e.child FROM edges e JOIN reach r ON e.parent = r.id
        )
      SELECT id FROM reach WHERE id <> ?1
      ''',
          variables: [Variable.withString(id)],
          readsFrom: {_db.nodes, _db.placements},
        )
        .get();
    return {for (final r in rows) r.read<String>('id')};
  }

  // ------------------------------------------------- linked ancestor notes

  /// The notes of [childId]'s ancestors, nearest first (parent, then
  /// grandparent, …), for "Link from above" (§6.10). Ancestors without live
  /// notes are left out.
  Future<List<(Node, List<Node>)>> ancestorNotes(String childId) async {
    final result = <(Node, List<Node>)>[];
    for (final a in (await ancestors(childId)).reversed) {
      if (a.deleted || a.lifecycle != Lifecycle.live) continue;
      final notes = await this.notes(a.id);
      if (notes.isNotEmpty) result.add((a, notes));
    }
    return result;
  }

  /// Shares a note with every item under its owner, or stops sharing it.
  Future<void> setNoteShared(String noteId, bool shared) =>
      update(noteId, NodesCompanion(sharedWithChildren: Value(shared)));

  /// Links [noteId] into [childId]. Linking twice changes nothing.
  Future<void> linkNote(String childId, String noteId) async {
    final child = await _require(childId);
    final note = await _require(noteId);
    if (note.type != NodeType.note) {
      throw ArgumentError.value(noteId, 'noteId', 'is not a note');
    }
    if (await _noteLink(childId, noteId) != null) return;
    await _writer.insert(
      _db.links,
      LinksCompanion(
        id: Value(newId()),
        spaceId: Value(child.spaceId),
        fromNodeId: Value(childId),
        targetKind: const Value(LinkKind.note),
        targetId: Value(noteId),
        origin: const Value(LinkOrigin.attached),
        deleted: const Value(false),
      ),
    );
  }

  /// Removes the link only; the note itself is never touched.
  Future<void> unlinkNote(String childId, String noteId) async {
    final link = await _noteLink(childId, noteId);
    if (link == null) return;
    await _writer.update(
      _db.links,
      link.id,
      const LinksCompanion(deleted: Value(true)),
    );
  }

  /// The notes linked into [childId], oldest link first, with each note's
  /// owner. A note that is gone (purged) comes back with [LinkedNote.note]
  /// null.
  Stream<List<LinkedNote>> watchLinkedNotes(String childId) => _db
      .customSelect(
        '''
        SELECT l.target_id FROM links l
        WHERE l.from_node_id = ?1 AND l.target_kind = ?2 AND l.deleted = 0
        ORDER BY l.created_at, l.id
        ''',
        variables: [
          Variable.withString(childId),
          Variable.withString(LinkKind.note.name),
        ],
        readsFrom: {_db.links, _db.nodes},
      )
      .watch()
      .asyncMap((rows) async {
        final out = <LinkedNote>[];
        final seen = <String>{};
        // Shared down from an ancestor: nearest ancestor first.
        for (final (owner, notes) in await ancestorNotes(childId)) {
          for (final n in notes) {
            if (n.sharedWithChildren && seen.add(n.id)) {
              out.add(LinkedNote(n.id, n, owner, shared: true));
            }
          }
        }
        for (final r in rows) {
          final noteId = r.read<String>('target_id');
          if (!seen.add(noteId)) continue;
          final note = await get(noteId);
          final owner = note?.parentId == null
              ? null
              : await get(note!.parentId!);
          out.add(
            LinkedNote(
              noteId,
              note == null || note.deleted ? null : note,
              owner,
            ),
          );
        }
        return out;
      });

  /// The live items that link [noteId] in ("Linked into: N items").
  Stream<List<Node>> watchLinkedInto(String noteId) => _db
      .customSelect(
        '''
        SELECT n.* FROM links l JOIN nodes n ON n.id = l.from_node_id
        WHERE l.target_kind = ?1 AND l.target_id = ?2 AND l.deleted = 0
          AND n.deleted = 0 AND n.lifecycle = ?3
        ORDER BY l.created_at, l.id
        ''',
        variables: [
          Variable.withString(LinkKind.note.name),
          Variable.withString(noteId),
          Variable.withString(Lifecycle.live.name),
        ],
        readsFrom: {_db.links, _db.nodes},
      )
      .watch()
      .map((rows) => [for (final r in rows) _db.nodes.map(r.data)]);

  Future<Link?> _noteLink(String childId, String noteId) =>
      (_db.select(_db.links)
            ..where(
              (l) =>
                  l.fromNodeId.equals(childId) &
                  l.targetKind.equalsValue(LinkKind.note) &
                  l.targetId.equals(noteId) &
                  l.deleted.equals(false),
            )
            ..limit(1))
          .getSingleOrNull();

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
  ///
  /// Items inside a repeating item repeat with it (D24): their status is
  /// per occurrence of the nearest repeating item above. A parent's
  /// occurrence is also done once all its items are done for it (Q-L), or,
  /// for a one-at-a-time set, once its pick is (D36). Children of a
  /// one-at-a-time set don't follow the parent's occurrences.
  Future<OccurrenceStatus?> occurrenceStatus(
    String id, {
    required DateTime today,
  }) async {
    final node = await get(id);
    if (node == null || node.type == NodeType.note) return null;
    final source = await repeatSource(node);
    if (source == null) return null;
    final rule = RepeatRule.parse(source.rrule!)!;
    final start = seriesStart(source);
    final inherited = source.id == id ? null : source;
    final period = rule.lastOnOrBefore(today, start);
    if (period == null) {
      return OccurrenceStatus(null, false, start, repeatsWith: inherited);
    }
    final done = await occurrenceDone(node, dateKey(period));
    return OccurrenceStatus(period, done, start, repeatsWith: inherited);
  }

  /// The item whose repeat [node] follows: itself if it has a rule this
  /// version understands, else the nearest repeating item above. Null if
  /// none, or if the way up passes from a child of a one-at-a-time set
  /// (D36), whose children have their own cadence.
  Future<Node?> repeatSource(Node node) async {
    if (node.rrule != null && RepeatRule.parse(node.rrule!) != null) {
      return node;
    }
    var cur = node;
    for (var i = 0; i < _maxDepth && cur.parentId != null; i++) {
      final parent = await get(cur.parentId!);
      if (parent == null || parent.deleted) return null;
      if (parent.rrule != null && RepeatRule.parse(parent.rrule!) != null) {
        return parent.exclusiveChildren ? null : parent;
      }
      cur = parent;
    }
    return null;
  }

  /// Whether [node] is done for the occurrence [key]: completed for it,
  /// dropped, or (with items under it) all of them done for it.
  Future<bool> occurrenceDone(Node node, String key, [int depth = 0]) async {
    if (node.status == NodeStatus.dropped) return true;
    if (await _completion(node.id, key) != null) return true;
    if (depth > 50) return false;
    final kids = [
      for (final c in await children(node.id))
        if (c.type.isItem) c,
    ];
    if (kids.isEmpty) return false;
    if (node.exclusiveChildren) {
      for (final c in kids) {
        if (await _completion(c.id, key) != null) return true;
      }
      return false;
    }
    for (final c in kids) {
      if (!await occurrenceDone(c, key, depth + 1)) return false;
    }
    return true;
  }

  /// Ticks [id] done or not: for its current occurrence if it repeats or
  /// sits in a repeating item (D24), otherwise for good.
  Future<void> setDone(String id, bool done, {DateTime? today}) async {
    final occ = await occurrenceStatus(id, today: today ?? DateTime.now());
    final period = occ?.period;
    if (occ != null && period != null) {
      done
          ? await completeOccurrence(id, period)
          : await uncompleteOccurrence(id, period);
    } else {
      await setStatus(id, done ? NodeStatus.done : NodeStatus.open);
    }
  }

  /// [occurrenceStatus], live; [today] is read on each emission.
  Stream<OccurrenceStatus?> watchOccurrence(
    String id, {
    DateTime Function()? today,
  }) {
    return _db
        .customSelect(
          // Distinct SQL: Drift shares streams with the same text, and
          // would then only refresh for the first one's tables.
          'SELECT 1 AS occurrence_status',
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
          'SELECT 1 AS exclusive_status',
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

  /// How the node shows its children (§6.13). Panels, the default, is
  /// stored as null.
  Future<void> setChildView(String id, ChildView view) => update(
    id,
    NodesCompanion(childView: Value(view == ChildView.panels ? null : view)),
  );

  /// Moves [id] under [newParentId] (null = top level) at [index] among the
  /// new parent's live children, not counting the node itself (null = end).
  /// Reordering within the same parent is a move to the same parent.
  ///
  /// Only `parent_id` and `sort_key` change (§5.3).
  Future<void> move(String id, {String? newParentId, int? index}) async {
    await _require(id);
    if (newParentId != null) {
      // Shortcuts count: a parent shown anywhere under the node would make
      // the tree loop.
      if (newParentId == id || (await _shownUnder(id)).contains(newParentId)) {
        throw MoveWouldCreateCycleException(id, newParentId);
      }
      await _require(newParentId);
    }
    // TODO(sharing): moving across spaces re-tags the subtree (§11.5).
    await _db.transaction(() async {
      await update(
        id,
        NodesCompanion(
          parentId: Value(newParentId),
          sortKey: Value(await _keyAt(newParentId, index, excluding: id)),
        ),
      );
      // A shortcut to where it now really is would show it twice.
      for (final p in await _livePlacements(nodeId: id)) {
        if (p.parentNodeId == newParentId) await removePlacement(p.id);
      }
    });
  }

  // -------------------------------------------------------------- helpers

  Future<Node> _require(String id) async {
    final node = await get(id);
    if (node == null || node.deleted) {
      throw StateError('No node with id $id.');
    }
    return node;
  }

  /// A sort key for [index] among [parentId]'s rows: its real children and
  /// your shortcuts there. [excluding] is a row key (node or placement id).
  Future<String> _keyAt(
    String? parentId,
    int? index, {
    String? excluding,
  }) async {
    final siblings =
        [
          for (final n in await children(parentId))
            if (n.id != excluding) (key: n.id, sortKey: n.sortKey),
          for (final p in await _livePlacements(
            parentId: parentId,
            under: true,
          ))
            if (p.id != excluding) (key: p.id, sortKey: p.sortKey),
        ]..sort((a, b) {
          final c = a.sortKey.compareTo(b.sortKey);
          return c != 0 ? c : a.key.compareTo(b.key);
        });
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

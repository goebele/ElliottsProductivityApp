import 'package:drift/drift.dart';

import 'sync_columns.dart';

// Enum values are stored by name, so never rename one once it has shipped.

enum SpaceKind { personal, shared }

enum MemberRole { owner, editor, viewer }

/// What a node *is*. What it *has* (a description, a deadline, a time slot,
/// a repeat rule, a list layout) are optional fields any node can use
/// (D5, rev. v0.4). v0.3's list/routine/event/inboxItem types were migrated
/// to `task`.
///
/// [note] is the one non-task type (v0.5): no status, no add-ons. Notes under
/// an item show in its notes column, not among its items or in the tree.
enum NodeType {
  goal,
  project,
  task,
  idea,
  note;

  /// Shown among a parent's items and in the tree (everything but notes).
  bool get isItem => this != note;
}

enum NodeStatus { open, active, waiting, done, dropped }

enum ChildView { panels, checklist, steps }

enum Lifecycle { live, archived, trashed }

/// Stores an enum by name, and reads names it does not know (written by a
/// newer app version, or since retired) as [fallback] instead of failing.
/// The stored text is left as it is (D33: unknown data is kept).
class TolerantEnumConverter<T extends Enum> extends TypeConverter<T, String> {
  const TolerantEnumConverter(this.values, this.fallback);

  final List<T> values;
  final T fallback;

  @override
  T fromSql(String fromDb) {
    for (final v in values) {
      if (v.name == fromDb) return v;
    }
    return fallback;
  }

  @override
  String toSql(T value) => value.name;
}

/// One row per person you know about, including yourself (§5.1).
/// Deliberately no name, email or phone: names are local contact labels.
class Users extends Table with SyncColumns {
  /// Base64 Ed25519 public key.
  TextColumn get identityPublicKey => text()();
}

/// The unit of syncing and sharing (§5.2).
/// A space's own row lives in that space, so `spaceId == id`.
class Spaces extends Table with SyncColumns {
  TextColumn get kind => textEnum<SpaceKind>()();

  /// Null until the space has a root node (the personal space has none).
  TextColumn get rootNodeId => text().nullable()();

  /// Set when a smaller share is absorbed into a larger one (§11.3).
  TextColumn get mergedIntoSpaceId => text().nullable()();
}

/// Who belongs to a space. `spaceId` (from [SyncColumns]) is the space.
class SpaceMembers extends Table with SyncColumns {
  TextColumn get userId => text()();
  TextColumn get role => textEnum<MemberRole>()();
  DateTimeColumn get joinedAt => dateTime()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {spaceId, userId},
  ];
}

/// Every goal, project, task, list, routine, event, note and idea (§5.2).
@TableIndex(name: 'nodes_parent_sort', columns: {#parentId, #sortKey})
class Nodes extends Table with SyncColumns {
  /// The single real parent. Null means top-level.
  TextColumn get parentId => text().nullable()();

  /// Fractional index among siblings (see `domain/sort_keys.dart`).
  /// Ties (two devices picking the same key) are broken by [id].
  TextColumn get sortKey => text()();

  TextColumn get type =>
      text().map(const TolerantEnumConverter(NodeType.values, NodeType.task))();
  TextColumn get title => text()();
  TextColumn get bodyMd => text().withDefault(const Constant(''))();

  /// `md_lww` in v1; leaves room for a CRDT note format later (Q-A).
  TextColumn get bodyFormat => text().withDefault(const Constant('md_lww'))();

  /// How children are shown. Null means panels; checklist is "show as list".
  TextColumn get childView => text()
      .map(const TolerantEnumConverter(ChildView.values, ChildView.panels))
      .nullable()();

  TextColumn get status => text()
      .withDefault(Constant(NodeStatus.open.name))
      .map(const TolerantEnumConverter(NodeStatus.values, NodeStatus.open))();
  TextColumn get completedBy => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  /// 1–4.
  IntColumn get priority => integer().nullable()();
  IntColumn get estimateMinutes => integer().nullable()();

  /// Events and time blocks, in UTC, plus the IANA zone they were set in.
  DateTimeColumn get startAt => dateTime().nullable()();
  DateTimeColumn get endAt => dateTime().nullable()();
  TextColumn get timeZone => text().nullable()();

  /// A deadline with a time of day.
  DateTimeColumn get dueAt => dateTime().nullable()();

  /// An all-day deadline, as `YYYY-MM-DD` with no time zone (§6.5).
  TextColumn get dueDate => text().nullable()();

  /// RFC 5545 RRULE. All descendants repeat with it (D24), unless
  /// [exclusiveChildren] makes them take turns (D36).
  TextColumn get rrule => text().nullable()();

  /// First day of the repeat series, `YYYY-MM-DD`. Intervals count from it
  /// (which weeks "every 2 weeks" means).
  TextColumn get repeatStart => text().nullable()();

  /// Children are an exclusive set (D36): each occurrence suggests at most
  /// one of them, the one furthest past its own due date.
  BoolColumn get exclusiveChildren =>
      boolean().withDefault(const Constant(false))();

  /// Notes only (§6.10): shared with every item under the note's owner, as
  /// if each had linked it. "Pinned" for all sub-items.
  BoolColumn get sharedWithChildren =>
      boolean().withDefault(const Constant(false))();

  /// Archive / Trash state, separate from [status] (§6.11).
  TextColumn get lifecycle =>
      textEnum<Lifecycle>().withDefault(Constant(Lifecycle.live.name))();
  DateTimeColumn get lifecycleAt => dateTime().nullable()();

  /// The node the user actually archived or trashed; its whole subtree points
  /// here so restoring it brings back exactly that group.
  TextColumn get lifecycleRootId => text().nullable()();
}

/// Personal (§5.2, §6.12, D26): extra places a node appears for you only, a
/// shortcut. The node keeps its one real parent. Removing a shortcut sets
/// [deleted].
@TableIndex(name: 'placements_parent', columns: {#parentNodeId, #sortKey})
@TableIndex(name: 'placements_node', columns: {#nodeId})
class Placements extends Table with SyncColumns {
  TextColumn get nodeId => text()();

  /// Where the shortcut shows; null = the top level.
  TextColumn get parentNodeId => text().nullable()();

  /// Order among the parent's children (real ones and shortcuts share one
  /// key space).
  TextColumn get sortKey => text()();
}

enum LinkKind { node, note, url, attachment }

enum LinkOrigin { inline, attached }

/// Shared (§5.2, §6.10): a link from a node to something. In v0.7 only
/// `note` links with `origin = attached` exist: a child reusing one of its
/// ancestors' notes. Nothing is copied; unlinking sets [deleted].
@TableIndex.sql(
  'CREATE UNIQUE INDEX links_unique ON links (from_node_id, target_kind, '
  'target_id) WHERE deleted = 0',
)
@TableIndex(name: 'links_target', columns: {#targetKind, #targetId})
class Links extends Table with SyncColumns {
  TextColumn get fromNodeId => text()();
  TextColumn get targetKind =>
      text().map(const TolerantEnumConverter(LinkKind.values, LinkKind.node))();

  /// The linked node (for `note`, the note node). Null for `url`.
  TextColumn get targetId => text().nullable()();
  TextColumn get url => text().nullable()();
  TextColumn get label => text().nullable()();
  TextColumn get origin => text().map(
    const TolerantEnumConverter(LinkOrigin.values, LinkOrigin.attached),
  )();
}

/// Completions of repeating items and their descendants (§5.2, D11, D24).
/// Shared. "Undo" sets [deleted] rather than removing the row.
@TableIndex(
  name: 'occurrence_completions_node',
  columns: {#nodeId, #occurrenceDate},
)
class OccurrenceCompletions extends Table with SyncColumns {
  TextColumn get nodeId => text()();

  /// `YYYY-MM-DD`: the occurrence of the nearest repeating ancestor (or of
  /// the node itself) that this completion counts for.
  TextColumn get occurrenceDate => text()();
  TextColumn get completedBy => text()();
  DateTimeColumn get completedAt => dateTime()();
  TextColumn get note => text().nullable()();
}

/// Local-only (§5.4, §7.1): one row per field-level change. Every write to a
/// synced table goes through `ChangeWriter`, which records it here.
@DataClassName('ChangeOp')
@TableIndex(name: 'change_log_hlc', columns: {#hlc})
@TableIndex(name: 'change_log_field', columns: {#rowTable, #rowId, #columnName})
class ChangeLog extends Table {
  TextColumn get opId => text()();
  TextColumn get spaceId => text()();

  /// SQL name of the table the op applies to.
  TextColumn get rowTable => text().named('table_name')();
  TextColumn get rowId => text()();
  TextColumn get columnName => text()();

  /// JSON-encoded SQL value (string, number or null; booleans are 0/1).
  TextColumn get value => text()();
  TextColumn get hlc => text()();
  TextColumn get originDeviceId => text()();
  TextColumn get authorUserId => text()();
  IntColumn get schemaVersion => integer()();

  @override
  Set<Column<Object>> get primaryKey => {opId};
}

/// Local-only (§5.4): paired devices, including this one. Never synced.
class Devices extends Table {
  TextColumn get deviceId => text()();
  TextColumn get userId => text()();

  /// Base64 Ed25519 public key.
  TextColumn get devicePublicKey => text()();

  /// Base64 signature of the device public key by the user identity key.
  TextColumn get signedByUserKey => text()();

  TextColumn get label => text().nullable()();

  /// True for exactly one row: the device this database lives on.
  BoolColumn get isThisDevice => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {deviceId};
}

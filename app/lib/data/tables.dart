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

  /// Progress set by hand (0–100), instead of counting done items (§6.16).
  IntColumn get progressOverride => integer().nullable()();

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

/// Personal (§5.2, §6.2): one of your core values, with a statement of why
/// it matters. Two people can tie the same shared item to different values.
class CoreValues extends Table with SyncColumns {
  TextColumn get name => text()();

  /// Markdown.
  TextColumn get statement => text().withDefault(const Constant(''))();

  /// ARGB; null = the theme's default.
  IntColumn get color => integer().nullable()();

  /// A short icon name (see `ui/values.dart`); null = the default.
  TextColumn get icon => text().nullable()();
  TextColumn get sortKey => text()();
}

/// Personal: a value you tied to a node. Its descendants inherit it (D6).
/// Removing it sets [deleted].
@TableIndex(name: 'node_values_node', columns: {#nodeId})
@TableIndex(name: 'node_values_value', columns: {#valueId})
class NodeValues extends Table with SyncColumns {
  TextColumn get nodeId => text()();
  TextColumn get valueId => text()();
}

enum TagKind { normal, place }

/// A tag (§6.14). A tag in a shared space is shared; one in your personal
/// space is private. In v1 every tag is personal. A tag lasts while
/// something uses it, unless it is [kept]: removing its last use sets
/// [deleted], and using the name again brings the same row back.
class Tags extends Table with SyncColumns {
  /// Without the `#`. Matched case-insensitively; shown as first written.
  TextColumn get name => text()();

  /// ARGB; null = no colour.
  IntColumn get color => integer().nullable()();
  TextColumn get kind =>
      text().map(const TolerantEnumConverter(TagKind.values, TagKind.normal))();

  /// One tap in the tag picker: a common category such as #work. In v1
  /// tags are personal; with sharing, favourites move to a personal table
  /// so members can have their own.
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();

  /// Made or edited on the Tags page: stays when nothing uses it.
  BoolColumn get kept => boolean().withDefault(const Constant(false))();
}

/// A tag on a node, in the tag's space. [origin] `inline` means it comes
/// from `#name` in the node's title or text, and is kept in step with it;
/// `attached` means it was added from the tag picker.
@TableIndex(name: 'node_tags_node', columns: {#nodeId})
@TableIndex(name: 'node_tags_tag', columns: {#tagId})
class NodeTags extends Table with SyncColumns {
  TextColumn get nodeId => text()();
  TextColumn get tagId => text()();
  TextColumn get origin => text().map(
    const TolerantEnumConverter(LinkOrigin.values, LinkOrigin.attached),
  )();
}

enum AttachmentKind { image, text, pdf, other }

/// Shared (§5.2, §6.4): a file attached to a node, stored in the blob store
/// under its content hash. [nodeId] is its single owner; other items show it
/// through `links` rows (`target_kind = attachment`). Removing it sets
/// [deleted]; the file is freed once nothing live uses its hash.
@TableIndex(name: 'attachments_node', columns: {#nodeId})
class Attachments extends Table with SyncColumns {
  TextColumn get nodeId => text()();

  /// SHA-256, hex.
  TextColumn get contentHash => text()();
  TextColumn get filename => text()();
  TextColumn get mime => text()();
  IntColumn get sizeBytes => integer()();
  TextColumn get kind => text().map(
    const TolerantEnumConverter(AttachmentKind.values, AttachmentKind.other),
  )();

  /// Images only, in pixels.
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
}

enum AnnotationKind { stroke, highlight, textLabel }

/// Shared (§5.2, §6.4): markup on an attachment, one row per stroke,
/// highlight or label, so two devices marking up the same file merge
/// cleanly. Erasing sets [deleted].
@TableIndex(name: 'annotations_attachment', columns: {#attachmentId})
class Annotations extends Table with SyncColumns {
  TextColumn get attachmentId => text()();
  TextColumn get kind => text().map(
    const TolerantEnumConverter(AnnotationKind.values, AnnotationKind.stroke),
  )();

  /// stroke: `{"points": [x0, y0, x1, y1, …], "width": w, "pen": "pen" |
  /// "highlighter"}`, coordinates 0–1 of the image; textLabel: `{"x", "y",
  /// "text"}`; highlight: `{"start", "end"}` character offsets.
  TextColumn get dataJson => text()();

  /// ARGB.
  IntColumn get color => integer()();

  /// Drawing order.
  IntColumn get z => integer()();
}

/// Personal (§6.5): a reminder on a node, as minutes before its anchor:
/// the start of a time slot (or each timed occurrence), or for all-day
/// items 00:00 on the day (so -540 is 09:00 that day, 900 is 09:00 the day
/// before). Removing it sets [deleted].
@TableIndex(name: 'reminders_node', columns: {#nodeId})
class Reminders extends Table with SyncColumns {
  TextColumn get nodeId => text()();
  IntColumn get minutesBefore => integer()();
}

/// Personal per-node settings (§5.0): one row per node you've changed
/// something on. Child-view overrides will join it.
@TableIndex(name: 'node_user_prefs_node', columns: {#nodeId})
class NodeUserPrefs extends Table with SyncColumns {
  TextColumn get nodeId => text()();

  /// Included in "Export calendar" (.ics). Off by default (v0.13).
  BoolColumn get icsExport => boolean().withDefault(const Constant(false))();
}

enum TimeSource { timer, manual }

/// Personal (§6.15): time spent on a node. [endedAt] null = the timer is
/// running; there is at most one per user. A pause ends the entry, and
/// resuming starts a new one. Deleting sets [deleted].
@TableIndex(name: 'time_entries_node', columns: {#nodeId})
@TableIndex(name: 'time_entries_started', columns: {#startedAt})
class TimeEntries extends Table with SyncColumns {
  TextColumn get nodeId => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get source => text().map(
    const TolerantEnumConverter(TimeSource.values, TimeSource.timer),
  )();

  /// Focus mode: the countdown length, so it shows on every device.
  IntColumn get focusMinutes => integer().nullable()();
  TextColumn get note => text().nullable()();
}

enum ActivityAction {
  created,
  completed,
  uncompleted,
  archived,
  trashed,
  restored,
  timeLogged,
}

/// Personal (§5.2, §6.16): a durable history for reports. Rows are only
/// added, never changed, and survive Trash purges and change-log
/// compaction, so reports still show the work.
@TableIndex(name: 'activity_at', columns: {#at})
@TableIndex(name: 'activity_node', columns: {#nodeId})
class Activity extends Table with SyncColumns {
  DateTimeColumn get at => dateTime()();
  TextColumn get nodeId => text()();
  TextColumn get action => text().map(
    const TolerantEnumConverter(ActivityAction.values, ActivityAction.created),
  )();

  /// For a repeat: the occurrence (`YYYY-MM-DD`) it was for.
  TextColumn get occurrenceDate => text().nullable()();
  TextColumn get titleSnapshot => text()();

  /// The top-level item's id and title then (null at the top level).
  TextColumn get topProjectId => text().nullable()();
  TextColumn get topProjectSnapshot => text().nullable()();

  /// JSON list of the effective value ids then.
  TextColumn get valuesSnapshot => text().withDefault(const Constant('[]'))();
  IntColumn get minutes => integer().nullable()();
}

/// Personal (§6.7): one item's place on one day's Today list. A row puts
/// it there (picked, or ordered by dragging); [hidden] takes an item that
/// was added automatically off that day's list. Rows are per day.
@TableIndex(name: 'today_entries_date', columns: {#date, #sortKey})
class TodayEntries extends Table with SyncColumns {
  /// `YYYY-MM-DD`.
  TextColumn get date => text()();
  TextColumn get nodeId => text()();
  TextColumn get sortKey => text()();
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();

  /// For a pick left unfinished: answered "keep" or "drop" on a later day,
  /// so it isn't asked again.
  BoolColumn get resolved => boolean().withDefault(const Constant(false))();
}

/// Personal settings that follow you between devices, as key → JSON.
class UserSettings extends Table with SyncColumns {
  TextColumn get key => text()();
  TextColumn get value => text()();
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

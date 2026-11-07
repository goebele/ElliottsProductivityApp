import 'package:drift/drift.dart';

/// Columns every synced table carries (DESIGN.md §5).
///
/// Synced tables are additive-only (D33): never rename or repurpose a column,
/// deprecate it and add a new one instead. They also have no foreign keys,
/// because sync may apply ops for a child row before its parent arrives.
mixin SyncColumns on Table {
  /// UUIDv7.
  TextColumn get id => text()();

  /// The space this row belongs to (§5.0, D13).
  TextColumn get spaceId => text()();

  DateTimeColumn get createdAt => dateTime()();

  /// User ID of the creator.
  TextColumn get createdBy => text()();

  /// User ID of whoever made the latest change.
  TextColumn get updatedBy => text()();

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  TextColumn get hlc => text()();

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

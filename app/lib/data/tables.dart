import 'package:drift/drift.dart';

import 'sync_columns.dart';

// Enum values are stored by name, so never rename one once it has shipped.

enum SpaceKind { personal, shared }

enum MemberRole { owner, editor, viewer }

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
  BoolColumn get isThisDevice =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {deviceId};
}

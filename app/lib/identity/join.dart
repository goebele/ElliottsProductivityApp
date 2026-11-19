import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/database.dart';
import 'identity_service.dart';
import 'secret_store.dart';

/// What a device already in your set hands to a joining one (§7.2 step 5).
class JoinGrant {
  const JoinGrant({
    required this.userId,
    required this.userPublicKey,
    required this.userPrivateKey,
    required this.personalSpaceId,
    required this.deviceSignature,
  });

  factory JoinGrant.fromJson(Map<String, dynamic> j) => JoinGrant(
    userId: j['userId'] as String,
    userPublicKey: j['userPub'] as String,
    userPrivateKey: j['userKey'] as String,
    personalSpaceId: j['space'] as String,
    deviceSignature: j['devSig'] as String,
  );

  final String userId;

  /// Base64 Ed25519 public key, and the private key (seed) itself.
  final String userPublicKey;
  final String userPrivateKey;
  final String personalSpaceId;

  /// The user key's signature over the joining device's key.
  final String deviceSignature;

  Map<String, Object?> toJson() => {
    'userId': userId,
    'userPub': userPublicKey,
    'userKey': userPrivateKey,
    'space': personalSpaceId,
    'devSig': deviceSignature,
  };
}

/// Joining merges (§7.2, v0.23): this device takes on the user identity it
/// was granted and moves its own rows into that user's personal space,
/// keeping its device id and everything it has. Its old identity rows go
/// (they never synced anywhere); the granting device's arrive with the
/// first sync. Run before anything else writes; reload the app's identity
/// afterwards.
Future<void> joinUser(
  AppDatabase db,
  SecretStore secrets,
  JoinGrant grant,
) async {
  final me = await (db.select(
    db.devices,
  )..where((d) => d.isThisDevice.equals(true))).getSingle();
  final oldUser = me.userId;
  final oldSpace =
      (await (db.select(db.spaces)
                ..where((s) => s.kind.equalsValue(SpaceKind.personal))
                ..where((s) => s.createdBy.equals(oldUser)))
              .getSingleOrNull())
          ?.id;
  final newUser = grant.userId;
  final newSpace = grant.personalSpaceId;
  String js(String v) => jsonEncode(v);

  await db.transaction(() async {
    // This device's own identity rows, and their history.
    final oldIdentityRows = <String>{
      ?oldSpace,
      oldUser,
      for (final m in await (db.select(
        db.spaceMembers,
      )..where((m) => m.userId.equals(oldUser))).get())
        m.id,
    };
    for (final id in oldIdentityRows) {
      await db.customStatement('DELETE FROM change_log WHERE row_id = ?', [id]);
    }
    if (oldSpace != null) {
      await db.customStatement('DELETE FROM spaces WHERE id = ?', [oldSpace]);
    }
    await db.customStatement('DELETE FROM users WHERE id = ?', [oldUser]);
    await db.customStatement('DELETE FROM space_members WHERE user_id = ?', [
      oldUser,
    ]);

    // Everything else moves to the granted user and space: the rows...
    for (final t in db.syncedTables) {
      final name = t.actualTableName;
      final cols = {for (final c in t.$columns) c.name};
      if (oldSpace != null) {
        await db.customStatement(
          'UPDATE $name SET space_id = ? WHERE space_id = ?',
          [newSpace, oldSpace],
        );
      }
      for (final c in ['created_by', 'updated_by', 'completed_by']) {
        if (cols.contains(c)) {
          await db.customStatement('UPDATE $name SET $c = ? WHERE $c = ?', [
            newUser,
            oldUser,
          ]);
        }
      }
    }
    // ...and their history, so it syncs as the granted user's.
    if (oldSpace != null) {
      await db.customStatement(
        'UPDATE change_log SET space_id = ? WHERE space_id = ?',
        [newSpace, oldSpace],
      );
      await db.customStatement(
        "UPDATE change_log SET value = ? WHERE column_name = 'space_id' "
        'AND value = ?',
        [js(newSpace), js(oldSpace)],
      );
    }
    await db.customStatement(
      'UPDATE change_log SET author_user_id = ? WHERE author_user_id = ?',
      [newUser, oldUser],
    );
    await db.customStatement(
      'UPDATE change_log SET value = ? WHERE column_name IN '
      "('created_by', 'updated_by', 'completed_by') AND value = ?",
      [js(newUser), js(oldUser)],
    );

    await (db.update(
      db.devices,
    )..where((d) => d.deviceId.equals(me.deviceId))).write(
      DevicesCompanion(
        userId: Value(newUser),
        signedByUserKey: Value(grant.deviceSignature),
      ),
    );
  });
  // The granted user key replaces this device's own (it signed nothing
  // that synced).
  await secrets.write(IdentityService.userKeySecret, grant.userPrivateKey);
}

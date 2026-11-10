import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';

import '../data/database.dart';
import '../domain/ids.dart';
import '../sync/change_writer.dart';
import 'secret_store.dart';

/// Who this install is: the user, this device, and the personal space.
class LocalIdentity {
  const LocalIdentity({
    required this.userId,
    required this.deviceId,
    required this.personalSpaceId,
    required this.userPublicKey,
    required this.devicePublicKey,
  });

  final String userId;
  final String deviceId;
  final String personalSpaceId;

  /// Base64 Ed25519 public keys.
  final String userPublicKey;
  final String devicePublicKey;
}

/// Thrown when the database knows this device but its private keys are gone
/// (e.g. OS secure storage was cleared). Recovery is pairing from another
/// device (§7.2), which arrives in M7.
class MissingIdentityKeysException implements Exception {
  @override
  String toString() =>
      'This device is registered but its identity keys are missing.';
}

/// Creates the user identity key on first run (M0) and loads it afterwards.
///
/// A user is an opaque ID plus a public key (D21). The user key signs the
/// device key so other devices can check a device belongs to the user.
class IdentityService {
  IdentityService(this._db, this._secrets, {Ed25519? algorithm})
    : _ed25519 = algorithm ?? Ed25519();

  static const userKeySecret = 'user_identity_private_key';
  static const deviceKeySecret = 'device_private_key';

  final AppDatabase _db;
  final SecretStore _secrets;
  final Ed25519 _ed25519;

  Future<LocalIdentity> ensureIdentity() async {
    final existing = await _load();
    if (existing != null) return existing;
    return _create();
  }

  Future<LocalIdentity?> _load() async {
    final device = await (_db.select(
      _db.devices,
    )..where((d) => d.isThisDevice.equals(true))).getSingleOrNull();
    if (device == null) return null;

    if (await _secrets.read(userKeySecret) == null ||
        await _secrets.read(deviceKeySecret) == null) {
      throw MissingIdentityKeysException();
    }

    final user = await (_db.select(
      _db.users,
    )..where((u) => u.id.equals(device.userId))).getSingle();
    final space =
        await (_db.select(_db.spaces)
              ..where((s) => s.kind.equalsValue(SpaceKind.personal))
              ..where((s) => s.createdBy.equals(device.userId)))
            .getSingle();

    return LocalIdentity(
      userId: user.id,
      deviceId: device.deviceId,
      personalSpaceId: space.id,
      userPublicKey: user.identityPublicKey,
      devicePublicKey: device.devicePublicKey,
    );
  }

  Future<LocalIdentity> _create() async {
    final userKey = await _ed25519.newKeyPair();
    final deviceKey = await _ed25519.newKeyPair();
    final userPub = (await userKey.extractPublicKey()).bytes;
    final devicePub = (await deviceKey.extractPublicKey()).bytes;
    final signature = await _ed25519.sign(devicePub, keyPair: userKey);

    final userId = newId();
    final deviceId = newId();
    final spaceId = newId();
    final now = DateTime.now().toUtc();
    final writer = ChangeWriter(_db, userId: userId, deviceId: deviceId);

    // Secrets first: if the app dies before the rows below commit, the next
    // run starts over and overwrites them. The reverse order could leave a
    // registered device with no keys.
    await _secrets.write(
      userKeySecret,
      base64Encode(await userKey.extractPrivateKeyBytes()),
    );
    await _secrets.write(
      deviceKeySecret,
      base64Encode(await deviceKey.extractPrivateKeyBytes()),
    );

    await _db.transaction(() async {
      await writer.insert(
        _db.spaces,
        SpacesCompanion(
          id: Value(spaceId),
          spaceId: Value(spaceId),
          kind: const Value(SpaceKind.personal),
          deleted: const Value(false),
        ),
        now: now,
      );
      await writer.insert(
        _db.users,
        UsersCompanion(
          id: Value(userId),
          spaceId: Value(spaceId),
          identityPublicKey: Value(base64Encode(userPub)),
          deleted: const Value(false),
        ),
        now: now,
      );
      await writer.insert(
        _db.spaceMembers,
        SpaceMembersCompanion(
          id: Value(newId()),
          spaceId: Value(spaceId),
          userId: Value(userId),
          role: const Value(MemberRole.owner),
          joinedAt: Value(now),
          deleted: const Value(false),
        ),
        now: now,
      );
      await _db
          .into(_db.devices)
          .insert(
            DevicesCompanion.insert(
              deviceId: deviceId,
              userId: userId,
              devicePublicKey: base64Encode(devicePub),
              signedByUserKey: base64Encode(signature.bytes),
              isThisDevice: const Value(true),
            ),
          );
    });

    return LocalIdentity(
      userId: userId,
      deviceId: deviceId,
      personalSpaceId: spaceId,
      userPublicKey: base64Encode(userPub),
      devicePublicKey: base64Encode(devicePub),
    );
  }
}

import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:drift/native.dart';
import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/identity/identity_service.dart';
import 'package:elliotts_productivity_app/identity/secret_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late InMemorySecretStore secrets;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    secrets = InMemorySecretStore();
  });
  tearDown(() => db.close());

  test(
    'first run creates the user, personal space, membership and device',
    () async {
      final id = await IdentityService(db, secrets).ensureIdentity();

      final user = await db.select(db.users).getSingle();
      expect(user.id, id.userId);
      expect(user.spaceId, id.personalSpaceId);

      final space = await db.select(db.spaces).getSingle();
      expect(space.id, id.personalSpaceId);
      expect(space.spaceId, space.id);
      expect(space.kind, SpaceKind.personal);

      final member = await db.select(db.spaceMembers).getSingle();
      expect(member.userId, id.userId);
      expect(member.role, MemberRole.owner);

      final device = await db.select(db.devices).getSingle();
      expect(device.deviceId, id.deviceId);
      expect(device.isThisDevice, isTrue);

      expect(secrets.values.keys, {
        IdentityService.userKeySecret,
        IdentityService.deviceKeySecret,
      });

      // Synced rows go through the change log; the local devices row does not.
      final ops = await db.select(db.changeLog).get();
      expect(ops.map((o) => o.rowTable).toSet(), {
        'spaces',
        'users',
        'space_members',
      });
      expect(ops.map((o) => o.rowId).toSet(), {space.id, user.id, member.id});
    },
  );

  test(
    'later runs load the same identity instead of making a new one',
    () async {
      final first = await IdentityService(db, secrets).ensureIdentity();
      final second = await IdentityService(db, secrets).ensureIdentity();

      expect(second.userId, first.userId);
      expect(second.deviceId, first.deviceId);
      expect(second.personalSpaceId, first.personalSpaceId);
      expect(await db.select(db.users).get(), hasLength(1));
    },
  );

  test('the user key signs the device key', () async {
    final id = await IdentityService(db, secrets).ensureIdentity();
    final device = await db.select(db.devices).getSingle();

    final ok = await Ed25519().verify(
      base64Decode(id.devicePublicKey),
      signature: Signature(
        base64Decode(device.signedByUserKey),
        publicKey: SimplePublicKey(
          base64Decode(id.userPublicKey),
          type: KeyPairType.ed25519,
        ),
      ),
    );
    expect(ok, isTrue);
  });

  test('stored private key matches the published public key', () async {
    final id = await IdentityService(db, secrets).ensureIdentity();
    final seed = base64Decode(secrets.values[IdentityService.userKeySecret]!);
    final keyPair = await Ed25519().newKeyPairFromSeed(seed);
    final pub = await keyPair.extractPublicKey();
    expect(base64Encode(pub.bytes), id.userPublicKey);
  });

  test(
    'missing secrets on a registered device is reported, not replaced',
    () async {
      await IdentityService(db, secrets).ensureIdentity();
      secrets.values.clear();

      expect(
        IdentityService(db, secrets).ensureIdentity(),
        throwsA(isA<MissingIdentityKeysException>()),
      );
    },
  );
}

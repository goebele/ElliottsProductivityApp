import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart' as hash;
import 'package:drift/drift.dart';

import '../data/database.dart';
import '../identity/identity_service.dart';
import '../identity/join.dart';
import '../identity/secret_store.dart';
import 'change_writer.dart';
import 'secure_channel.dart';
import 'blob_sync.dart';
import 'sync_engine.dart';
import 'sync_session.dart';

/// Pairing was stopped: by either person, a wrong PIN, or the connection.
class PairingCancelled implements Exception {
  const PairingCancelled(this.reason);
  final String reason;
  @override
  String toString() => reason;
}

/// The optional pairing PIN (§7.2 step 4), kept only as a salted hash.
class PairingPin {
  PairingPin(this._secrets);

  static const _key = 'pairing_pin_hash';
  final SecretStore _secrets;

  Future<bool> isSet() async => (await _secrets.read(_key)) != null;

  /// Sets the PIN, or clears it (null or empty).
  Future<void> set(String? pin) async {
    if (pin == null || pin.isEmpty) {
      await _secrets.write(_key, '');
      return;
    }
    final salt = DateTime.now().microsecondsSinceEpoch.toString();
    await _secrets.write(_key, '$salt:${_hash(salt, pin)}');
  }

  Future<bool> matches(String pin) async {
    final stored = await _secrets.read(_key);
    if (stored == null || stored.isEmpty) return true;
    final i = stored.indexOf(':');
    return _hash(stored.substring(0, i), pin) == stored.substring(i + 1);
  }

  Future<bool> required() async {
    final stored = await _secrets.read(_key);
    return stored != null && stored.isNotEmpty;
  }

  static String _hash(String salt, String pin) =>
      hash.sha256.convert(utf8.encode('$salt|$pin')).toString();
}

/// Asks the person to compare [code] with the other screen; true = same.
typedef ConfirmCode = Future<bool> Function(PeerInfo peer, String code);

/// Asks the person on the joining device for the other device's PIN.
typedef AskPin = Future<String?> Function();

Future<Map<String, dynamic>> _expect(
  StreamIterator<Map<String, dynamic>> inbox,
  String type,
) async {
  if (!await inbox.moveNext().timeout(const Duration(minutes: 3))) {
    throw const PairingCancelled('The other device hung up.');
  }
  final m = inbox.current;
  if (m['type'] == 'pair-cancel') {
    throw PairingCancelled(m['reason'] as String? ?? 'Cancelled.');
  }
  if (m['type'] != type) throw PairingCancelled('Unexpected ${m['type']}.');
  return m;
}

/// Both people confirm the code; each side waits for the other's yes.
Future<void> _confirmBoth(
  SecureChannel channel,
  StreamIterator<Map<String, dynamic>> inbox,
  ConfirmCode confirm,
) async {
  // Their answer may come (or fail) while this person is still deciding.
  final theirs = _expect(inbox, 'pair-confirm')..ignore();
  final mine = await confirm(channel.peer, channel.pairingCode);
  if (!mine) {
    channel.send({'type': 'pair-cancel', 'reason': 'The codes didn\'t match.'});
    throw const PairingCancelled('Cancelled.');
  }
  channel.send({'type': 'pair-confirm'});
  await theirs;
}

/// A messages view over [channel] for the pairing steps; the sync session
/// afterwards reads the same channel.
class _Relay implements SyncChannel {
  _Relay(this._channel, this._inbox);
  final SecureChannel _channel;
  final StreamIterator<Map<String, dynamic>> _inbox;

  @override
  Stream<Map<String, dynamic>> get incoming async* {
    while (await _inbox.moveNext()) {
      yield _inbox.current;
    }
  }

  @override
  void send(Map<String, Object?> message) => _channel.send(message);

  @override
  Future<void> flush() => _channel.flush();

  @override
  Future<void> close() => _channel.close();
}

/// The device already in your set, offering to pair (§7.2): confirms the
/// code, checks the PIN, signs the new device's key, hands over the user
/// key, records the device, and syncs.
Future<SyncReport> hostPairing(
  SecureChannel channel, {
  required AppDatabase db,
  required IdentityService identity,
  required SecretStore secrets,
  required SyncEngine engine,
  required String deviceId,
  required String userId,
  required String personalSpaceId,
  required ConfirmCode confirm,
  String? label,
  BlobSync? blobs,
}) async {
  final inbox = StreamIterator(channel.incoming);
  try {
    final request = await _expect(inbox, 'pair-request');
    final peerLabel = request['label'] as String?;
    await _confirmBoth(channel, inbox, confirm);

    final pin = PairingPin(secrets);
    if (await pin.required()) {
      var ok = false;
      for (var tries = 0; tries < 3 && !ok; tries++) {
        channel.send({'type': 'pin-required', 'retry': tries > 0});
        final m = await _expect(inbox, 'pin');
        ok = await pin.matches(m['pin'] as String? ?? '');
      }
      if (!ok) {
        channel.send({'type': 'pair-cancel', 'reason': 'Wrong PIN.'});
        throw const PairingCancelled('Wrong PIN.');
      }
    }

    final me = await identity.credentials();
    final grant = JoinGrant(
      userId: userId,
      userPublicKey: me.userPublicKey,
      userPrivateKey: await identity.userPrivateKey(),
      personalSpaceId: personalSpaceId,
      deviceSignature: await identity.signDevice(channel.peer.devicePublicKey),
    );
    channel.send({
      'type': 'pair-accept',
      'grant': grant.toJson(),
      'label': label,
    });
    await _expect(inbox, 'pair-done');

    await rememberDevice(
      db,
      channel.peer,
      userId: userId,
      signature: grant.deviceSignature,
      label: peerLabel,
    );
    final report = await SyncSession(
      engine,
      deviceId: deviceId,
      userId: userId,
      schemaVersion: db.schemaVersion,
      blobs: blobs,
      label: label,
    ).run(_Relay(channel, inbox));
    await markSynced(db, channel.peer.deviceId);
    return report;
  } finally {
    await inbox.cancel();
  }
}

/// The joining device (§7.2): confirms the code, gives the PIN if asked,
/// takes on your user identity keeping its own items (joining merges),
/// and syncs. Afterwards the app must reload its identity.
Future<SyncReport> joinPairing(
  SecureChannel channel, {
  required AppDatabase db,
  required SecretStore secrets,
  required String deviceId,
  required ConfirmCode confirm,
  required AskPin askPin,
  String? label,
  BlobSync? Function(SyncEngine engine)? blobs,
}) async {
  final inbox = StreamIterator(channel.incoming);
  try {
    channel.send({'type': 'pair-request', 'label': label});
    await _confirmBoth(channel, inbox, confirm);

    Map<String, dynamic> m;
    while (true) {
      if (!await inbox.moveNext().timeout(const Duration(minutes: 3))) {
        throw const PairingCancelled('The other device hung up.');
      }
      m = inbox.current;
      if (m['type'] == 'pair-cancel') {
        throw PairingCancelled(m['reason'] as String? ?? 'Cancelled.');
      }
      if (m['type'] != 'pin-required') break;
      final pin = await askPin();
      if (pin == null) {
        channel.send({'type': 'pair-cancel', 'reason': 'Cancelled.'});
        throw const PairingCancelled('Cancelled.');
      }
      channel.send({'type': 'pin', 'pin': pin});
    }
    if (m['type'] != 'pair-accept') {
      throw PairingCancelled('Unexpected ${m['type']}.');
    }
    final grant = JoinGrant.fromJson(
      (m['grant'] as Map).cast<String, dynamic>(),
    );
    await joinUser(db, secrets, grant);
    channel.send({'type': 'pair-done'});

    // A fresh writer and engine as the granted user.
    final writer = await ChangeWriter.open(
      db,
      userId: grant.userId,
      deviceId: deviceId,
    );
    await rememberDevice(
      db,
      channel.peer,
      userId: grant.userId,
      signature: channel.peer.deviceSignature,
      label: m['label'] as String?,
    );
    final engine = SyncEngine(db, writer);
    final report = await SyncSession(
      engine,
      deviceId: deviceId,
      userId: grant.userId,
      schemaVersion: db.schemaVersion,
      blobs: blobs?.call(engine),
      label: label,
    ).run(_Relay(channel, inbox));
    await markSynced(db, channel.peer.deviceId);
    return report;
  } finally {
    await inbox.cancel();
  }
}

/// Records [peer] as one of your devices (local-only, §5.4).
Future<void> rememberDevice(
  AppDatabase db,
  PeerInfo peer, {
  required String userId,
  required String signature,
  String? label,
}) => db
    .into(db.devices)
    .insert(
      DevicesCompanion.insert(
        deviceId: peer.deviceId,
        userId: userId,
        devicePublicKey: peer.devicePublicKey,
        signedByUserKey: signature,
        label: Value(label),
      ),
      onConflict: DoUpdate(
        (_) => DevicesCompanion(
          userId: Value(userId),
          devicePublicKey: Value(peer.devicePublicKey),
          signedByUserKey: Value(signature),
          label: Value(label),
        ),
      ),
    );

Future<void> markSynced(AppDatabase db, String deviceId) =>
    (db.update(db.devices)..where((d) => d.deviceId.equals(deviceId))).write(
      DevicesCompanion(lastSyncAt: Value(DateTime.now().toUtc())),
    );

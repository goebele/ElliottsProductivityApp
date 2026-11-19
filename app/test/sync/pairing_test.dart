import 'dart:async';
import 'dart:io';

import 'package:elliotts_productivity_app/identity/identity_service.dart';
import 'package:elliotts_productivity_app/sync/change_writer.dart';
import 'package:elliotts_productivity_app/sync/pairing.dart';
import 'package:elliotts_productivity_app/sync/secure_channel.dart';
import 'package:elliotts_productivity_app/sync/sync_engine.dart';
import 'package:elliotts_productivity_app/sync/sync_session.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sync_harness.dart';

/// Pairing and joining over real loopback sockets (§7.2, §7.6 step 3).
void main() {
  late Peer pc;
  late Peer phone;
  late ServerSocket server;
  late StreamIterator<Socket> accepted;
  Future<Socket> nextSocket() async {
    await accepted.moveNext();
    return accepted.current;
  }

  setUp(() async {
    pc = await Peer.first();
    phone = await Peer.first(); // its own identity, as after first run
    server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    accepted = StreamIterator(server);
  });
  tearDown(() async {
    await accepted.cancel();
    await server.close();
    await pc.close();
    await phone.close();
  });

  IdentityService ids(Peer p) => IdentityService(p.db, p.env.secrets);

  /// The PC listens; the phone connects to pair. Returns both results (or
  /// errors) and the codes each side was shown.
  Future<(Object?, Object?, List<String>)> pair({
    bool pcSays = true,
    bool phoneSays = true,
    String? pin,
  }) async {
    final codes = <String>[];
    final host = nextSocket().then((socket) async {
      final ch = await SecureChannel.accept(
        socket,
        me: await ids(pc).credentials(),
        allow: (m) => m == ChannelMode.pair,
      );
      try {
        return await hostPairing(
          ch,
          db: pc.db,
          identity: ids(pc),
          secrets: pc.env.secrets,
          engine: pc.engine,
          deviceId: pc.deviceId,
          userId: pc.userId,
          personalSpaceId: pc.nodes.personalSpaceId,
          label: 'PC',
          confirm: (_, code) async {
            codes.add(code);
            return pcSays;
          },
        );
      } finally {
        await ch.close();
      }
    });
    final guest = () async {
      final ch = await SecureChannel.connect(
        InternetAddress.loopbackIPv4.address,
        server.port,
        me: await ids(phone).credentials(),
        mode: ChannelMode.pair,
      );
      try {
        return await joinPairing(
          ch,
          db: phone.db,
          secrets: phone.env.secrets,
          deviceId: phone.deviceId,
          label: 'Phone',
          confirm: (_, code) async {
            codes.add(code);
            return phoneSays;
          },
          askPin: () async => pin,
        );
      } finally {
        await ch.close();
      }
    }();
    Future<Object?> settle(Future<Object?> f) =>
        f.then<Object?>((v) => v, onError: (Object e) => e);
    final results = await Future.wait([settle(host), settle(guest)]);
    return (results[0], results[1], codes);
  }

  /// A normal sync between the two, as paired devices.
  Future<void> syncOnce() async {
    final phoneWriter = await ChangeWriter.open(
      phone.db,
      userId: pc.userId,
      deviceId: phone.deviceId,
    );
    final host = nextSocket().then((socket) async {
      final ch = await SecureChannel.accept(
        socket,
        me: await ids(pc).credentials(),
        allow: (m) => m == ChannelMode.sync,
      );
      final r = await pc.session().run(ch);
      await ch.close();
      return r;
    });
    final ch = await SecureChannel.connect(
      InternetAddress.loopbackIPv4.address,
      server.port,
      me: await ids(phone).credentials(),
      mode: ChannelMode.sync,
    );
    await SyncSession(
      SyncEngine(phone.db, phoneWriter),
      deviceId: phone.deviceId,
      userId: pc.userId,
      schemaVersion: phone.db.schemaVersion,
    ).run(ch);
    await ch.close();
    await host;
  }

  test('pairing merges both devices\' items under one user', () async {
    final fromPc = await pc.nodes.create(title: 'From PC');
    await pc.nodes.tags.add(fromPc, 'work');
    final fromPhone = await phone.nodes.create(title: 'From phone');
    await phone.nodes.tags.add(fromPhone, 'Work');

    final (host, guest, codes) = await pair();
    expect(host, isA<SyncReport>());
    expect(guest, isA<SyncReport>());
    expect(codes, hasLength(2));
    expect(codes[0], codes[1], reason: 'the same code on both screens');

    // The phone is now the same user, in the same personal space.
    final joined = await ids(phone).ensureIdentity();
    expect(joined.userId, pc.userId);
    expect(joined.personalSpaceId, pc.nodes.personalSpaceId);
    expect(joined.deviceId, phone.deviceId, reason: 'keeps its device id');

    // Each knows the other, by the name it gave.
    final known = await pc.db.select(pc.db.devices).get();
    expect(
      known.singleWhere((d) => d.deviceId == phone.deviceId).label,
      'Phone',
    );
    final knownOnPhone = await phone.db.select(phone.db.devices).get();
    expect(
      knownOnPhone.singleWhere((d) => d.deviceId == pc.deviceId).label,
      'PC',
    );

    // One more sync (the tag merge ran on the phone) and they're equal.
    await syncOnce();
    await syncOnce();
    for (final p in [pc, phone]) {
      final titles = [
        for (final n in await p.db.select(p.db.nodes).get()) n.title,
      ];
      expect(titles, containsAll(['From PC', 'From phone']));
      final tags = await (p.db.select(
        p.db.tags,
      )..where((t) => t.deleted.equals(false))).get();
      expect(tags, hasLength(1), reason: '#work and #Work are one');
    }
    expect(await snapshot(phone), await snapshot(pc));
  });

  test('a code that doesn\'t match changes nothing', () async {
    await phone.nodes.create(title: 'Mine');
    final before = (await ids(phone).ensureIdentity()).userId;
    final (host, guest, _) = await pair(phoneSays: false);
    expect(host, isA<PairingCancelled>());
    expect(guest, isA<PairingCancelled>());
    expect((await ids(phone).ensureIdentity()).userId, before);
    expect(await pc.db.select(pc.db.nodes).get(), isEmpty);
  });

  test('a PIN on the PC: wrong three times stops; right one pairs', () async {
    await PairingPin(pc.env.secrets).set('4321');
    var (host, guest, _) = await pair(pin: '0000');
    expect(host, isA<PairingCancelled>());
    expect(guest, isA<PairingCancelled>());

    (host, guest, _) = await pair(pin: '4321');
    expect(guest, isA<SyncReport>());
  });

  test('an unpaired device can\'t sync', () async {
    final host = nextSocket().then((socket) async {
      try {
        await SecureChannel.accept(
          socket,
          me: await ids(pc).credentials(),
          allow: (m) => m == ChannelMode.sync,
        );
        return null;
      } catch (e) {
        return e;
      }
    });
    await expectLater(
      SecureChannel.connect(
        InternetAddress.loopbackIPv4.address,
        server.port,
        me: await ids(phone).credentials(),
        mode: ChannelMode.sync,
      ),
      throwsA(isA<HandshakeException>()),
    );
    expect(await host, isA<HandshakeException>());
  });
}

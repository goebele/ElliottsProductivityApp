import 'dart:async';
import 'dart:io';

import 'package:elliotts_productivity_app/data/blob_store.dart';
import 'package:elliotts_productivity_app/identity/identity_service.dart';
import 'package:elliotts_productivity_app/sync/change_writer.dart';
import 'package:elliotts_productivity_app/sync/discovery.dart';
import 'package:elliotts_productivity_app/sync/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sync_harness.dart';

/// A pretend network: every service sees every other on 127.0.0.1.
class FakeLan {
  final _all = <Announcement>[];
  final _listeners = <FakeDiscovery>[];

  void _changed() {
    for (final l in _listeners) {
      l._out.add([
        for (final a in _all)
          if (a.tag != l._me?.tag)
            NearbyDevice(
              tag: a.tag,
              host: '127.0.0.1',
              port: a.port,
              userTag: a.userTag,
              platform: 'test',
            ),
      ]);
    }
  }
}

class FakeDiscovery implements PeerDiscovery {
  FakeDiscovery(this._lan);
  final FakeLan _lan;
  final _out = StreamController<List<NearbyDevice>>.broadcast();
  Announcement? _me;

  @override
  Stream<List<NearbyDevice>> get devices => _out.stream;

  @override
  Future<void> start(Announcement me) async {
    _me = me;
    _lan._listeners.add(this);
    _lan._all.add(me);
    _lan._changed();
  }

  @override
  Future<void> stop() async {
    _lan._listeners.remove(this);
    _lan._all.removeWhere((a) => a.tag == _me?.tag);
    _lan._changed();
  }
}

void main() {
  late Peer pc;
  late Peer phone;
  final lan = FakeLan();
  final services = <SyncService>[];

  setUp(() async {
    pc = await Peer.first();
    phone = await Peer.first();
  });
  tearDown(() async {
    for (final s in services) {
      await s.stop();
    }
    services.clear();
    await pc.close();
    await phone.close();
  });

  Future<SyncService> serve(Peer p, {ChangeWriter? writer}) async {
    final ids = IdentityService(p.db, p.env.secrets);
    final me = await ids.ensureIdentity();
    final s = SyncService(
      db: p.db,
      writer:
          writer ??
          await ChangeWriter.open(
            p.db,
            userId: me.userId,
            deviceId: me.deviceId,
          ),
      identity: ids,
      secrets: p.env.secrets,
      blobStore: BlobStore(p.env.blobDir),
      deviceId: me.deviceId,
      userId: me.userId,
      userPublicKey: me.userPublicKey,
      personalSpaceId: me.personalSpaceId,
      discovery: FakeDiscovery(lan),
      preferredPort: 0,
      afterEdits: const Duration(milliseconds: 200),
    );
    services.add(s);
    await s.start();
    return s;
  }

  Future<void> until(Future<bool> Function() check) async {
    for (var i = 0; i < 100; i++) {
      if (await check()) return;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    fail('timed out');
  }

  test(
    'join through the service, then sync on sight and after edits',
    () async {
      await pc.nodes.create(title: 'From PC');
      await phone.nodes.create(title: 'From phone');

      final pcSync = await serve(pc);
      pcSync.pairingHost = (_, _) async => true;
      var phoneSync = await serve(phone);
      // Seen, but not yet one of its user's devices: no auto sync.
      expect(phoneSync.nearby.single.tag, pcSync.deviceTag(pcSync.deviceId));
      expect(phoneSync.isMine(phoneSync.nearby.single), isFalse);

      final report = await phoneSync.join(
        '127.0.0.1',
        pcSync.port!,
        confirm: (_, _) async => true,
        askPin: () async => null,
      );
      expect(report.received, greaterThan(0));

      // The app reloads its identity after joining: a new service as the
      // PC's user.
      await phoneSync.stop();
      services.remove(phoneSync);
      phoneSync = await serve(phone);
      expect(phoneSync.userId, pcSync.userId);

      // Seeing each other, they sync; then an edit travels by itself.
      await until(
        () async => (await pc.db.select(pc.db.nodes).get()).any(
          (n) => n.title == 'From phone',
        ),
      );
      final writer = await ChangeWriter.open(
        pc.db,
        userId: pcSync.userId,
        deviceId: pcSync.deviceId,
      );
      await pc.nodes.rename(
        (await pc.db.select(pc.db.nodes).get())
            .firstWhere((n) => n.title == 'From PC')
            .id,
        'Renamed on PC',
      );
      expect(writer.userId, pcSync.userId);
      await until(
        () async => (await phone.db.select(phone.db.nodes).get()).any(
          (n) => n.title == 'Renamed on PC',
        ),
      );
      expect(pcSync.status.lastSync, isNotNull);
    },
  );

  test(
    'discovery tags change daily and only your devices can match them',
    () async {
      final s = await serve(pc);
      final other = await serve(phone);
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 2));
      expect(
        s.deviceTag(s.deviceId, today),
        isNot(s.deviceTag(s.deviceId, tomorrow)),
      );
      expect(s.userTag, isNot(other.userTag), reason: 'different users');
      expect(s.deviceTag(s.deviceId), isNot(contains(s.deviceId)));
    },
  );

  test('strangers flooding the port are cut off and not shown', () async {
    final s = await serve(pc);
    final sockets = [
      for (var i = 0; i < SyncService.maxHandshakes + 3; i++)
        await Socket.connect('127.0.0.1', s.port!),
    ];
    // Say nothing; the extra ones are closed straight away.
    var closed = 0;
    for (final sock in sockets) {
      final done = Completer<bool>();
      sock.listen(
        (_) {},
        onDone: () => done.complete(true),
        onError: (_) => done.complete(true),
      );
      if (await done.future.timeout(
        const Duration(milliseconds: 300),
        onTimeout: () => false,
      )) {
        closed++;
      }
    }
    expect(closed, greaterThanOrEqualTo(3));
    for (final sock in sockets) {
      sock.destroy();
    }
    expect(s.status.message, isNull, reason: 'not a sync problem');
  });

  test('a frame too big for a handshake ends the connection', () async {
    final s = await serve(pc);
    final sock = await Socket.connect('127.0.0.1', s.port!);
    final done = Completer<void>();
    sock.listen((_) {}, onDone: done.complete, onError: (_) => done.complete());
    // Claims 64 MB: refused before anything is buffered.
    sock.add([0x04, 0x00, 0x00, 0x00, 1, 2, 3]);
    await done.future.timeout(const Duration(seconds: 5));
    sock.destroy();
  });

  test('suspend stops listening; resume starts again', () async {
    final s = await serve(pc);
    final port = s.port!;
    await s.suspend();
    await expectLater(
      Socket.connect('127.0.0.1', port),
      throwsA(isA<SocketException>()),
    );
    await s.resume();
    final sock = await Socket.connect('127.0.0.1', s.port!);
    sock.destroy();
  });

  test(
    'a device that left without saying so is dropped quietly, not an error',
    () async {
      final s = await serve(pc);
      // One of this user's devices, announced on a port nobody listens on
      // (a phone gone to the background).
      final closed = await ServerSocket.bind('127.0.0.1', 0);
      final gonePort = closed.port;
      await closed.close();
      final gone = FakeDiscovery(lan);
      await gone.start(
        Announcement(tag: 'zzzz-gone', userTag: s.userTag, port: gonePort),
      );
      await until(() async => s.nearby.isNotEmpty);
      expect(s.isMine(s.nearby.single), isTrue);

      await s.syncNow(); // edits, timer, coming back: quiet
      expect(s.status.message, isNull);
      expect(s.status.phase, isNot(SyncPhase.error));
      expect(s.nearby, isEmpty, reason: 'dropped until announced again');

      // Announced again: back in the list. Sync now still reports it.
      await gone.stop();
      await gone.start(
        Announcement(tag: 'zzzz-gone', userTag: s.userTag, port: gonePort),
      );
      await until(() async => s.nearby.isNotEmpty);
      await s.syncNow(quiet: false);
      expect(s.status.phase, SyncPhase.error);
      expect(s.status.message, contains('SocketException'));
      await gone.stop();
    },
  );

  test(
    'its own old announcement (yesterday\'s tag) is never synced with',
    () async {
      final s = await serve(pc);
      final other = await serve(phone); // shows the list does update
      final closed = await ServerSocket.bind('127.0.0.1', 0);
      final stalePort = closed.port;
      await closed.close();
      final stale = FakeDiscovery(lan);
      await stale.start(
        Announcement(
          tag: s.deviceTag(
            s.deviceId,
            DateTime.now().subtract(const Duration(days: 1)),
          ),
          userTag: s.userTag,
          port: stalePort,
        ),
      );
      await until(
        () async =>
            s.nearby.any((d) => d.tag == other.deviceTag(other.deviceId)),
      );
      expect(s.nearby.map((d) => d.port), isNot(contains(stalePort)));
      await s.syncNow(quiet: false);
      expect(s.status.phase, isNot(SyncPhase.error));
      await stale.stop();
    },
  );

  test('joining keeps a copy of the database first', () async {
    final dir = Directory.systemTemp.createTempSync('epa_backup_');
    addTearDown(() => dir.deleteSync(recursive: true));
    await phone.nodes.create(title: 'Mine');
    final s = SyncService(
      db: phone.db,
      writer: phone.env.writer,
      identity: IdentityService(phone.db, phone.env.secrets),
      secrets: phone.env.secrets,
      blobStore: BlobStore(phone.env.blobDir),
      deviceId: phone.deviceId,
      userId: phone.userId,
      userPublicKey: phone.env.identity.userPublicKey,
      personalSpaceId: phone.nodes.personalSpaceId,
      backupDir: dir,
    );
    final file = await s.backupDatabase('before-join');
    expect(file!.existsSync(), isTrue);
    expect(file.lengthSync(), greaterThan(0));
  });
}

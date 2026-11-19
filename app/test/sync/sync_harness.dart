import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:elliotts_productivity_app/data/blob_store.dart';
import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/domain/ids.dart';
import 'package:elliotts_productivity_app/domain/node_repository.dart';
import 'package:elliotts_productivity_app/sync/blob_sync.dart';
import 'package:elliotts_productivity_app/sync/change_writer.dart';
import 'package:elliotts_productivity_app/sync/sync_engine.dart';
import 'package:elliotts_productivity_app/sync/sync_session.dart';

import '../test_support.dart';

/// A device for sync tests (called Peer: Device is the devices table row): a database, its writer, repository and engine.
class Peer {
  Peer._(this.env, this.engine);

  final TestEnv env;
  final SyncEngine engine;

  AppDatabase get db => env.db;
  NodeRepository get nodes => env.nodes;
  String get deviceId => env.writer.deviceId;
  String get userId => env.writer.userId;

  BlobStore get blobs => BlobStore(env.blobDir);

  SyncSession session() => SyncSession(
    engine,
    deviceId: deviceId,
    userId: userId,
    schemaVersion: db.schemaVersion,
    blobs: BlobSync(db, blobs),
  );

  /// A first device, with a new identity.
  static Future<Peer> first() async {
    final env = await TestEnv.create();
    return Peer._(env, SyncEngine(env.db, env.writer));
  }

  /// Another device of the same user (as if already paired and joined): same
  /// user and personal space, its own device id. Its identity rows arrive
  /// with the first sync.
  static Future<Peer> peerOf(Peer a) async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase(NativeDatabase.memory());
    final deviceId = newId();
    await db
        .into(db.devices)
        .insert(
          DevicesCompanion.insert(
            deviceId: deviceId,
            userId: a.userId,
            devicePublicKey: 'cGVlcg==',
            signedByUserKey: 'c2ln',
            isThisDevice: const Value(true),
          ),
        );
    final writer = await ChangeWriter.open(
      db,
      userId: a.userId,
      deviceId: deviceId,
    );
    final blobDir = Directory.systemTemp.createTempSync('epa_blobs_');
    final nodes = NodeRepository(
      db,
      writer,
      personalSpaceId: a.nodes.personalSpaceId,
      userId: a.userId,
      blobStore: BlobStore(blobDir),
    );
    final env = TestEnv.wrap(db, a.env.identity, writer, nodes, blobDir);
    return Peer._(env, SyncEngine(db, writer));
  }

  Future<void> close() => env.close();
}

/// Two ends of an in-memory connection. Messages go through JSON, as on
/// the wire.
(SyncChannel, SyncChannel) channelPair() {
  final ab = StreamController<Map<String, dynamic>>();
  final ba = StreamController<Map<String, dynamic>>();
  return (_MemoryChannel(ba.stream, ab), _MemoryChannel(ab.stream, ba));
}

class _MemoryChannel implements SyncChannel {
  _MemoryChannel(this.incoming, this._out);

  @override
  final Stream<Map<String, dynamic>> incoming;
  final StreamController<Map<String, dynamic>> _out;

  @override
  void send(Map<String, Object?> message) {
    if (_out.isClosed) return;
    _out.add(jsonDecode(jsonEncode(message)) as Map<String, dynamic>);
  }

  @override
  Future<void> flush() async {}

  @override
  Future<void> close() => _out.close();
}

/// One exchange between [a] and [b].
Future<(SyncReport, SyncReport)> exchange(Peer a, Peer b) async {
  final (ca, cb) = channelPair();
  final results = await Future.wait([a.session().run(ca), b.session().run(cb)]);
  await ca.close();
  await cb.close();
  return (results[0], results[1]);
}

/// Exchanges until nothing new moves (fix-ups write new ops, which the
/// next exchange carries). At most [rounds].
Future<void> syncUntilQuiet(Peer a, Peer b, {int rounds = 4}) async {
  for (var i = 0; i < rounds; i++) {
    final (ra, rb) = await exchange(a, b);
    if (ra.received == 0 && rb.received == 0) return;
  }
}

/// Every synced row on [d], by table, for comparing two devices.
Future<Map<String, List<Map<String, Object?>>>> snapshot(Peer d) async => {
  for (final t in d.db.syncedTables)
    t.actualTableName: [
      for (final r
          in await d.db
              .customSelect('SELECT * FROM ${t.actualTableName} ORDER BY id')
              .get())
        r.data,
    ],
};

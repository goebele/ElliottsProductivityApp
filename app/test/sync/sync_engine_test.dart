import 'dart:convert';
import 'dart:typed_data';

import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/domain/ids.dart';
import 'package:elliotts_productivity_app/sync/blob_sync.dart';
import 'package:elliotts_productivity_app/sync/sync_engine.dart';
import 'package:elliotts_productivity_app/sync/sync_session.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sync_harness.dart';

/// Two devices syncing through the engine and sessions, no network (§7.6
/// step 2).
void main() {
  late Peer a;
  late Peer b;

  setUp(() async {
    a = await Peer.first();
    b = await Peer.peerOf(a);
  });
  tearDown(() async {
    await a.close();
    await b.close();
  });

  Future<void> tick() => Future<void>.delayed(const Duration(milliseconds: 3));

  test('items, tags and identity rows reach the other device', () async {
    final trip = await a.nodes.create(title: 'Trip');
    await a.nodes.create(title: 'Book flight', parentId: trip);
    await a.nodes.tags.add(trip, 'travel');

    await syncUntilQuiet(a, b);
    expect((await b.nodes.get(trip))?.title, 'Trip');
    expect(
      [for (final n in await b.nodes.children(trip)) n.title],
      ['Book flight'],
    );
    expect(
      [for (final t in await b.nodes.tags.of(trip)) t.tag.name],
      ['travel'],
    );
    expect(await b.db.select(b.db.spaces).get(), hasLength(1));
    expect(await snapshot(b), await snapshot(a));
  });

  test('a second exchange sends nothing', () async {
    await a.nodes.create(title: 'One');
    await syncUntilQuiet(a, b);
    final (ra, rb) = await exchange(a, b);
    expect((ra.sent, rb.sent, ra.received, rb.received), (0, 0, 0, 0));
  });

  test('edits to different fields of one item both survive', () async {
    final n = await a.nodes.create(title: 'Dentist');
    await syncUntilQuiet(a, b);

    await a.nodes.rename(n, 'Dentist at 3');
    await tick();
    await b.nodes.setStatus(n, NodeStatus.active);
    await syncUntilQuiet(a, b);

    for (final d in [a, b]) {
      final node = (await d.nodes.get(n))!;
      expect((node.title, node.status), ('Dentist at 3', NodeStatus.active));
    }
    expect(await snapshot(b), await snapshot(a));
  });

  test('the same field edited on both: the later edit wins', () async {
    final n = await a.nodes.create(title: 'Draft');
    await syncUntilQuiet(a, b);
    await a.nodes.rename(n, 'From A');
    await tick();
    await b.nodes.rename(n, 'From B');
    await syncUntilQuiet(a, b);
    expect((await a.nodes.get(n))!.title, 'From B');
    expect((await b.nodes.get(n))!.title, 'From B');
  });

  test('trash and restore sync', () async {
    final n = await a.nodes.create(title: 'Old');
    await syncUntilQuiet(a, b);
    await b.nodes.trash(n);
    await syncUntilQuiet(a, b);
    expect((await a.nodes.get(n))!.lifecycle, Lifecycle.trashed);
    await a.nodes.restore(n);
    await syncUntilQuiet(a, b);
    expect((await b.nodes.get(n))!.lifecycle, Lifecycle.live);
  });

  test('two moves that loop: the older move is undone', () async {
    final x = await a.nodes.create(title: 'X');
    final y = await a.nodes.create(title: 'Y');
    await syncUntilQuiet(a, b);

    await a.nodes.move(x, newParentId: y); // older
    await tick();
    await b.nodes.move(y, newParentId: x); // newer
    await syncUntilQuiet(a, b);

    for (final d in [a, b]) {
      expect((await d.nodes.get(y))!.parentId, x, reason: 'newer move stays');
      expect((await d.nodes.get(x))!.parentId, isNull, reason: 'older undone');
    }
    expect(await snapshot(b), await snapshot(a));
  });

  test('#work made on both devices becomes one tag', () async {
    final n1 = await a.nodes.create(title: 'Report');
    final n2 = await b.nodes.create(title: 'Slides');
    await a.nodes.tags.add(n1, 'work');
    await b.nodes.tags.add(n2, 'Work');
    final bTag = (await b.db.select(b.db.tags).getSingle());
    await b.nodes.tags.setFavorite(bTag.id, true);

    await syncUntilQuiet(a, b);
    for (final d in [a, b]) {
      final live = await (d.db.select(
        d.db.tags,
      )..where((t) => t.deleted.equals(false))).get();
      expect(live, hasLength(1));
      expect(live.single.favorite, isTrue, reason: 'favourite carries over');
      for (final n in [n1, n2]) {
        expect(
          [for (final t in await d.nodes.tags.of(n)) t.tag.id],
          [live.single.id],
        );
      }
    }
    expect(await snapshot(b), await snapshot(a));
  });

  test('the same tag added to one item on both is one row', () async {
    final n = await a.nodes.create(title: 'Report');
    await a.nodes.tags.add(n, 'work');
    await syncUntilQuiet(a, b);
    final tag = (await b.db.select(b.db.tags).getSingle()).id;
    await a.nodes.tags.remove(n, tag);
    await tick();
    await b.nodes.tags.remove(n, tag);
    await tick();
    await b.nodes.tags.add(n, 'work');
    await syncUntilQuiet(a, b);
    final rows = await a.db.select(a.db.nodeTags).get();
    expect(rows, hasLength(1));
    expect(rows.single.deleted, isFalse, reason: 'the later add wins');
  });

  test('timers started on both: the older one ends', () async {
    final n1 = await a.nodes.create(title: 'Write');
    final n2 = await a.nodes.create(title: 'Read');
    await syncUntilQuiet(a, b);
    await a.nodes.time.start(n1);
    await tick();
    await b.nodes.time.start(n2);
    await syncUntilQuiet(a, b);
    for (final d in [a, b]) {
      expect((await d.nodes.time.running())?.nodeId, n2);
    }
    expect(await snapshot(b), await snapshot(a));
  });

  test('a pause on one device shows on the other', () async {
    final n = await a.nodes.create(title: 'Write');
    await a.nodes.time.start(n);
    await a.nodes.time.pause();
    await syncUntilQuiet(a, b);
    expect(await b.nodes.time.pausedNodeId(), n);
    await b.nodes.time.resume();
    await syncUntilQuiet(a, b);
    expect((await a.nodes.time.running())?.nodeId, n);
    expect(await a.nodes.time.pausedNodeId(), isNull);
  });

  test('unknown columns are kept, passed on, and not applied', () async {
    final c = await Peer.peerOf(a);
    final n = await a.nodes.create(title: 'Item');
    await syncUntilQuiet(a, b);
    // An op from a newer version: a column this version doesn't have.
    final op = SyncOp(
      opId: newId(),
      spaceId: a.nodes.personalSpaceId,
      table: 'nodes',
      rowId: n,
      column: 'mood',
      value: jsonEncode('happy'),
      hlc: '999999999999999-0000-future',
      originDeviceId: 'future',
      authorUserId: a.userId,
      schemaVersion: 99,
    );
    final r = await b.engine.apply([op]);
    expect((r.received, r.unknown), (1, 1));
    expect(await b.db.select(b.db.pendingUnknownOps).get(), hasLength(1));
    expect((await b.nodes.get(n))!.title, 'Item', reason: 'row unharmed');

    await syncUntilQuiet(b, c);
    final passed = await (c.db.select(
      c.db.changeLog,
    )..where((o) => o.columnName.equals('mood'))).get();
    expect(passed, hasLength(1), reason: 'passed along to the next device');
    await c.close();
  });

  test('a peer too old or too new stops the sync, applying nothing', () async {
    await a.nodes.create(title: 'Item');
    final (ca, cb) = channelPair();
    final mine = a.session().run(ca);
    // A fake peer speaking protocol 99 only.
    final peer = cb.incoming.first.then((_) {
      cb.send({
        'type': 'hello',
        'protocol': 99,
        'minProtocol': 99,
        'schema': 99,
        'device': 'future',
        'user': a.userId,
      });
    });
    await expectLater(mine, throwsA(isA<SyncVersionException>()));
    await peer;
    expect(await b.db.select(b.db.nodes).get(), isEmpty);
    await ca.close();
    await cb.close();
  });

  test('a different user is refused', () async {
    final stranger = await Peer.first();
    await expectLater(
      exchange(a, stranger),
      throwsA(isA<SyncProtocolException>()),
    );
    await stranger.close();
  });

  test('attachment files follow their rows, and resume', () async {
    final n = await a.nodes.create(title: 'Photos');
    // Three and a bit chunks.
    final bytes = Uint8List.fromList([
      for (var i = 0; i < BlobSync.chunkBytes * 3 + 1000; i++) i % 251,
    ]);
    final id = await a.nodes.files.add(
      n,
      filename: 'big.bin',
      open: () => Stream.value(bytes),
    );
    final hash = (await a.nodes.files.get(id))!.contentHash;

    // A first transfer cut short: the first chunk only.
    final first = await BlobSync(a.db, a.blobs).serve([
      {'h': hash, 'from': 0},
    ]).first;
    await syncUntilQuiet(a, b); // rows arrive (and the file, resumed)
    expect(first['at'], 0);
    expect(b.blobs.has(hash), isTrue);
    expect(await b.blobs.read(hash), bytes);

    // Nothing more to send next time.
    final (ra, rb) = await exchange(a, b);
    expect((ra.filesReceived, rb.filesReceived), (0, 0));
  });

  test('a cut-off file picks up where it stopped', () async {
    final n = await a.nodes.create(title: 'Photos');
    final bytes = Uint8List.fromList([
      for (var i = 0; i < BlobSync.chunkBytes * 2 + 10; i++) i % 13,
    ]);
    final id = await a.nodes.files.add(
      n,
      filename: 'f.bin',
      open: () => Stream.value(bytes),
    );
    final hash = (await a.nodes.files.get(id))!.contentHash;
    // b gets the first chunk only, as if the connection dropped.
    final chunk = await BlobSync(a.db, a.blobs).serve([
      {'h': hash, 'from': 0},
    ]).first;
    expect(await BlobSync(b.db, b.blobs).receive(chunk), isFalse);
    // The rows, then the rest of the file from where it stopped.
    await syncUntilQuiet(a, b);
    final wantsAfter = await BlobSync(b.db, b.blobs).wants();
    expect(wantsAfter, isEmpty);
    expect(await b.blobs.read(hash), bytes);
  });

  test('a long history goes over in pages and arrives whole', () async {
    for (var i = 0; i < 700; i++) {
      await a.nodes.create(title: 'Item $i');
    }
    final pages = await a.engine.missingPages({}, maxOps: 250).toList();
    expect(pages.length, greaterThan(3));
    final ids = {
      for (final p in pages)
        for (final op in p) op.opId,
    };
    expect(
      ids.length,
      await a.db.select(a.db.changeLog).get().then((l) => l.length),
    );
    await syncUntilQuiet(a, b);
    expect(await b.db.select(b.db.nodes).get(), hasLength(700));
  });

  test('a file bigger than its attachment says is refused', () async {
    final n = await a.nodes.create(title: 'Photos');
    final id = await a.nodes.files.add(
      n,
      filename: 'small.bin',
      open: () => Stream.value(Uint8List.fromList([1, 2, 3])),
    );
    final hash = (await a.nodes.files.get(id))!.contentHash;
    await syncUntilQuiet(a, b);
    // Pretend b lacks it, and a peer sends too much.
    final store = b.blobs;
    await store.fileFor(hash).delete();
    final ok = await BlobSync(b.db, store).receive({
      'h': hash,
      'at': 0,
      'data': base64Encode(List.filled(4096, 7)),
      'last': true,
    });
    expect(ok, isFalse);
    expect(store.has(hash), isFalse);
    // An unknown file is refused too.
    expect(
      await BlobSync(b.db, store).receive({
        'h': 'a' * 64,
        'at': 0,
        'data': base64Encode([1]),
        'last': true,
      }),
      isFalse,
    );
  });
}

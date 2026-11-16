import 'dart:convert';

import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/domain/attachment_repository.dart';
import 'package:elliotts_productivity_app/domain/node_repository.dart';
import 'package:elliotts_productivity_app/domain/search.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_support.dart';

void main() {
  late TestEnv env;
  late NodeRepository nodes;

  setUp(() async {
    env = await TestEnv.create();
    nodes = env.nodes;
  });
  tearDown(() => env.close());

  Stream<List<int>> Function() bytes(String s) =>
      () => Stream.value(utf8.encode(s));

  test('kinds come from the extension', () {
    expect(AttachmentRepository.kindOf('a.PNG').kind, AttachmentKind.image);
    expect(AttachmentRepository.kindOf('notes.md').mime, 'text/markdown');
    expect(AttachmentRepository.kindOf('x.pdf').kind, AttachmentKind.pdf);
    expect(AttachmentRepository.kindOf('x.zip').kind, AttachmentKind.other);
  });

  test('the same content is stored once; rows are separate', () async {
    final trip = await nodes.create(title: 'Trip');
    final a = await nodes.files.add(trip, filename: 'a.txt', open: bytes('hi'));
    final b = await nodes.files.add(trip, filename: 'b.txt', open: bytes('hi'));
    final fa = (await nodes.files.get(a))!;
    final fb = (await nodes.files.get(b))!;
    expect(fa.contentHash, fb.contentHash);
    expect(fa.sizeBytes, 2);
    expect(fa.spaceId, (await nodes.get(trip))!.spaceId);
    expect(await nodes.files.textOf(fa), 'hi');
    expect(
      [for (final f in await nodes.files.of(trip)) f.filename],
      ['a.txt', 'b.txt'],
    );
  });

  test(
    'rename, remove, restore; garbage collection frees unused files',
    () async {
      final trip = await nodes.create(title: 'Trip');
      final a = await nodes.files.add(
        trip,
        filename: 'a.txt',
        open: bytes('one'),
      );
      await nodes.files.rename(a, 'list.txt');
      expect((await nodes.files.get(a))!.filename, 'list.txt');
      final hash = (await nodes.files.get(a))!.contentHash;

      await nodes.files.remove(a);
      expect(await nodes.files.of(trip), isEmpty);
      await nodes.files.restore(a);
      expect(await nodes.files.of(trip), hasLength(1));

      // Archived items keep their files; removed files are freed.
      await nodes.archive(trip);
      expect(await nodes.files.collectGarbage(), 0);
      expect(nodes.files.blobs.has(hash), isTrue);
      await nodes.files.remove(a);
      expect(await nodes.files.collectGarbage(), 1);
      expect(nodes.files.blobs.has(hash), isFalse);
    },
  );

  test('replace keeps the row and its markup', () async {
    final trip = await nodes.create(title: 'Trip');
    final a = await nodes.files.add(trip, filename: 'a.txt', open: bytes('v1'));
    await nodes.files.annotate(a, AnnotationKind.highlight, {
      'start': 0,
      'end': 1,
    }, color: 0xFFFFFF00);
    await nodes.files.replace(a, filename: 'a.txt', open: bytes('v2'));
    final f = (await nodes.files.get(a))!;
    expect(await nodes.files.textOf(f), 'v2');
    expect(await nodes.files.annotations(a), hasLength(1));
  });

  test(
    'annotations stack in order and can be erased and brought back',
    () async {
      final trip = await nodes.create(title: 'Trip');
      final a = await nodes.files.add(
        trip,
        filename: 'p.png',
        open: bytes('x'),
      );
      final s1 = await nodes.files.annotate(a, AnnotationKind.stroke, {
        'points': [0.1, 0.1, 0.2, 0.2],
        'width': 0.01,
      }, color: 0xFFFF0000);
      final s2 = await nodes.files.annotate(a, AnnotationKind.textLabel, {
        'x': 0.5,
        'y': 0.5,
        'text': 'here',
      }, color: 0xFF0000FF);
      expect(
        [for (final m in await nodes.files.annotations(a)) m.id],
        [s1, s2],
      );
      await nodes.files.setAnnotationDeleted(s1, true);
      expect([for (final m in await nodes.files.annotations(a)) m.id], [s2]);
      await nodes.files.setAnnotationDeleted(s1, false);
      expect(await nodes.files.annotations(a), hasLength(2));
    },
  );

  test('a child links an ancestor\'s file; external uses count it', () async {
    final trip = await nodes.create(title: 'Trip');
    final bags = await nodes.create(title: 'Pack bags', parentId: trip);
    final a = await nodes.files.add(
      trip,
      filename: 'map.pdf',
      open: bytes('%PDF'),
    );

    final above = await nodes.files.ancestorFiles(bags);
    expect(above.single.$1.title, 'Trip');
    expect(above.single.$2.single.id, a);

    await nodes.files.link(bags, a);
    await nodes.files.link(bags, a);
    final linked = await nodes.files.watchLinked(bags).first;
    expect(linked.single.attachment!.filename, 'map.pdf');
    expect(linked.single.owner!.title, 'Trip');
    expect(
      (await nodes.files.watchLinkedInto(a).first).single.title,
      'Pack bags',
    );

    await nodes.move(bags, newParentId: null);
    expect((await nodes.externalUses(trip)).linkingItems, 1);

    await nodes.files.unlink(bags, a);
    expect(await nodes.files.watchLinked(bags).first, isEmpty);
  });

  test('filenames and text are indexed for search', () async {
    final trip = await nodes.create(title: 'Trip');
    final a = await nodes.files.add(
      trip,
      filename: 'packing.md',
      open: bytes('Remember the sunscreen'),
    );
    Future<List<String>> hits(String q) async => [
      for (final r
          in await env.db
              .customSelect(
                'SELECT attachment_id FROM attachment_search '
                "WHERE attachment_search MATCH '$q'",
              )
              .get())
        r.read<String>('attachment_id'),
    ];
    expect(await hits('sunscreen'), [a]);
    expect(await hits('packing'), [a]);
    await nodes.files.remove(a);
    expect(await hits('sunscreen'), isEmpty);
  });

  test('search finds files by name and text, judged by their owner', () async {
    final health = await nodes.values.create('Health');
    final gym = await nodes.create(title: 'Gym');
    await nodes.values.tie(gym, health);
    final trip = await nodes.create(title: 'Trip');
    final a = await nodes.files.add(
      gym,
      filename: 'plan.md',
      open: bytes('squats and lunges'),
    );
    await nodes.files.add(trip, filename: 'squat-rack.pdf', open: bytes('%'));

    Future<List<String>> find(
      String q, [
      SearchFilters f = const SearchFilters(),
    ]) async => [
      for (final r in await nodes.search.search(
        SearchQuery.parse(q),
        filters: f,
      ))
        r.attachment?.filename ?? r.node.title,
    ];
    expect(await find('squat'), ['squat-rack.pdf', 'plan.md']);
    expect(await find('lunges value:health'), ['plan.md']);
    expect(await find('squat type:task'), isEmpty);
    final r = (await nodes.search.search(SearchQuery.parse('lunges'))).single;
    expect(r.attachment!.id, a);
    expect([for (final p in r.path) p.title], ['Gym']);

    // "Has files" filters items.
    expect(await find('', const SearchFilters(hasFiles: true)), [
      'Gym',
      'Trip',
    ]);
  });
}

import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/domain/inline_tags.dart';
import 'package:elliotts_productivity_app/domain/node_repository.dart';
import 'package:elliotts_productivity_app/domain/search.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_support.dart';

void main() {
  group('inline tags', () {
    test('finds #names, once each, skipping headings, numbers and code', () {
      expect(
        inlineTagNames(
          '# Heading\nBuy #paint and #Brushes, then #paint again.\n'
          'Issue #12, a [link](#anchor), https://x.com/#frag, '
          '`#code`, AT&#38;T\n```\n#block\n```\n#trailing-',
        ),
        ['paint', 'Brushes', 'trailing'],
      );
      expect(inlineTagNames('#café #été'), ['café', 'été']);
    });
  });

  group('search query', () {
    test('parses shortcuts and leaves the rest as words', () {
      final q = SearchQuery.parse(
        'sun #travel #home/* value:"Family time" type:task is:done '
        'in:"Big Trip" "exact words" foo:bar type:nonsense',
      );
      expect(q.words, ['sun', 'foo:bar', 'type:nonsense']);
      expect(q.phrases, ['exact words']);
      expect(q.tags, [
        (name: 'travel', children: false),
        (name: 'home', children: true),
      ]);
      expect(q.values, ['Family time']);
      expect(q.types, {NodeType.task});
      expect(q.statuses, {NodeStatus.done});
      expect(q.inTopLevel, ['Big Trip']);
      expect(q.ftsMatch, '"sun"* "foo:bar"* "type:nonsense"* "exact words"');
    });

    test('an empty box is empty', () {
      expect(SearchQuery.parse('   ').isEmpty, isTrue);
    });
  });

  late TestEnv env;
  late NodeRepository nodes;

  setUp(() async {
    env = await TestEnv.create();
    nodes = env.nodes;
  });
  tearDown(() => env.close());

  Future<List<String>> tagsOf(String id) async => [
    for (final t in await nodes.tags.of(id)) t.tag.name,
  ];

  group('tags', () {
    test('inline tags follow the text; picker tags stay', () async {
      final id = await nodes.create(title: 'Buy #paint');
      expect(await tagsOf(id), ['paint']);

      await nodes.tags.add(id, '#Weekend');
      await nodes.setBody(id, 'For the #kitchen');
      expect(await tagsOf(id), ['kitchen', 'paint', 'Weekend']);

      // Removing the text removes the inline tag, and the unused tag goes.
      await nodes.rename(id, 'Buy paint');
      expect(await tagsOf(id), ['kitchen', 'Weekend']);
      expect(await nodes.tags.byName('paint'), isNull);

      // A picker tag can be removed; an inline one stays until the text
      // changes.
      final kitchen = (await nodes.tags.byName('kitchen'))!;
      await nodes.tags.remove(id, kitchen.id);
      expect(await tagsOf(id), ['kitchen', 'Weekend']);
      final weekend = (await nodes.tags.byName('weekend'))!;
      await nodes.tags.remove(id, weekend.id);
      expect(await tagsOf(id), ['kitchen']);
    });

    test('a name used again brings back the same tag, any case', () async {
      final a = await nodes.create(title: '#Travel');
      final first = (await nodes.tags.byName('travel'))!.id;
      await nodes.rename(a, 'nothing');
      expect(await nodes.tags.all(), isEmpty);
      final b = await nodes.create(title: 'Pack');
      await nodes.tags.add(b, 'TRAVEL');
      expect((await nodes.tags.byName('Travel'))!.id, first);
      expect(await tagsOf(b), ['Travel']);
    });

    test('a tag typed and picked is listed once', () async {
      final id = await nodes.create(title: 'x');
      await nodes.tags.add(id, 'home');
      await nodes.rename(id, 'x #home');
      expect(await tagsOf(id), ['home']);
    });
  });

  group('tag management', () {
    test('names: normalised, or null when they cannot be inline', () {
      expect(normalizeTagName('  #Work stuff '), 'Work-stuff');
      expect(normalizeTagName('1st'), isNull);
      expect(normalizeTagName('#'), isNull);
      expect(normalizeTagName('a/b'), isNull);
    });

    test('replaceInlineTag rewrites #name, not code or other words', () {
      expect(
        replaceInlineTag(
          'Buy #Paint, #paint-  #painter `#paint`',
          'paint',
          'decor',
        ),
        'Buy #decor, #decor-  #painter `#paint`',
      );
      expect(replaceInlineTag('Do #paint now', 'paint', null), 'Do paint now');
      expect(replaceInlineTag('nothing here', 'paint', 'x'), 'nothing here');
    });

    test('created and favourite tags stay when unused', () async {
      await nodes.tags.create('Work');
      final a = await nodes.create(title: 'x #home');
      final home = (await nodes.tags.byName('home'))!;
      await nodes.tags.setFavorite(home.id, true);
      await nodes.rename(a, 'x');
      expect(
        [for (final t in await nodes.tags.all()) t.name],
        ['home', 'Work'],
      );
      expect(() => nodes.tags.create('1bad'), throwsArgumentError);
    });

    test('rename rewrites the text and keeps the tag', () async {
      final a = await nodes.create(title: 'Buy #paint', bodyMd: 'More #paint');
      final b = await nodes.create(title: 'Brushes');
      await nodes.tags.add(b, 'paint');
      final id = (await nodes.tags.byName('paint'))!.id;
      expect(await nodes.tags.rename(id, 'decor'), id);
      final node = (await nodes.get(a))!;
      expect((node.title, node.bodyMd), ('Buy #decor', 'More #decor'));
      expect(await tagsOf(a), ['decor']);
      expect(await tagsOf(b), ['decor']);
      expect(
        await nodes.search.search(SearchQuery.parse('#decor')),
        hasLength(2),
      );
    });

    test('rename to an existing name merges, once per item', () async {
      final a = await nodes.create(title: 'Fix #job');
      final b = await nodes.create(title: 'Report');
      await nodes.tags.add(b, 'job');
      await nodes.tags.add(b, 'work');
      final job = (await nodes.tags.byName('job'))!;
      await nodes.tags.setFavorite(job.id, true);
      final work = (await nodes.tags.byName('work'))!;
      expect(await nodes.tags.rename(job.id, 'Work'), work.id);
      expect((await nodes.get(a))!.title, 'Fix #work');
      expect(await tagsOf(a), ['work']);
      expect(await tagsOf(b), ['work']);
      expect([for (final t in await nodes.tags.all()) t.name], ['work']);
      expect((await nodes.tags.byName('work'))!.favorite, isTrue);
    });

    test('delete removes it everywhere and un-hashes the text', () async {
      final a = await nodes.create(title: 'Buy #paint');
      final b = await nodes.create(title: 'Brushes');
      await nodes.tags.add(b, 'paint');
      final id = (await nodes.tags.byName('paint'))!.id;
      await nodes.tags.delete(id);
      expect((await nodes.get(a))!.title, 'Buy paint');
      expect(await tagsOf(a), isEmpty);
      expect(await tagsOf(b), isEmpty);
      expect(await nodes.tags.all(), isEmpty);
    });

    test('usage counts items, favourites first', () async {
      final a = await nodes.create(title: '#zeta #alpha');
      await nodes.create(title: '#alpha');
      final zeta = (await nodes.tags.byName('zeta'))!;
      await nodes.tags.setFavorite(zeta.id, true);
      final usage = await nodes.tags.watchUsage().first;
      expect(
        [for (final u in usage) (u.tag.name, u.count)],
        [('zeta', 1), ('alpha', 2)],
      );
      expect(a, isNotEmpty);
    });
  });

  group('values', () {
    test('effective values: own, then inherited nearest first', () async {
      final health = await nodes.values.create('Health');
      final family = await nodes.values.create('Family');
      final trip = await nodes.create(title: 'Trip');
      final europe = await nodes.create(title: 'Europe', parentId: trip);
      final bags = await nodes.create(title: 'Pack bags', parentId: europe);
      await nodes.values.tie(trip, family);
      await nodes.values.tie(trip, health);
      await nodes.values.tie(europe, health);

      final eff = await nodes.values.effectiveOf(bags);
      expect(
        [for (final e in eff) (e.value.name, e.from?.title)],
        [('Health', 'Europe'), ('Family', 'Trip')],
      );

      await nodes.values.tie(bags, family);
      final own = await nodes.values.effectiveOf(bags);
      expect(own.first.inherited, isFalse);
      expect(own.first.value.name, 'Family');
    });

    test('shortcut parents pass values down too', () async {
      final health = await nodes.values.create('Health');
      final gym = await nodes.create(title: 'Gym');
      final errands = await nodes.create(title: 'Errands');
      final shoes = await nodes.create(title: 'Shoes', parentId: errands);
      await nodes.values.tie(gym, health);
      await nodes.addPlacement(shoes, gym);
      expect((await nodes.values.effectiveOf(shoes)).single.from?.title, 'Gym');
    });

    test('deleting a value unties it everywhere; move reorders', () async {
      final a = await nodes.values.create('A');
      final b = await nodes.values.create('B');
      final c = await nodes.values.create('C');
      await nodes.values.move(c, 0);
      expect(
        [for (final v in await nodes.values.all()) v.name],
        ['C', 'A', 'B'],
      );
      final item = await nodes.create(title: 'Item');
      await nodes.values.tie(item, a);
      await nodes.values.delete(a);
      expect(await nodes.values.effectiveOf(item), isEmpty);
      expect([for (final v in await nodes.values.all()) v.id], [c, b]);
    });
  });

  group('search', () {
    Future<List<String>> find(
      String text, [
      SearchFilters filters = const SearchFilters(),
    ]) async => [
      for (final r in await nodes.search.search(
        SearchQuery.parse(text),
        filters: filters,
      ))
        r.node.title,
    ];

    test(
      'finds words by prefix in titles and text, titles ranked first',
      () async {
        await nodes.create(title: 'Packing list', bodyMd: 'sunscreen');
        await nodes.create(title: 'Sunscreen');
        await nodes.create(title: 'Unrelated');
        expect(await find('sunscr'), ['Sunscreen', 'Packing list']);
        expect(await find('pack sun'), ['Packing list']);
        expect(await find('"packing list"'), ['Packing list']);
        expect(await find(''), isEmpty);
      },
    );

    test(
      'renames and edits are re-indexed; archived needs the toggle',
      () async {
        final id = await nodes.create(title: 'Old name');
        await nodes.rename(id, 'Fresh name');
        expect(await find('old'), isEmpty);
        expect(await find('fresh'), ['Fresh name']);
        await nodes.archive(id);
        expect(await find('fresh'), isEmpty);
        expect(
          await find('fresh', const SearchFilters(includeArchived: true)),
          ['Fresh name'],
        );
        await nodes.trash(id);
        expect(
          await find('fresh', const SearchFilters(includeArchived: true)),
          isEmpty,
        );
      },
    );

    test('filters: tags (with children), values, type, status, in:', () async {
      final health = await nodes.values.create('Health');
      final trip = await nodes.create(title: 'Trip', bodyMd: '#travel');
      final bags = await nodes.create(title: 'Pack bags', parentId: trip);
      final gym = await nodes.create(title: 'Gym');
      await nodes.values.tie(gym, health);
      final run = await nodes.create(title: 'Run', parentId: gym);
      await nodes.setStatus(run, NodeStatus.done);
      await nodes.create(title: 'Idea', type: NodeType.idea, parentId: gym);

      expect(await find('#travel'), ['Trip']);
      expect(await find('#travel/*'), ['Pack bags', 'Trip']);
      expect(await find('#nosuchtag'), isEmpty);
      expect(await find('value:health'), ['Gym', 'Idea', 'Run']);
      expect(await find('value:health type:idea'), ['Idea']);
      expect(await find('value:health is:done'), ['Run']);
      expect(await find('in:Trip'), ['Pack bags', 'Trip']);
      expect(
        await find('', SearchFilters(topLevelId: gym, types: {NodeType.task})),
        ['Gym', 'Run'],
      );
      final tagId = (await nodes.tags.byName('travel'))!.id;
      expect(
        await find('', SearchFilters(tagIds: {tagId}, tagChildren: true)),
        ['Pack bags', 'Trip'],
      );
      expect(bags, isNotEmpty);
    });

    test(
      'a note passes filters through its owner or items linking it',
      () async {
        final a = await nodes.create(title: 'Project A');
        final b = await nodes.create(title: 'Project B');
        final task = await nodes.create(title: 'Task', parentId: b);
        final doc = await nodes.create(
          title: 'Spec',
          type: NodeType.note,
          parentId: a,
          bodyMd: 'details',
        );
        await nodes.linkNote(task, doc);
        // Linking from outside the ancestors is normally blocked by the UI;
        // the repository allows it, which is enough to test D19.

        final results = await nodes.search.search(
          SearchQuery.parse('in:"Project B" details'),
        );
        expect([for (final r in results) r.node.title], ['Spec']);
        expect(results.single.linkedCount, 1);
        expect([for (final p in results.single.path) p.title], ['Project A']);
        expect(await find('type:note'), ['Spec']);
      },
    );

    test('due date range', () async {
      final a = await nodes.create(title: 'Early');
      final b = await nodes.create(title: 'Late');
      await nodes.create(title: 'Undated');
      await nodes.setDueDate(a, DateTime(2026, 11, 1));
      await nodes.setDueDate(b, DateTime(2026, 12, 1));
      expect(
        await find(
          '',
          SearchFilters(
            dueFrom: DateTime(2026, 11, 1),
            dueTo: DateTime(2026, 11, 30),
          ),
        ),
        ['Early'],
      );
    });
  });
}

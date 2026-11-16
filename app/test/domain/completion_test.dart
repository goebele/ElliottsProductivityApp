import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/domain/node_repository.dart';
import 'package:elliotts_productivity_app/domain/repeat_rule.dart';
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

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  test(
    'concrete: a leaf, or a task with requirements; boxes are not',
    () async {
      final trip = await nodes.create(title: 'Trip');
      final book = await nodes.create(title: 'Book flight', parentId: trip);
      final shop = await nodes.create(title: 'Shopping', parentId: trip);
      final socks = await nodes.create(title: 'Socks', parentId: shop);
      await nodes.create(title: 'Note', type: NodeType.note, parentId: book);
      final c = nodes.completion;
      Future<bool> concrete(String id) async =>
          c.isConcrete((await nodes.get(id))!);

      expect(await concrete(book), isTrue, reason: 'a note is not an item');
      expect(await concrete(trip), isFalse);
      expect(await concrete(shop), isFalse, reason: 'tasks under it');
      // A condition and tasks under it are exclusive (§6.7.1).
      await expectLater(
        () => c.addCheckbox(shop, 'Bread'),
        throwsA(isA<PlacementNotAllowedException>()),
      );
      await nodes.trash(socks);
      final milk = await c.addCheckbox(shop, 'Milk');
      expect(await concrete(shop), isTrue);
      expect(
        await concrete((await nodes.get(milk))!.id),
        isFalse,
        reason: 'a line on a task',
      );
      // Nothing goes under a line; a task with tasks can't become one.
      await expectLater(
        () => nodes.create(title: 'Sub', parentId: milk),
        throwsA(isA<PlacementNotAllowedException>()),
      );
      final pack = await nodes.create(title: 'Pack', parentId: trip);
      await nodes.create(title: 'Bag', parentId: pack);
      await expectLater(
        () => nodes.move(pack, newParentId: shop),
        throwsA(isA<PlacementNotAllowedException>()),
      );
      expect(
        [
          for (final n in await c.concreteTasks((await nodes.get(trip))!))
            n.title,
        ],
        ['Book flight', 'Shopping', 'Bag'],
      );
      expect((await nodes.get(shop))!.childView, ChildView.checklist);
    },
  );

  test('a bare task is undefined; requirements are met together', () async {
    final piano = await nodes.create(title: 'Practice piano');
    var s = await nodes.completion.state(piano);
    expect(s.undefined, isTrue);

    await nodes.completion.setTimer(piano, 10);
    await nodes.completion.setCounter(piano, 2);
    final scales = await nodes.completion.addCheckbox(piano, 'Scales');
    s = await nodes.completion.state(piano);
    expect(
      (s.boxes, s.counter, s.timer),
      ((value: 0, target: 1), (value: 0, target: 2), (value: 0, target: 10)),
    );

    await nodes.setDone(scales, true);
    await nodes.completion.tick(piano);
    await nodes.completion.tick(piano);
    expect((await nodes.get(piano))!.status, NodeStatus.open, reason: 'timer');
    final start = now.subtract(const Duration(hours: 1));
    await nodes.time.addManual(
      piano,
      start: start,
      end: start.add(const Duration(minutes: 12)),
    );
    expect((await nodes.get(piano))!.status, NodeStatus.done);

    // Un-ticking a box reopens it.
    await nodes.setDone(scales, false);
    expect((await nodes.get(piano))!.status, NodeStatus.open);
  });

  test(
    'boxes finish their task when all are ticked, reopen on untick',
    () async {
      final shop = await nodes.create(title: 'Shopping');
      final milk = await nodes.completion.addCheckbox(shop, 'Milk');
      final eggs = await nodes.completion.addCheckbox(shop, 'Eggs');
      await nodes.setDone(milk, true);
      final s = await nodes.completion.state(shop);
      expect((s.boxes, s.done), ((value: 1, target: 2), false));
      await nodes.setDone(eggs, true);
      expect((await nodes.get(shop))!.status, NodeStatus.done);
      await nodes.setDone(eggs, false);
      expect((await nodes.get(shop))!.status, NodeStatus.open);
    },
  );

  test(
    'counter never goes below zero; removing the last requirement',
    () async {
      final probs = await nodes.create(title: 'Problems');
      await nodes.completion.setCounter(probs, 3);
      await nodes.completion.tick(probs, delta: -1);
      expect((await nodes.completion.state(probs)).counter!.value, 0);
      await nodes.completion.tick(probs);
      expect((await nodes.completion.state(probs)).counter!.value, 1);

      await nodes.completion.setCounter(probs, null);
      expect((await nodes.get(probs))!.completion, isNull);
      expect((await nodes.completion.state(probs)).undefined, isTrue);
    },
  );

  test('a repeating counter counts per occurrence', () async {
    final pushups = await nodes.create(title: 'Pushups');
    await nodes.setDates(
      pushups,
      NodeDates(rrule: const RepeatRule.daily().toRrule(), repeatStart: today),
    );
    await nodes.completion.setCounter(pushups, 2);
    await nodes.completion.tick(pushups, today: today);
    await nodes.completion.tick(pushups, today: today);
    expect((await nodes.occurrenceStatus(pushups, today: today))!.done, isTrue);
    final tomorrow = today.add(const Duration(days: 1));
    final s = await nodes.completion.state(pushups, today: tomorrow);
    expect((s.counter!.value, s.done), (0, false));
    expect((await nodes.get(pushups))!.status, NodeStatus.open);
  });

  test('Today lists concrete tasks, attached under a shared parent', () async {
    final workout = await nodes.create(title: 'Workout');
    await nodes.setDates(
      workout,
      NodeDates(rrule: const RepeatRule.daily().toRrule(), repeatStart: today),
    );
    final pushups = await nodes.create(title: 'Pushups', parentId: workout);
    final cardio = await nodes.create(title: 'Cardio', parentId: workout);
    await nodes.create(title: 'Stretches', parentId: workout);
    await nodes.completion.setCounter(pushups, 20);
    await nodes.completion.setTimer(cardio, 30);
    final plan = await nodes.create(title: 'Plan the trip');
    await nodes.today.add(plan);

    final list = await nodes.today.build();
    expect(list.blocks, hasLength(2));
    // Picks come first, then the routine's group.
    final group = list.blocks.last;
    expect(group.parent?.title, 'Workout');
    String shape(item) =>
        '${item.node.title}:${item.condition.counter != null}:'
        '${item.condition.timer != null}:${item.condition.undefined}';
    expect(
      [for (final i in group.items) shape(i)],
      [
        'Pushups:true:false:false',
        'Cardio:false:true:false',
        'Stretches:false:false:true',
      ],
    );
    expect(list.blocks.first.items.single.condition.undefined, isTrue);
  });
}

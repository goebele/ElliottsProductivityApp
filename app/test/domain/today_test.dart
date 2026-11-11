import 'dart:math' as math;

import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/domain/node_repository.dart';
import 'package:elliotts_productivity_app/domain/repeat_rule.dart';
import 'package:elliotts_productivity_app/domain/search.dart';
import 'package:elliotts_productivity_app/domain/today.dart';
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
  DateTime day(int offset) =>
      DateTime(today.year, today.month, today.day + offset);

  Future<List<String>> titles() async => [
    for (final i in (await nodes.today.build()).items)
      '${i.node.title}:${i.source.name}${i.done ? ':done' : ''}',
  ];

  test(
    'fills itself with routines, due, overdue and events; not children',
    () async {
      final gym = await nodes.create(title: 'Gym');
      await nodes.setDates(
        gym,
        NodeDates(
          rrule: const RepeatRule.daily().toRrule(),
          repeatStart: today,
        ),
      );
      await nodes.create(title: 'Warm up', parentId: gym);
      final taxes = await nodes.create(title: 'Taxes');
      await nodes.setDates(taxes, NodeDates(dueDate: day(-2)));
      final rent = await nodes.create(title: 'Rent');
      await nodes.setDates(rent, NodeDates(dueDate: today));
      final call = await nodes.create(title: 'Call');
      await nodes.setDates(
        call,
        NodeDates(
          start: today.add(const Duration(hours: 9)),
          end: today.add(const Duration(hours: 10)),
        ),
      );
      final later = await nodes.create(title: 'Later');
      await nodes.setDates(later, NodeDates(dueDate: day(3)));
      final active = await nodes.create(title: 'Doing');
      await nodes.setStatus(active, NodeStatus.active);

      expect(await titles(), [
        'Taxes:overdue',
        'Rent:dueToday',
        'Call:event',
        'Gym:routine',
      ]);
      final list = await nodes.today.build();
      expect(list.items.first.overdueDays, 2);

      // Defaults are pickable: turn routines off, In progress on.
      await nodes.today.setSettings(
        const TodaySettings(routines: false, active: true),
      );
      expect(await titles(), [
        'Taxes:overdue',
        'Rent:dueToday',
        'Call:event',
        'Doing:active',
      ]);
    },
  );

  test(
    'done today stays (struck), done earlier goes; routines per day',
    () async {
      final rent = await nodes.create(title: 'Rent');
      await nodes.setDates(rent, NodeDates(dueDate: today));
      await nodes.setStatus(rent, NodeStatus.done);
      final water = await nodes.create(title: 'Water');
      await nodes.setDates(
        water,
        NodeDates(
          rrule: const RepeatRule.daily().toRrule(),
          repeatStart: day(-3),
        ),
      );
      await nodes.completeOccurrence(water, today);
      final old = await nodes.create(title: 'Old');
      await nodes.setDates(old, NodeDates(dueDate: day(-1)));
      await nodes.setStatus(
        old,
        NodeStatus.done,
        now: day(-1).add(const Duration(hours: 12)),
      );
      expect(await titles(), ['Rent:dueToday:done', 'Water:routine:done']);
    },
  );

  test('pick, remove, hide an automatic one, reorder', () async {
    final a = await nodes.create(title: 'A');
    final b = await nodes.create(title: 'B');
    final rent = await nodes.create(title: 'Rent');
    await nodes.setDates(rent, NodeDates(dueDate: today));

    await nodes.today.add(a);
    await nodes.today.add(b);
    await nodes.today.add(a);
    expect(await titles(), ['A:picked', 'B:picked', 'Rent:dueToday']);

    await nodes.today.reorder([rent, b, a]);
    expect(await titles(), ['Rent:dueToday', 'B:picked', 'A:picked']);

    await nodes.today.remove(rent);
    await nodes.today.remove(a);
    expect(await titles(), ['B:picked']);

    // Adding back an automatic one that was removed.
    await nodes.today.add(rent);
    expect(await titles(), ['Rent:dueToday', 'B:picked']);

    // A removed automatic item stays off only for that day.
    await nodes.today.remove(rent);
    expect(
      [
        for (final i in (await nodes.today.build(now: day(1))).items)
          i.node.title,
      ],
      ['Rent'],
      reason: 'overdue tomorrow',
    );
  });

  test('unfinished picks from earlier days are asked about once', () async {
    final a = await nodes.create(title: 'A');
    final b = await nodes.create(title: 'B');
    final c = await nodes.create(title: 'C');
    await nodes.today.add(a, day: day(-1));
    await nodes.today.add(b, day: day(-1));
    await nodes.today.add(c, day: day(-2));
    await nodes.setStatus(b, NodeStatus.done);

    var list = await nodes.today.build();
    expect([for (final n in list.leftOver) n.title]..sort(), ['A', 'C']);

    await nodes.today.resolveLeftOver([a], keep: true);
    await nodes.today.resolveLeftOver([c], keep: false);
    list = await nodes.today.build();
    expect(list.leftOver, isEmpty);
    expect([for (final i in list.items) i.node.title], ['A']);
  });

  test('pick one for me: open items not on Today, filtered', () async {
    final health = await nodes.values.create('Health');
    final gym = await nodes.create(title: 'Gym');
    await nodes.values.tie(gym, health);
    final run = await nodes.create(title: 'Run', parentId: gym);
    final done = await nodes.create(title: 'Swim', parentId: gym);
    await nodes.setStatus(done, NodeStatus.done);
    await nodes.create(title: 'Taxes');

    final picked = <String>{};
    for (var i = 0; i < 20; i++) {
      final n = await nodes.today.pickOne(
        filters: SearchFilters(valueIds: {health}),
        random: math.Random(i),
      );
      picked.add(n!.title);
    }
    expect(picked, {'Gym', 'Run'});

    await nodes.today.add(run);
    await nodes.today.add(gym);
    expect(
      await nodes.today.pickOne(filters: SearchFilters(valueIds: {health})),
      isNull,
    );
  });
}

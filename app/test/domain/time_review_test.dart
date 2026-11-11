import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/domain/node_repository.dart';
import 'package:elliotts_productivity_app/domain/repeat_rule.dart';
import 'package:elliotts_productivity_app/domain/review.dart';
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

  final nine = DateTime(2026, 11, 2, 9);

  group('timer', () {
    test('one runs at a time; stopping logs the minutes', () async {
      final a = await nodes.create(title: 'A');
      final b = await nodes.create(title: 'B');
      await nodes.time.start(a, now: nine);
      expect((await nodes.time.running())!.nodeId, a);

      // Starting B stops A.
      await nodes.time.start(
        b,
        focusMinutes: 25,
        now: nine.add(const Duration(minutes: 30)),
      );
      final runningB = (await nodes.time.running())!;
      expect(runningB.nodeId, b);
      expect(runningB.focusMinutes, 25);
      final aEntries = await nodes.time.of(a);
      expect(aEntries.single.endedAt, isNotNull);

      await nodes.time.stop(now: nine.add(const Duration(minutes: 50)));
      expect(await nodes.time.running(), isNull);

      final logged = [
        for (final x in await nodes.activity.between(
          nine,
          nine.add(const Duration(hours: 2)),
        ))
          if (x.action == ActivityAction.timeLogged)
            (x.titleSnapshot, x.minutes),
      ];
      expect(logged, [('A', 30), ('B', 20)]);
    });

    test(
      'manual entries, edit, delete; roll-ups of estimates and time',
      () async {
        final trip = await nodes.create(title: 'Trip');
        final bags = await nodes.create(title: 'Pack bags', parentId: trip);
        final socks = await nodes.create(title: 'Socks', parentId: bags);
        await nodes.setEstimate(trip, 60);
        await nodes.setEstimate(bags, 30);
        await nodes.setEstimate(socks, 15);
        await nodes.time.addManual(
          trip,
          start: nine,
          end: nine.add(const Duration(minutes: 10)),
        );
        final e = await nodes.time.addManual(
          socks,
          start: nine,
          end: nine.add(const Duration(minutes: 20)),
          note: 'drawer',
        );
        var r = await nodes.time.rollup(trip);
        expect(
          (r.ownEstimate, r.childEstimates, r.ownTracked, r.childTracked),
          (60, 45, 10, 20),
        );
        expect(r.totalEstimate, 105);

        await nodes.time.edit(e, end: nine.add(const Duration(minutes: 40)));
        expect((await nodes.time.rollup(trip)).childTracked, 40);
        await nodes.time.delete(e);
        r = await nodes.time.rollup(trip);
        expect(r.totalTracked, 10);
        await nodes.time.restore(e);
        expect((await nodes.time.rollup(bags)).totalTracked, 40);
      },
    );
  });

  group('progress', () {
    test('counts every level; repeats count today; override wins', () async {
      final goal = await nodes.create(title: 'Goal', type: NodeType.goal);
      final a = await nodes.create(title: 'A', parentId: goal);
      final a1 = await nodes.create(title: 'A1', parentId: a);
      await nodes.create(title: 'B', parentId: goal);
      await nodes.create(title: 'Note', type: NodeType.note, parentId: goal);
      await nodes.setStatus(a1, NodeStatus.done);
      var p = await nodes.progress(goal);
      expect((p.done, p.total), (1, 3));

      final daily = await nodes.create(title: 'Daily', parentId: goal);
      final today = DateTime(2026, 11, 2);
      await nodes.setDates(
        daily,
        NodeDates(
          rrule: const RepeatRule.daily().toRrule(),
          repeatStart: today,
        ),
      );
      await nodes.completeOccurrence(daily, today);
      p = await nodes.progress(goal, today: today);
      expect((p.done, p.total), (2, 4));
      p = await nodes.progress(goal, today: DateTime(2026, 11, 3));
      expect((p.done, p.total), (1, 4));

      await nodes.setProgressOverride(goal, 80);
      p = await nodes.progress(goal);
      expect(p.fraction, 0.8);
      await nodes.setProgressOverride(goal, null);
      expect((await nodes.progress(goal)).override, isNull);
    });
  });

  group('review', () {
    test(
      'completed (net), time by project/value/tag, routines, overdue',
      () async {
        final health = await nodes.values.create('Health');
        final gym = await nodes.create(title: 'Gym #fit');
        await nodes.values.tie(gym, health);
        final run = await nodes.create(title: 'Run', parentId: gym);
        await nodes.setEstimate(run, 30);
        final stretch = await nodes.create(title: 'Stretch', parentId: gym);
        final taxes = await nodes.create(title: 'Taxes');
        await nodes.setDates(taxes, NodeDates(dueDate: DateTime(2026, 11, 3)));
        final water = await nodes.create(title: 'Water');
        await nodes.setDates(
          water,
          NodeDates(
            rrule: const RepeatRule.daily().toRrule(),
            repeatStart: DateTime(2026, 11, 2),
          ),
        );

        await nodes.setStatus(
          run,
          NodeStatus.done,
          now: DateTime(2026, 11, 2, 10),
        );
        await nodes.setStatus(
          stretch,
          NodeStatus.done,
          now: DateTime(2026, 11, 2, 11),
        );
        await nodes.setStatus(
          stretch,
          NodeStatus.open,
          now: DateTime(2026, 11, 2, 12),
        );
        await nodes.completeOccurrence(
          water,
          DateTime(2026, 11, 2),
          now: DateTime(2026, 11, 2, 8),
        );
        await nodes.completeOccurrence(
          water,
          DateTime(2026, 11, 4),
          now: DateTime(2026, 11, 4, 8),
        );
        await nodes.time.addManual(
          run,
          start: DateTime(2026, 11, 3, 7),
          end: DateTime(2026, 11, 3, 7, 45),
        );

        final r = await nodes.review.build(
          DateTime(2026, 11, 2),
          DateTime(2026, 11, 9),
          now: DateTime(2026, 11, 5, 12),
        );
        expect(
          [for (final c in r.completed) c.title],
          ['Water', 'Run', 'Water'],
        );
        expect(r.byProject['Gym #fit']!.single.title, 'Run');
        expect(r.byValue['Health']!.single.title, 'Run');
        expect(
          [for (final t in r.timeByProject) (t.label, t.minutes, t.estimate)],
          [('Gym #fit', 45, 30)],
        );
        expect([for (final t in r.timeByValue) t.label], ['Health']);
        expect([for (final t in r.timeByTag) t.label], isEmpty);
        final w = r.routines.singleWhere((a) => a.node.title == 'Water');
        expect((w.done, w.expected), (2, 4));
        expect([for (final n in r.overdue) n.title], ['Taxes']);
        expect([for (final n in r.carriedOver) n.title], ['Taxes']);
        expect(r.created, 0, reason: 'created before the range');

        final md = reviewMarkdown(r, title: 'Week');
        expect(md, contains('## Completed'));
        expect(md, contains('- Gym #fit: 45m of 30m estimated'));
        expect(md, contains('- Water: 2/4'));
      },
    );
  });
}

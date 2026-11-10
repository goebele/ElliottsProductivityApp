import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/domain/calendar.dart';
import 'package:elliotts_productivity_app/domain/ics.dart';
import 'package:elliotts_productivity_app/domain/node_repository.dart';
import 'package:elliotts_productivity_app/domain/repeat_rule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../test_support.dart';

void main() {
  late TestEnv env;
  late NodeRepository nodes;

  setUpAll(tzdata.initializeTimeZones);
  setUp(() async {
    env = await TestEnv.create();
    nodes = env.nodes;
    deviceTimeZone = null;
  });
  tearDown(() => env.close());

  final monday = DateTime(2026, 11, 2);
  final daily = const RepeatRule.daily().toRrule();

  group('repeating subtrees (D24)', () {
    test('children are done per occurrence; the parent when all are', () async {
      final chores = await nodes.create(title: 'Saturday chores');
      await nodes.setDates(
        chores,
        NodeDates(rrule: daily, repeatStart: monday),
      );
      final dishes = await nodes.create(title: 'Dishes', parentId: chores);
      final floor = await nodes.create(title: 'Floor', parentId: chores);
      final tue = DateTime(2026, 11, 3);

      var s = (await nodes.occurrenceStatus(dishes, today: tue))!;
      expect(s.period, tue);
      expect(s.done, isFalse);
      expect(s.repeatsWith?.id, chores);

      await nodes.setDone(dishes, true, today: tue);
      expect((await nodes.occurrenceStatus(dishes, today: tue))!.done, isTrue);
      expect((await nodes.get(dishes))!.status, NodeStatus.open);
      expect((await nodes.occurrenceStatus(chores, today: tue))!.done, isFalse);

      await nodes.setDone(floor, true, today: tue);
      expect((await nodes.occurrenceStatus(chores, today: tue))!.done, isTrue);

      // Next day: everything is fresh.
      final wed = DateTime(2026, 11, 4);
      expect((await nodes.occurrenceStatus(dishes, today: wed))!.done, isFalse);
      expect((await nodes.occurrenceStatus(chores, today: wed))!.done, isFalse);

      // Unticking undoes it for that day only.
      await nodes.setDone(dishes, false, today: tue);
      expect((await nodes.occurrenceStatus(chores, today: tue))!.done, isFalse);
    });

    test(
      'grandchildren follow too; children of a one-at-a-time set do not',
      () async {
        final week = await nodes.create(title: 'Week');
        await nodes.setDates(
          week,
          NodeDates(rrule: daily, repeatStart: monday),
        );
        final plan = await nodes.create(title: 'Plan', parentId: week);
        final step = await nodes.create(title: 'Step', parentId: plan);
        expect(
          (await nodes.occurrenceStatus(step, today: monday))!.repeatsWith?.id,
          week,
        );

        final workout = await nodes.create(title: 'Workout');
        await nodes.setDates(
          workout,
          NodeDates(rrule: daily, repeatStart: monday, exclusiveChildren: true),
        );
        final arms = await nodes.create(title: 'Arms', parentId: workout);
        expect(await nodes.occurrenceStatus(arms, today: monday), isNull);

        // A plain item outside any repeat is done for good.
        final plain = await nodes.create(title: 'Plain');
        await nodes.setDone(plain, true);
        expect((await nodes.get(plain))!.status, NodeStatus.done);
      },
    );
  });

  group('calendar', () {
    test('routines each day, events, deadlines; children not listed', () async {
      final gym = await nodes.create(title: 'Gym');
      await nodes.setDates(
        gym,
        NodeDates(
          rrule: RepeatRule.weekly({1, 3}).toRrule(),
          repeatStart: monday,
        ),
      );
      await nodes.create(title: 'Warm up', parentId: gym);
      final dentist = await nodes.create(title: 'Dentist');
      await nodes.setDates(
        dentist,
        NodeDates(
          start: DateTime(2026, 11, 4, 9),
          end: DateTime(2026, 11, 4, 10),
        ),
      );
      final passport = await nodes.create(title: 'Passport');
      await nodes.setDates(passport, NodeDates(dueDate: DateTime(2026, 11, 4)));

      final entries = await nodes.calendar.entries(
        monday,
        DateTime(2026, 11, 9),
      );
      expect(
        [
          for (final e in entries)
            '${e.day.day} ${e.node.title} ${e.kind.name}',
        ],
        [
          '2 Gym routine',
          '4 Gym routine',
          '4 Passport deadline',
          '4 Dentist event',
        ],
      );
      final dentistEntry = entries.last;
      expect(dentistEntry.start, DateTime(2026, 11, 4, 9));
      expect(dentistEntry.end, DateTime(2026, 11, 4, 10));
    });

    test(
      'a timed repeat keeps its wall-clock time across a DST change',
      () async {
        deviceTimeZone = 'America/New_York';
        final ny = tz.getLocation('America/New_York');
        final yoga = await nodes.create(title: 'Yoga');
        // 18:00 New York on Sat 31 Oct 2026 (DST ends 1 Nov).
        final start = tz.TZDateTime(ny, 2026, 10, 31, 18);
        await nodes.setDates(
          yoga,
          NodeDates(
            start: start,
            end: start.add(const Duration(hours: 1)),
            rrule: daily,
            repeatStart: DateTime(2026, 10, 31),
          ),
        );
        expect((await nodes.get(yoga))!.timeZone, 'America/New_York');
        final entries = await nodes.calendar.entries(
          DateTime(2026, 10, 31),
          DateTime(2026, 11, 3),
        );
        final inNy = [
          for (final e in entries) tz.TZDateTime.from(e.start!, ny).hour,
        ];
        expect(inNy, [18, 18, 18]);
        expect(entries.first.end!.difference(entries.first.start!).inHours, 1);
      },
    );

    test('routine entries show done per occurrence', () async {
      final r = await nodes.create(title: 'Water plants');
      await nodes.setDates(r, NodeDates(rrule: daily, repeatStart: monday));
      await nodes.completeOccurrence(r, DateTime(2026, 11, 3));
      final entries = await nodes.calendar.entries(
        monday,
        DateTime(2026, 11, 5),
      );
      expect([for (final e in entries) e.done], [false, true, false]);
    });
  });

  group('calendar filter', () {
    test('kind, done, tag, value (inherited) and under any item', () async {
      final health = await nodes.values.create('Health');
      final trip = await nodes.create(title: 'Trip');
      final europe = await nodes.create(title: 'Europe', parentId: trip);
      final flight = await nodes.create(
        title: 'Flight #travel',
        parentId: europe,
      );
      await nodes.setDates(flight, NodeDates(dueDate: DateTime(2026, 11, 3)));
      final gym = await nodes.create(title: 'Gym');
      await nodes.values.tie(gym, health);
      final run = await nodes.create(title: 'Run', parentId: gym);
      await nodes.setDates(
        run,
        NodeDates(
          start: DateTime(2026, 11, 3, 7),
          end: DateTime(2026, 11, 3, 8),
        ),
      );
      final water = await nodes.create(title: 'Water');
      await nodes.setDates(water, NodeDates(rrule: daily, repeatStart: monday));
      await nodes.completeOccurrence(water, DateTime(2026, 11, 3));

      Future<List<String>> titles(CalendarFilter f) async => [
        for (final e in await nodes.calendar.entries(
          DateTime(2026, 11, 3),
          DateTime(2026, 11, 4),
          filter: f,
        ))
          e.node.title,
      ];
      expect(await titles(const CalendarFilter()), [
        'Flight #travel',
        'Water',
        'Run',
      ]);
      expect(
        await titles(const CalendarFilter(kinds: {CalendarEntryKind.event})),
        ['Run'],
      );
      expect(await titles(const CalendarFilter(hideDone: true)), [
        'Flight #travel',
        'Run',
      ]);
      final tag = (await nodes.tags.byName('travel'))!.id;
      expect(await titles(CalendarFilter(tagIds: {tag})), ['Flight #travel']);
      expect(await titles(CalendarFilter(valueIds: {health})), ['Run']);
      expect(await titles(CalendarFilter(underId: europe)), ['Flight #travel']);
      expect(await titles(CalendarFilter(underId: trip)), ['Flight #travel']);
    });
  });

  group('reminders', () {
    test(
      'set, and planned for events and all-day items, skipping done',
      () async {
        final call = await nodes.create(title: 'Call');
        await nodes.setDates(
          call,
          NodeDates(
            start: DateTime(2026, 11, 4, 9),
            end: DateTime(2026, 11, 4, 9, 30),
          ),
        );
        final due = await nodes.create(title: 'Taxes');
        await nodes.setDates(due, NodeDates(dueDate: DateTime(2026, 11, 5)));

        await nodes.reminders.set(call, {10, 60});
        await nodes.reminders.set(call, {10});
        expect(await nodes.reminders.of(call), {10});
        await nodes.reminders.set(due, {-540, 900});

        final planned = await nodes.reminders.planned(
          DateTime(2026, 11, 4),
          DateTime(2026, 11, 6),
        );
        expect(
          [for (final p in planned) '${p.entry.node.title} ${p.at}'],
          [
            'Call 2026-11-04 08:50:00.000',
            'Taxes 2026-11-04 09:00:00.000',
            'Taxes 2026-11-05 09:00:00.000',
          ],
        );

        await nodes.setStatus(due, NodeStatus.done);
        expect(
          await nodes.reminders.planned(
            DateTime(2026, 11, 4),
            DateTime(2026, 11, 6),
          ),
          hasLength(1),
        );
      },
    );
  });

  group('.ics', () {
    test('only chosen items; events, repeats and deadlines', () async {
      final gym = await nodes.create(title: 'Gym, weights');
      await nodes.setDates(
        gym,
        NodeDates(rrule: RepeatRule.weekly({1}).toRrule(), repeatStart: monday),
      );
      final call = await nodes.create(title: 'Call');
      await nodes.setDates(
        call,
        NodeDates(
          start: DateTime.utc(2026, 11, 4, 9),
          end: DateTime.utc(2026, 11, 4, 10),
          dueDate: DateTime(2026, 11, 6),
        ),
      );
      await nodes.create(title: 'Not chosen');
      await nodes.prefs.setIcsExport(gym, true);
      await nodes.prefs.setIcsExport(call, true);
      await nodes.prefs.setIcsExport(call, true);
      final chosen = await nodes.prefs.icsExportNodes();
      expect(chosen, hasLength(2));

      final ics = buildIcs(chosen, now: DateTime.utc(2026, 11, 1));
      expect(ics, startsWith('BEGIN:VCALENDAR\r\n'));
      expect(ics, contains('SUMMARY:Gym\\, weights'));
      expect(ics, contains('DTSTART;VALUE=DATE:20261102'));
      expect(ics, contains('RRULE:FREQ=WEEKLY;BYDAY=MO'));
      expect(ics, contains('DTSTART:20261104T090000Z'));
      expect(ics, contains('SUMMARY:Due: Call'));
      expect(ics, contains('DTSTART;VALUE=DATE:20261106'));
      expect(ics, isNot(contains('Not chosen')));
      expect('BEGIN:VEVENT'.allMatches(ics), hasLength(3));
    });
  });
}

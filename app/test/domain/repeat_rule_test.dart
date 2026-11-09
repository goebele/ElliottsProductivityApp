import 'package:elliotts_productivity_app/domain/repeat_rule.dart';
import 'package:flutter_test/flutter_test.dart';

DateTime d(int y, int m, int day) => DateTime(y, m, day);

void main() {
  group('RRULE text', () {
    test('writes standard RRULE text, with INTERVAL only when above 1', () {
      expect(const RepeatRule.daily().toRrule(), 'FREQ=DAILY');
      expect(const RepeatRule.daily(interval: 3).toRrule(),
          'FREQ=DAILY;INTERVAL=3');
      expect(RepeatRule.weekly({5, 1, 3}).toRrule(),
          'FREQ=WEEKLY;BYDAY=MO,WE,FR');
      expect(RepeatRule.weekly({1, 4}, interval: 2).toRrule(),
          'FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,TH');
      expect(RepeatRule.weekdaysOnly.toRrule(),
          'FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR');
      expect(RepeatRule.monthly(15, interval: 3).toRrule(),
          'FREQ=MONTHLY;INTERVAL=3;BYMONTHDAY=15');
    });

    test('reads back what it writes', () {
      for (final rule in [
        const RepeatRule.daily(),
        const RepeatRule.daily(interval: 3),
        RepeatRule.weekly({7}),
        RepeatRule.weekly({1, 4}, interval: 2),
        RepeatRule.weekdaysOnly,
        RepeatRule.monthly(31, interval: 6),
      ]) {
        expect(RepeatRule.parse(rule.toRrule()), rule);
      }
    });

    test('every weekday means interval 1; lower case and INTERVAL=1 are fine',
        () {
      expect(
          RepeatRule.parse('FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR')!.isEveryWeekday,
          isTrue);
      expect(
          RepeatRule.parse('FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,TU,WE,TH,FR')!
              .isEveryWeekday,
          isFalse);
      expect(RepeatRule.parse('FREQ=DAILY;INTERVAL=1'),
          const RepeatRule.daily());
      expect(RepeatRule.parse('FREQ=WEEKLY;BYDAY=mo,we'),
          RepeatRule.weekly({1, 3}));
    });

    test('anything else is not ours to edit, so parse returns null', () {
      for (final rrule in [
        'FREQ=DAILY;INTERVAL=0',
        'FREQ=DAILY;INTERVAL=x',
        'FREQ=WEEKLY',
        'FREQ=WEEKLY;BYDAY=1MO',
        'FREQ=MONTHLY;BYDAY=1MO',
        'FREQ=MONTHLY;BYMONTHDAY=32',
        'FREQ=YEARLY',
        'FREQ=DAILY;COUNT=5',
        'garbage',
        '',
      ]) {
        expect(RepeatRule.parse(rrule), isNull, reason: rrule);
      }
    });
  });

  group('occurrences', () {
    test('every 3 days counts from the start day', () {
      const rule = RepeatRule.daily(interval: 3);
      final start = d(2026, 11, 2);
      expect(rule.occursOn(d(2026, 11, 2), start), isTrue);
      expect(rule.occursOn(d(2026, 11, 3), start), isFalse);
      expect(rule.occursOn(d(2026, 11, 5), start), isTrue);
      expect(rule.occursOn(d(2026, 10, 30), start), isFalse,
          reason: 'nothing before the start');
      expect(rule.nextOnOrAfter(d(2026, 11, 6), start), d(2026, 11, 8));
      expect(rule.lastOnOrBefore(d(2026, 11, 7), start), d(2026, 11, 5));
      expect(rule.lastOnOrBefore(d(2026, 11, 1), start), isNull);
    });

    test('every 2 weeks on Mon and Thu uses the start week', () {
      final rule = RepeatRule.weekly({1, 4}, interval: 2);
      final start = d(2026, 11, 4); // a Wednesday; its week counts
      expect(rule.occursOn(d(2026, 11, 5), start), isTrue); // Thu, week 0
      expect(rule.occursOn(d(2026, 11, 9), start), isFalse); // Mon, week 1
      expect(rule.occursOn(d(2026, 11, 12), start), isFalse); // Thu, week 1
      expect(rule.occursOn(d(2026, 11, 16), start), isTrue); // Mon, week 2
      expect(rule.nextOnOrAfter(d(2026, 11, 6), start), d(2026, 11, 16));
    });

    test('day 31 skips months without one', () {
      final rule = RepeatRule.monthly(31);
      final start = d(2026, 1, 1);
      expect(rule.nextOnOrAfter(d(2026, 2, 1), start), d(2026, 3, 31));
      expect(RepeatRule.monthly(15, interval: 2)
              .nextOnOrAfter(d(2026, 2, 1), start),
          d(2026, 3, 15));
    });

    test('works across a daylight-saving change', () {
      const rule = RepeatRule.daily(interval: 1);
      final start = d(2026, 3, 1);
      for (var day = 1; day <= 31; day++) {
        expect(rule.occursOn(d(2026, 3, day), start), isTrue);
      }
      expect(dayNumber(d(2026, 11, 2)) - dayNumber(d(2026, 10, 31)), 2);
    });
  });
}

import 'package:elliotts_productivity_app/domain/exclusive_picker.dart';
import 'package:elliotts_productivity_app/domain/repeat_rule.dart';
import 'package:flutter_test/flutter_test.dart';

DateTime d(int day) => DateTime(2026, 11, day);

/// Workout repeats daily from Nov 1.
ExclusiveState pick(List<ExclusiveChild> children, int today,
        {RepeatRule parent = const RepeatRule.daily()}) =>
    pickExclusive(
      parentRule: parent,
      parentStart: d(1),
      children: children,
      today: d(today),
    );

ExclusiveChild child(String id, {RepeatRule? every, int? lastDone}) =>
    ExclusiveChild(
      id: id,
      rule: every,
      start: d(1),
      lastDone: lastDone == null ? null : d(lastDone),
    );

String? dueId(ExclusiveState s) => s is ExclusiveDue ? s.childId : null;

void main() {
  test('never-done children come first, in list order', () {
    final s = pick([child('arms'), child('core'), child('legs')], 1);
    expect(dueId(s), 'arms');
    expect((s as ExclusiveDue).overdueDays, isNull);
  });

  test('plain rotation falls out of the parent cadence', () {
    // Arms Nov 1, Core Nov 2, Legs Nov 3 → Nov 4 is Arms again.
    final s = pick(
      [child('arms', lastDone: 1), child('core', lastDone: 2), child('legs', lastDone: 3)],
      4,
    );
    expect(dueId(s), 'arms');
    expect((s as ExclusiveDue).overdueDays, 2);
  });

  test('different cadences: the furthest past its due date wins', () {
    const every3 = RepeatRule.daily(interval: 3);
    const every2 = RepeatRule.daily(interval: 2);
    // Arms (every 3) done Nov 2 → due Nov 5.  Core (every 2) done Nov 3 → due
    // Nov 5... same day; ties go to list order. On Nov 6 both are 1 day late.
    final children = [
      child('arms', every: every3, lastDone: 2),
      child('core', every: every2, lastDone: 3),
    ];
    expect(dueId(pick(children, 5)), 'arms');

    // Core done Nov 2 instead → due Nov 4, so on Nov 5 it is 1 day late
    // while Arms is due today (0).
    final later = [
      child('arms', every: every3, lastDone: 2),
      child('core', every: every2, lastDone: 2),
    ];
    final s = pick(later, 5) as ExclusiveDue;
    expect(s.childId, 'core');
    expect(s.overdueDays, 1);
  });

  test('being behind never suggests two: one done this period is enough', () {
    const every2 = RepeatRule.daily(interval: 2);
    final s = pick([
      child('arms', every: every2, lastDone: 1),
      child('core', every: every2, lastDone: 10), // done today
    ], 10);
    expect(s, isA<ExclusiveDone>());
    expect((s as ExclusiveDone).childId, 'core');
  });

  test('nothing due when every child is within its cadence', () {
    const every3 = RepeatRule.daily(interval: 3);
    final s = pick([
      child('arms', every: every3, lastDone: 8),
      child('core', every: every3, lastDone: 9),
    ], 10);
    expect(s, isA<ExclusiveNothingDue>());
  });

  test('pattern cadences use the next due date after the last completion',
      () {
    // Mon/Thu child done Mon Nov 2 → next due Thu Nov 5.
    final monThu = RepeatRule.weekly({1, 4});
    expect(dueId(pick([child('swim', every: monThu, lastDone: 2)], 4)), isNull);
    final s = pick([child('swim', every: monThu, lastDone: 2)], 7) as ExclusiveDue;
    expect(s.overdueDays, 2);
  });

  test('periods follow the parent: a Mon/Wed/Fri workout counts Tue for Mon',
      () {
    final mwf = RepeatRule.weekly({1, 3, 5});
    // Done on Mon Nov 2 (recorded for that occurrence); Tue Nov 3 is still
    // in Monday's period, so nothing more is suggested.
    final s = pick([child('arms', lastDone: 2), child('core')], 3, parent: mwf);
    expect(s, isA<ExclusiveDone>());
    final wed = pick([child('arms', lastDone: 2), child('core')], 4, parent: mwf);
    expect(dueId(wed), 'core');
  });

  test('a parent series that has not started suggests nothing', () {
    final s = pickExclusive(
      parentRule: const RepeatRule.daily(),
      parentStart: d(20),
      children: [child('arms')],
      today: d(10),
    );
    expect(s, isA<ExclusiveNothingDue>());
    expect((s as ExclusiveNothingDue).periodStart, isNull);
  });
}

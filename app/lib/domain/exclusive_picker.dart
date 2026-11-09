/// Picks which child of an exclusive set (D36) is up for the parent's
/// current occurrence.
///
/// Example: Workout repeats daily; Arms (every 3 days), Core (every 2 days)
/// and Legs (no repeat, so daily like its parent) take turns. Each day at
/// most one is suggested: the one furthest past its next due date.
library;

import 'repeat_rule.dart';

class ExclusiveChild {
  const ExclusiveChild({
    required this.id,
    required this.rule,
    required this.start,
    required this.lastDone,
  });

  final String id;

  /// The child's own cadence, or null to use the parent's.
  final RepeatRule? rule;

  /// Series start for [rule] (ignored when [rule] is null).
  final DateTime start;

  /// Occurrence date of the child's most recent completion, if any.
  final DateTime? lastDone;
}

sealed class ExclusiveState {
  const ExclusiveState();
}

/// [childId] is up next. [overdueDays] is how far past its due date it is
/// (null if it was never done).
class ExclusiveDue extends ExclusiveState {
  const ExclusiveDue(this.childId, this.overdueDays, this.periodStart);
  final String childId;
  final int? overdueDays;

  /// The parent occurrence this pick counts for.
  final DateTime periodStart;
}

/// A child was already done for the current parent occurrence; exclusive
/// means no second one.
class ExclusiveDone extends ExclusiveState {
  const ExclusiveDone(this.childId, this.periodStart);
  final String childId;
  final DateTime periodStart;
}

/// Nothing is due (every child is within its cadence), or the parent's
/// series hasn't started yet ([periodStart] null).
class ExclusiveNothingDue extends ExclusiveState {
  const ExclusiveNothingDue(this.periodStart);
  final DateTime? periodStart;
}

/// [children] in list order (ties go to the earlier one).
ExclusiveState pickExclusive({
  required RepeatRule parentRule,
  required DateTime parentStart,
  required List<ExclusiveChild> children,
  required DateTime today,
}) {
  final period = parentRule.lastOnOrBefore(today, parentStart);
  if (period == null) return const ExclusiveNothingDue(null);
  final periodDay = dayNumber(period);

  for (final c in children) {
    final last = c.lastDone;
    if (last != null && dayNumber(last) >= periodDay) {
      return ExclusiveDone(c.id, period);
    }
  }

  final todayNumber = dayNumber(today);
  String? bestId;
  int? bestScore; // null = never done, which beats any number
  var bestNever = false;

  for (final c in children) {
    final rule = c.rule ?? parentRule;
    final start = c.rule == null ? parentStart : c.start;
    final last = c.lastDone;

    final int? score;
    if (last == null) {
      score = null;
    } else {
      final due = _nextDue(rule, start, last);
      if (due == null || dayNumber(due) > todayNumber) continue;
      score = todayNumber - dayNumber(due);
    }

    final better =
        bestId == null ||
        (score == null && !bestNever) ||
        (score != null && !bestNever && score > bestScore!);
    if (better) {
      bestId = c.id;
      bestScore = score;
      bestNever = score == null;
    }
  }

  return bestId == null
      ? ExclusiveNothingDue(period)
      : ExclusiveDue(bestId, bestScore, period);
}

/// When a child is next due after being done on [last].
///
/// "Every N days" counts from the last completion (the cadence is a gap, so
/// doing it late shifts the next one). Weekly and monthly patterns name
/// calendar days, so the next one is the pattern's next day after [last].
DateTime? _nextDue(RepeatRule rule, DateTime start, DateTime last) {
  if (rule.frequency == RepeatFrequency.daily) {
    return DateTime(last.year, last.month, last.day + rule.interval);
  }
  return rule.nextOnOrAfter(
    DateTime(last.year, last.month, last.day + 1),
    start,
  );
}

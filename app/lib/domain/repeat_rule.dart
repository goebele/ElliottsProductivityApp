/// The repeat schedules the picker offers, stored as RFC 5545 RRULE text in
/// `nodes.rrule` (D3), with the series start in `nodes.repeat_start`.
/// A rule outside these forms (e.g. written by a newer version) is kept as
/// stored; [RepeatRule.parse] returns null for it and the UI shows it as
/// custom.
///
/// Supported: every N days; a weekly pattern (chosen weekdays) every N weeks;
/// a day of the month every N months.
library;

enum RepeatFrequency { daily, weekly, monthly }

class RepeatRule {
  const RepeatRule.daily({this.interval = 1})
    : assert(interval >= 1),
      frequency = RepeatFrequency.daily,
      weekdays = const {},
      monthDay = null;

  /// [weekdays] uses [DateTime.monday] (1) … [DateTime.sunday] (7).
  RepeatRule.weekly(Set<int> weekdays, {this.interval = 1})
    : assert(interval >= 1),
      assert(weekdays.isNotEmpty && weekdays.every((d) => d >= 1 && d <= 7)),
      frequency = RepeatFrequency.weekly,
      weekdays = Set.unmodifiable(weekdays),
      monthDay = null;

  RepeatRule.monthly(int this.monthDay, {this.interval = 1})
    : assert(interval >= 1),
      assert(monthDay >= 1 && monthDay <= 31),
      frequency = RepeatFrequency.monthly,
      weekdays = const {};

  static final weekdaysOnly = RepeatRule.weekly({1, 2, 3, 4, 5});

  final RepeatFrequency frequency;

  /// Every [interval] days / weeks / months.
  final int interval;
  final Set<int> weekdays;
  final int? monthDay;

  bool get isEveryWeekday =>
      frequency == RepeatFrequency.weekly &&
      interval == 1 &&
      weekdays.length == 5 &&
      weekdays.containsAll(const {1, 2, 3, 4, 5});

  static const _dayCodes = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];

  String toRrule() {
    final every = interval > 1 ? ';INTERVAL=$interval' : '';
    return switch (frequency) {
      RepeatFrequency.daily => 'FREQ=DAILY$every',
      RepeatFrequency.weekly =>
        'FREQ=WEEKLY$every;BYDAY=${[for (final d in weekdays.toList()..sort()) _dayCodes[d - 1]].join(',')}',
      RepeatFrequency.monthly => 'FREQ=MONTHLY$every;BYMONTHDAY=$monthDay',
    };
  }

  /// Null if [rrule] is not one of the forms above.
  static RepeatRule? parse(String rrule) {
    final parts = <String, String>{};
    for (final part in rrule.split(';')) {
      final eq = part.indexOf('=');
      if (eq <= 0) return null;
      parts[part.substring(0, eq).toUpperCase()] = part.substring(eq + 1);
    }
    var interval = 1;
    if (parts.remove('INTERVAL') case final text?) {
      final n = int.tryParse(text);
      if (n == null || n < 1) return null;
      interval = n;
    }

    switch (parts.remove('FREQ')) {
      case 'DAILY' when parts.isEmpty:
        return RepeatRule.daily(interval: interval);
      case 'WEEKLY':
        final byDay = parts.remove('BYDAY');
        if (byDay == null || parts.isNotEmpty) return null;
        final days = <int>{};
        for (final code in byDay.split(',')) {
          final index = _dayCodes.indexOf(code.toUpperCase());
          if (index < 0) return null;
          days.add(index + 1);
        }
        return days.isEmpty
            ? null
            : RepeatRule.weekly(days, interval: interval);
      case 'MONTHLY':
        final day = int.tryParse(parts.remove('BYMONTHDAY') ?? '');
        if (day == null || day < 1 || day > 31 || parts.isNotEmpty) {
          return null;
        }
        return RepeatRule.monthly(day, interval: interval);
      default:
        return null;
    }
  }

  // ------------------------------------------------------------ occurrences
  //
  // Day-level only (times of day and time zones arrive in M5). The series
  // starts at [start]: nothing occurs before it, and intervals count from
  // its day / week (weeks start on Monday, RRULE's default) / month.

  /// Whether the series starting on [start] occurs on [day].
  bool occursOn(DateTime day, DateTime start) {
    final d = dayNumber(day);
    final s = dayNumber(start);
    if (d < s) return false;
    switch (frequency) {
      case RepeatFrequency.daily:
        return (d - s) % interval == 0;
      case RepeatFrequency.weekly:
        if (!weekdays.contains(day.weekday)) return false;
        final weeks =
            ((d - (day.weekday - 1)) - (s - (start.weekday - 1))) ~/ 7;
        return weeks % interval == 0;
      case RepeatFrequency.monthly:
        if (day.day != monthDay) return false;
        final months = (day.year - start.year) * 12 + (day.month - start.month);
        return months % interval == 0;
    }
  }

  /// The first occurrence on or after [from], or null if there is none
  /// within a generous search window.
  DateTime? nextOnOrAfter(DateTime from, DateTime start) {
    var day = _date(dayNumber(from) < dayNumber(start) ? start : from);
    for (var i = 0; i < _searchDays; i++) {
      if (occursOn(day, start)) return day;
      day = _addDays(day, 1);
    }
    return null;
  }

  /// The last occurrence on or before [onOrBefore], or null if the series
  /// hasn't started by then.
  DateTime? lastOnOrBefore(DateTime onOrBefore, DateTime start) {
    var day = _date(onOrBefore);
    for (var i = 0; i < _searchDays; i++) {
      if (dayNumber(day) < dayNumber(start)) return null;
      if (occursOn(day, start)) return day;
      day = _addDays(day, -1);
    }
    return null;
  }

  /// Long enough to find day 31 every N months, short enough to stay cheap.
  int get _searchDays => 62 * interval + 400;

  @override
  bool operator ==(Object other) =>
      other is RepeatRule && other.toRrule() == toRrule();

  @override
  int get hashCode => toRrule().hashCode;
}

/// Days since the epoch for [d]'s calendar date, immune to DST shifts.
int dayNumber(DateTime d) =>
    DateTime.utc(d.year, d.month, d.day).millisecondsSinceEpoch ~/
    Duration.millisecondsPerDay;

DateTime _date(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime _addDays(DateTime d, int days) =>
    DateTime(d.year, d.month, d.day + days);

import 'package:timezone/timezone.dart' as tz;

import '../data/database.dart';
import 'calendar.dart';
import 'node_repository.dart';
import 'repeat_rule.dart';

/// An iCalendar (.ics) file of [nodes] for Google, Outlook or Apple
/// calendars (DESIGN.md §6.5). Exporting is opt-in, per item: nothing is
/// sent anywhere, the file is just saved.
///
/// - A time slot becomes a timed event (in its time zone when known, else
///   UTC), repeating with its rule.
/// - A repeat with no time slot becomes an all-day repeating event.
/// - An all-day deadline becomes an all-day event on that day ("Due: …");
///   a timed one, a zero-length event.
/// Items with none of these are left out.
String buildIcs(Iterable<Node> nodes, {DateTime? now, String product = 'EPA'}) {
  final stamp = _utc(now ?? DateTime.now());
  final lines = <String>[
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//$product//Calendar export//EN',
    'CALSCALE:GREGORIAN',
  ];

  void event(String uid, List<String> body, String summary, String? desc) {
    lines
      ..add('BEGIN:VEVENT')
      ..add('UID:$uid')
      ..add('DTSTAMP:$stamp')
      ..addAll(body)
      ..add('SUMMARY:${_escape(summary)}');
    if (desc != null && desc.trim().isNotEmpty) {
      lines.add('DESCRIPTION:${_escape(desc.trim())}');
    }
    lines.add('END:VEVENT');
  }

  for (final n in nodes) {
    if (n.deleted || n.type == NodeType.note) continue;
    final title = n.title.trim().isEmpty ? 'Untitled' : n.title.trim();
    final rule = n.rrule == null ? null : RepeatRule.parse(n.rrule!);
    final rrule = rule == null ? null : 'RRULE:${rule.toRrule()}';

    if (n.startAt case final start?) {
      final end = n.endAt ?? start;
      final zone = zoneNamed(n.timeZone);
      final body = zone == null
          ? ['DTSTART:${_utc(start)}', 'DTEND:${_utc(end)}']
          : [
              'DTSTART;TZID=${n.timeZone}:${_local(tz.TZDateTime.from(start, zone))}',
              'DTEND;TZID=${n.timeZone}:${_local(tz.TZDateTime.from(end, zone))}',
            ];
      event('${n.id}@epa', [...body, ?rrule], title, n.bodyMd);
    } else if (rule != null) {
      final first =
          rule.nextOnOrAfter(seriesStart(n), seriesStart(n)) ?? seriesStart(n);
      event(
        '${n.id}@epa',
        [
          'DTSTART;VALUE=DATE:${_date(first)}',
          'DTEND;VALUE=DATE:${_date(first.add(const Duration(days: 1)))}',
          rrule!,
        ],
        title,
        n.bodyMd,
      );
    }

    if (n.dueDate case final key?) {
      final d = parseDateKey(key);
      event(
        '${n.id}-due@epa',
        [
          'DTSTART;VALUE=DATE:${_date(d)}',
          'DTEND;VALUE=DATE:${_date(DateTime(d.year, d.month, d.day + 1))}',
        ],
        'Due: $title',
        n.bodyMd,
      );
    } else if (n.dueAt case final at?) {
      event(
        '${n.id}-due@epa',
        ['DTSTART:${_utc(at)}', 'DTEND:${_utc(at)}'],
        'Due: $title',
        n.bodyMd,
      );
    }
  }
  lines.add('END:VCALENDAR');
  return '${lines.map(_fold).join('\r\n')}\r\n';
}

String _two(int n) => n.toString().padLeft(2, '0');

String _date(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}${_two(d.month)}${_two(d.day)}';

String _utc(DateTime t) {
  final u = t.toUtc();
  return '${_date(u)}T${_two(u.hour)}${_two(u.minute)}${_two(u.second)}Z';
}

String _local(DateTime t) =>
    '${_date(t)}T${_two(t.hour)}${_two(t.minute)}${_two(t.second)}';

String _escape(String s) => s
    .replaceAll(r'\', r'\\')
    .replaceAll(';', r'\;')
    .replaceAll(',', r'\,')
    .replaceAll('\r\n', r'\n')
    .replaceAll('\n', r'\n');

/// Lines longer than 75 octets are folded (RFC 5545 §3.1).
String _fold(String line) {
  if (line.length <= 75) return line;
  final out = StringBuffer(line.substring(0, 75));
  for (var i = 75; i < line.length; i += 74) {
    out
      ..write('\r\n ')
      ..write(line.substring(i, i + 74 > line.length ? line.length : i + 74));
  }
  return out.toString();
}

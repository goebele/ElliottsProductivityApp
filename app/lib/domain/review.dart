import 'dart:convert';

import '../data/database.dart';
import 'node_repository.dart';
import 'repeat_rule.dart';
import 'time_tracking.dart';

/// Something finished in the range, as it was when it was finished.
class CompletedItem {
  const CompletedItem({
    required this.nodeId,
    required this.title,
    required this.at,
    this.projectId,
    this.project,
    this.valueIds = const [],
    this.occurrence,
  });

  final String nodeId;
  final String title;
  final DateTime at;
  final String? projectId;
  final String? project;
  final List<String> valueIds;

  /// For a repeat: which occurrence.
  final String? occurrence;
}

/// Minutes tracked against a group (a project, value or tag), and the
/// estimates of the items that time went to.
class TimeLine {
  TimeLine(this.id, this.label);
  final String id;
  final String label;
  int minutes = 0;
  int estimate = 0;
}

/// A repeat's occurrences in the range, and how many were done.
class Adherence {
  const Adherence(this.node, this.done, this.expected);
  final Node node;
  final int done;
  final int expected;
}

/// "What did I do this week?" (DESIGN.md §6.16) for any range. Built from
/// `activity`, `time_entries` and `occurrence_completions`, so it still
/// works after items are archived or purged.
class Review {
  const Review({
    required this.from,
    required this.to,
    required this.completed,
    required this.timeByProject,
    required this.timeByValue,
    required this.timeByTag,
    required this.routines,
    required this.created,
    required this.overdue,
    required this.carriedOver,
    required this.valueNames,
  });

  final DateTime from;
  final DateTime to;
  final List<CompletedItem> completed;
  final List<TimeLine> timeByProject;
  final List<TimeLine> timeByValue;
  final List<TimeLine> timeByTag;
  final List<Adherence> routines;
  final int created;

  /// Live, unfinished items whose deadline has passed.
  final List<Node> overdue;

  /// Unfinished items that were due within the range.
  final List<Node> carriedOver;

  /// Value id → name, for grouping by value.
  final Map<String, String> valueNames;

  int get totalMinutes => timeByProject.fold(0, (a, t) => a + t.minutes);

  /// Completed items by top-level project title ("" = top-level items).
  Map<String, List<CompletedItem>> get byProject {
    final out = <String, List<CompletedItem>>{};
    for (final c in completed) {
      (out[c.project ?? ''] ??= []).add(c);
    }
    return out;
  }

  /// Completed items by value name; items with no value are left out.
  Map<String, List<CompletedItem>> get byValue {
    final out = <String, List<CompletedItem>>{};
    for (final c in completed) {
      for (final v in c.valueIds) {
        final name = valueNames[v];
        if (name != null) (out[name] ??= []).add(c);
      }
    }
    return out;
  }
}

String formatMinutes(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '${m}m';
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}

class ReviewService {
  ReviewService(this._nodes);

  final NodeRepository _nodes;

  /// The review of local days [from] up to (not including) [to].
  Future<Review> build(DateTime from, DateTime to, {DateTime? now}) async {
    final today = now ?? DateTime.now();
    final todayDay = DateTime(today.year, today.month, today.day);

    // Completed: the last completed/uncompleted per item (and occurrence)
    // decides.
    final acts = await _nodes.activity.between(from, to);
    final last = <String, ActivityData>{};
    var created = 0;
    for (final a in acts) {
      if (a.action == ActivityAction.created) created++;
      if (a.action == ActivityAction.completed ||
          a.action == ActivityAction.uncompleted) {
        last['${a.nodeId}|${a.occurrenceDate ?? ''}'] = a;
      }
    }
    final completed = [
      for (final a in last.values)
        if (a.action == ActivityAction.completed)
          CompletedItem(
            nodeId: a.nodeId,
            title: a.titleSnapshot,
            at: a.at.toLocal(),
            projectId: a.topProjectId,
            project: a.topProjectId == a.nodeId ? null : a.topProjectSnapshot,
            valueIds: [
              for (final v in jsonDecode(a.valuesSnapshot) as List) v as String,
            ],
            occurrence: a.occurrenceDate,
          ),
    ]..sort((a, b) => a.at.compareTo(b.at));

    // Time, by where the items are now.
    final values = {for (final v in await _nodes.values.all()) v.id: v.name};
    final byProject = <String, TimeLine>{};
    final byValue = <String, TimeLine>{};
    final byTag = <String, TimeLine>{};
    final estimated = <String, Set<String>>{};
    for (final e in await _nodes.time.between(from, to)) {
      final minutes =
          overlapSeconds(e, from.toUtc(), to.toUtc(), now: today) ~/ 60;
      if (minutes == 0) continue;
      final node = await _nodes.get(e.nodeId);
      final ancestors = await _nodes.ancestors(e.nodeId);
      final top = ancestors.isEmpty ? node : ancestors.first;
      final estimate = node?.estimateMinutes ?? 0;
      void add(Map<String, TimeLine> into, String id, String label) {
        final line = into[id] ??= TimeLine(id, label);
        line.minutes += minutes;
        // Each item's estimate counts once per group.
        if ((estimated['${into.hashCode}|$id'] ??= {}).add(e.nodeId)) {
          line.estimate += estimate;
        }
      }

      add(byProject, top?.id ?? e.nodeId, top?.title ?? '');
      for (final v in await _nodes.values.effectiveOf(e.nodeId)) {
        add(byValue, v.value.id, v.value.name);
      }
      for (final t in await _nodes.tags.of(e.nodeId)) {
        add(byTag, t.tag.id, '#${t.tag.name}');
      }
    }
    List<TimeLine> sorted(Map<String, TimeLine> m) =>
        m.values.toList()..sort((a, b) => b.minutes.compareTo(a.minutes));

    // Routines: occurrences up to today in the range, and how many done.
    final routines = <Adherence>[];
    final end = to.isAfter(todayDay.add(const Duration(days: 1)))
        ? todayDay.add(const Duration(days: 1))
        : to;
    for (final n in await _nodes.repeating()) {
      final rule = RepeatRule.parse(n.rrule!);
      if (rule == null) continue;
      final start = seriesStart(n);
      var expected = 0;
      var done = 0;
      for (
        var d = DateTime(from.year, from.month, from.day);
        d.isBefore(end);
        d = DateTime(d.year, d.month, d.day + 1)
      ) {
        if (!rule.occursOn(d, start)) continue;
        expected++;
        if (await _nodes.occurrenceDone(n, dateKey(d))) done++;
      }
      if (expected > 0) routines.add(Adherence(n, done, expected));
    }

    final overdue = <Node>[];
    final carried = <Node>[];
    for (final n in await _nodes.withDeadlines()) {
      if (isFinished(n.status)) continue;
      final due = parseDateKey(n.dueDate!);
      if (due.isBefore(todayDay)) overdue.add(n);
      if (!due.isBefore(from) && due.isBefore(to) && due.isBefore(todayDay)) {
        carried.add(n);
      }
    }

    return Review(
      from: from,
      to: to,
      completed: completed,
      timeByProject: sorted(byProject),
      timeByValue: sorted(byValue),
      timeByTag: sorted(byTag),
      routines: routines,
      created: created,
      overdue: overdue,
      carriedOver: carried,
      valueNames: values,
    );
  }
}

/// The review as Markdown, to copy or save.
String reviewMarkdown(Review r, {required String title}) {
  final b = StringBuffer('# $title\n\n');
  b.writeln(
    '${r.completed.length} completed · ${r.created} created · '
    '${formatMinutes(r.totalMinutes)} tracked\n',
  );
  if (r.completed.isNotEmpty) {
    b.writeln('## Completed\n');
    for (final MapEntry(:key, :value) in r.byProject.entries) {
      b.writeln('### ${key.isEmpty ? 'Top level' : key}\n');
      for (final c in value) {
        b.writeln(
          '- ${c.title}${c.occurrence == null ? '' : ' (${c.occurrence})'}',
        );
      }
      b.writeln();
    }
    final byValue = r.byValue;
    if (byValue.isNotEmpty) {
      b.writeln('## By value\n');
      for (final MapEntry(:key, :value) in byValue.entries) {
        b.writeln('- **$key**: ${value.length}');
      }
      b.writeln();
    }
  }
  void time(String heading, List<TimeLine> lines) {
    if (lines.isEmpty) return;
    b.writeln('## $heading\n');
    for (final t in lines) {
      final est = t.estimate == 0
          ? ''
          : ' of ${formatMinutes(t.estimate)} estimated';
      b.writeln(
        '- ${t.label.isEmpty ? 'Untitled' : t.label}: ${formatMinutes(t.minutes)}$est',
      );
    }
    b.writeln();
  }

  time('Time by project', r.timeByProject);
  time('Time by value', r.timeByValue);
  time('Time by tag', r.timeByTag);
  if (r.routines.isNotEmpty) {
    b.writeln('## Routines\n');
    for (final a in r.routines) {
      b.writeln('- ${a.node.title}: ${a.done}/${a.expected}');
    }
    b.writeln();
  }
  if (r.overdue.isNotEmpty) {
    b.writeln('## Overdue\n');
    for (final n in r.overdue) {
      b.writeln('- ${n.title} (due ${n.dueDate})');
    }
    b.writeln();
  }
  return b.toString();
}

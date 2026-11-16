import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/database.dart';
import '../domain/repeat_rule.dart';
import '../l10n/app_localizations.dart';

export '../domain/node_repository.dart' show isFinished;

extension NodeLabels on AppLocalizations {
  String nodeType(NodeType type) => switch (type) {
    NodeType.goal => typeGoal,
    NodeType.project => typeProject,
    NodeType.task => typeTask,
    NodeType.idea => typeIdea,
    NodeType.note => typeNote,
  };

  String nodeStatus(NodeStatus status) => switch (status) {
    NodeStatus.open => statusOpen,
    NodeStatus.active => statusActive,
    NodeStatus.waiting => statusWaiting,
    NodeStatus.done => statusDone,
    NodeStatus.dropped => statusDropped,
  };

  String titleOrUntitled(String title) =>
      title.trim().isEmpty ? untitled : title;

  /// "Every 3 days", "Every weekday", "Every 2 weeks on Mon, Thu", … or the
  /// raw rule if the app doesn't recognize it.
  String repeatSummary(String rrule, String locale) {
    final rule = RepeatRule.parse(rrule);
    if (rule == null) return repeatCustom(rrule);
    if (rule.isEveryWeekday) return repeatWeekdays;
    return switch (rule.frequency) {
      RepeatFrequency.daily => repeatEveryDays(rule.interval),
      RepeatFrequency.weekly => repeatEveryWeeks(
        rule.interval,
        [
          for (final d in rule.weekdays.toList()..sort())
            weekdayShort(d, locale),
        ].join(', '),
      ),
      RepeatFrequency.monthly => repeatEveryMonths(
        rule.interval,
        rule.monthDay!,
      ),
    };
  }
}

/// Short weekday name for [weekday] ([DateTime.monday] … [DateTime.sunday]).
String weekdayShort(int weekday, String locale) =>
    DateFormat.E(locale).format(DateTime(2024, 1, weekday)); // 2024-01-01 = Mon

IconData nodeTypeIcon(NodeType type) => switch (type) {
  NodeType.goal => Icons.flag_outlined,
  NodeType.project => Icons.folder_outlined,
  NodeType.task => Icons.assignment_outlined,
  NodeType.idea => Icons.lightbulb_outline,
  NodeType.note => Icons.sticky_note_2_outlined,
};

/// The row icon for a node, inferred from what it has: a repeat makes it a
/// routine, a time slot an event, a list layout a list. A plain task has
/// none, so nothing in a row looks like a checkbox you could tick.
IconData? nodeIcon(Node node) {
  if (node.type == NodeType.task) {
    if (node.rrule != null) return Icons.repeat;
    if (node.startAt != null) return Icons.event_outlined;
    if (node.childView == ChildView.checklist) return Icons.checklist;
    return null;
  }
  return nodeTypeIcon(node.type);
}

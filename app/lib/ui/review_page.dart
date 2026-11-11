import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../domain/review.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'markup.dart' show saveBytesAs;
import 'tree_pane.dart';

/// "What did I do this week?" (DESIGN.md §6.16) for a day, week, month or
/// chosen dates, with Copy as Markdown and Export.

typedef _Range = ({DateTime from, DateTime to});

final reviewProvider = FutureProvider.family<Review, _Range>((ref, r) async {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  return repo.review.build(r.from, r.to);
});

enum ReviewSpan { day, week, month, custom }

DateTime _d(DateTime t) => DateTime(t.year, t.month, t.day);
DateTime _add(DateTime d, int n) => DateTime(d.year, d.month, d.day + n);

class ReviewPage extends ConsumerStatefulWidget {
  const ReviewPage({super.key, required this.onOpen});

  final OpenNode onOpen;

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  ReviewSpan _span = ReviewSpan.week;
  DateTime _anchor = _d(DateTime.now());
  DateTimeRange? _custom;

  _Range get _range {
    switch (_span) {
      case ReviewSpan.day:
        return (from: _anchor, to: _add(_anchor, 1));
      case ReviewSpan.week:
        final mon = _add(_anchor, -(_anchor.weekday - 1));
        return (from: mon, to: _add(mon, 7));
      case ReviewSpan.month:
        return (
          from: DateTime(_anchor.year, _anchor.month),
          to: DateTime(_anchor.year, _anchor.month + 1),
        );
      case ReviewSpan.custom:
        final c =
            _custom ?? DateTimeRange(start: _add(_anchor, -6), end: _anchor);
        return (from: _d(c.start), to: _add(_d(c.end), 1));
    }
  }

  void _step(int dir) => setState(
    () => _anchor = switch (_span) {
      ReviewSpan.day => _add(_anchor, dir),
      ReviewSpan.week => _add(_anchor, 7 * dir),
      ReviewSpan.month => DateTime(_anchor.year, _anchor.month + dir),
      ReviewSpan.custom => _anchor,
    },
  );

  String _title(String locale) {
    final r = _range;
    final last = _add(r.to, -1);
    return r.from == last
        ? DateFormat.yMMMEd(locale).format(r.from)
        : '${DateFormat.MMMd(locale).format(r.from)} – '
              '${DateFormat.yMMMd(locale).format(last)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final range = _range;
    final review = ref.watch(reviewProvider(range));
    final title = l10n.reviewTitleFor(_title(locale));

    Future<void> copy(Review r) async {
      await Clipboard.setData(
        ClipboardData(text: reviewMarkdown(r, title: title)),
      );
      if (context.mounted) {
        ScaffoldMessenger.maybeOf(context)
            ?.showSnackBar(SnackBar(content: Text(l10n.reviewCopied)));
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Text(l10n.reviewView, style: theme.textTheme.headlineSmall),
            SegmentedButton<ReviewSpan>(
              showSelectedIcon: false,
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              segments: [
                ButtonSegment(
                  value: ReviewSpan.day,
                  label: Text(l10n.calendarDay),
                ),
                ButtonSegment(
                  value: ReviewSpan.week,
                  label: Text(l10n.calendarWeek),
                ),
                ButtonSegment(
                  value: ReviewSpan.month,
                  label: Text(l10n.calendarMonth),
                ),
                ButtonSegment(
                  value: ReviewSpan.custom,
                  label: Text(l10n.reviewCustom),
                ),
              ],
              selected: {_span},
              onSelectionChanged: (s) async {
                if (s.single == ReviewSpan.custom) {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDateRange: _custom,
                  );
                  if (picked == null) return;
                  setState(() {
                    _custom = picked;
                    _span = ReviewSpan.custom;
                  });
                } else {
                  setState(() => _span = s.single);
                }
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_span != ReviewSpan.custom) ...[
                  IconButton(
                    tooltip: l10n.calendarPrevious,
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _step(-1),
                  ),
                  TextButton(
                    onPressed: () =>
                        setState(() => _anchor = _d(DateTime.now())),
                    child: Text(l10n.reviewThis),
                  ),
                  IconButton(
                    tooltip: l10n.calendarNext,
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => _step(1),
                  ),
                ],
                if (review.value case final r?) ...[
                  IconButton(
                    tooltip: l10n.reviewCopy,
                    icon: const Icon(Icons.copy),
                    onPressed: () => copy(r),
                  ),
                  IconButton(
                    tooltip: l10n.reviewExport,
                    icon: const Icon(Icons.ios_share),
                    onPressed: () => saveBytesAs(
                      context,
                      'review.md',
                      utf8.encode(reviewMarkdown(r, title: title)),
                      'text/markdown',
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(_title(locale), style: theme.textTheme.titleMedium),
        ),
        switch (review) {
          AsyncData(value: final r) => _ReviewBody(
            review: r,
            onOpen: widget.onOpen,
          ),
          AsyncError(:final error) => Text('$error'),
          _ => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
        },
      ],
    );
  }
}

class _ReviewBody extends StatelessWidget {
  const _ReviewBody({required this.review, required this.onOpen});

  final Review review;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = review;

    Widget section(String title, List<Widget> children) => Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          ...children,
        ],
      ),
    );

    Widget stat(String value, String label) => Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.headlineSmall),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );

    Widget timeLines(List<TimeLine> lines) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final t in lines)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    t.label.isEmpty ? l10n.untitled : t.label,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: t.estimate == 0
                        ? (r.totalMinutes == 0 ? 0 : t.minutes / r.totalMinutes)
                        : t.minutes / t.estimate,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  t.estimate == 0
                      ? formatMinutes(t.minutes)
                      : l10n.trackedOf(
                          formatMinutes(t.minutes),
                          formatMinutes(t.estimate),
                        ),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
      ],
    );

    final empty =
        r.completed.isEmpty &&
        r.totalMinutes == 0 &&
        r.routines.isEmpty &&
        r.created == 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            stat('${r.completed.length}', l10n.reviewCompleted),
            stat('${r.created}', l10n.reviewCreated),
            stat(formatMinutes(r.totalMinutes), l10n.reviewTracked),
            stat('${r.overdue.length}', l10n.reviewOverdue),
          ],
        ),
        if (empty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.reviewEmpty, textAlign: TextAlign.center),
          ),
        if (r.completed.isNotEmpty)
          section(l10n.reviewCompletedByProject, [
            for (final MapEntry(:key, :value) in r.byProject.entries) ...[
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  key.isEmpty ? l10n.topLevel : key,
                  style: theme.textTheme.labelLarge,
                ),
              ),
              for (final c in value)
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 8),
                  leading: const Icon(Icons.check_circle_outline, size: 18),
                  title: Text(c.title.isEmpty ? l10n.untitled : c.title),
                  subtitle: c.occurrence == null ? null : Text(c.occurrence!),
                  onTap: () => onOpen(c.nodeId),
                ),
            ],
          ]),
        if (r.byValue.isNotEmpty)
          section(l10n.reviewCompletedByValue, [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final MapEntry(:key, :value) in r.byValue.entries)
                  Chip(label: Text('$key · ${value.length}')),
              ],
            ),
          ]),
        if (r.timeByProject.isNotEmpty)
          section(l10n.reviewTimeByProject, [timeLines(r.timeByProject)]),
        if (r.timeByValue.isNotEmpty)
          section(l10n.reviewTimeByValue, [timeLines(r.timeByValue)]),
        if (r.timeByTag.isNotEmpty)
          section(l10n.reviewTimeByTag, [timeLines(r.timeByTag)]),
        if (r.routines.isNotEmpty)
          section(l10n.reviewRoutines, [
            for (final a in r.routines)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  a.done == a.expected ? Icons.verified : Icons.repeat,
                  size: 20,
                ),
                title: Text(
                  a.node.title.isEmpty ? l10n.untitled : a.node.title,
                ),
                trailing: Text('${a.done}/${a.expected}'),
                onTap: () => onOpen(a.node.id),
              ),
          ]),
        if (r.overdue.isNotEmpty)
          section(l10n.reviewOverdueTitle, [
            for (final n in r.overdue)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.flag_outlined, size: 20),
                title: Text(n.title.isEmpty ? l10n.untitled : n.title),
                subtitle: Text(l10n.reviewDue(n.dueDate!)),
                onTap: () => onOpen(n.id),
              ),
          ]),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/database.dart';
import '../domain/node_repository.dart';
import '../domain/review.dart' show formatMinutes;
import '../domain/time_tracking.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';

/// Estimates, tracked time and progress on an item (DESIGN.md §6.15–16).

final rollupProvider = StreamProvider.family<TimeRollup, String>((
  ref,
  id,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.time.watchRollup(id);
});

final progressProvider = StreamProvider.family<Progress, String>((
  ref,
  id,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.watchProgress(id);
});

final timeEntriesProvider = StreamProvider.family<List<TimeEntry>, String>((
  ref,
  id,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.time.watchOf(id);
});

/// "⏳ Est. 1h" (or "+ Estimate") and "⏱ 25m of 1h" chips, with the totals
/// for the items under it when they have any.
class TimeChips extends ConsumerWidget {
  const TimeChips({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final r = ref.watch(rollupProvider(node.id)).value ?? const TimeRollup();
    final estimate = node.estimateMinutes;
    Future<NodeRepository> repo() => ref.read(nodeRepositoryProvider.future);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (estimate == null)
          ActionChip(
            avatar: const Icon(Icons.hourglass_empty, size: 18),
            label: Text(l10n.estimateAdd),
            onPressed: () => _editEstimate(context, ref),
          )
        else
          InputChip(
            avatar: const Icon(Icons.hourglass_bottom, size: 18),
            label: Text(l10n.estimateIs(formatMinutes(estimate))),
            deleteButtonTooltipMessage: l10n.remove,
            onPressed: () => _editEstimate(context, ref),
            onDeleted: () async => (await repo()).setEstimate(node.id, null),
          ),
        ActionChip(
          avatar: const Icon(Icons.timer_outlined, size: 18),
          label: Text(
            r.ownTracked == 0
                ? l10n.trackedNone
                : estimate == null
                ? l10n.trackedIs(formatMinutes(r.ownTracked))
                : l10n.trackedOf(
                    formatMinutes(r.ownTracked),
                    formatMinutes(estimate),
                  ),
          ),
          tooltip: l10n.trackedTooltip,
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) => _TimeEntriesDialog(node: node),
          ),
        ),
        if (r.childEstimates > 0 || r.childTracked > 0)
          Chip(
            avatar: const Icon(Icons.account_tree_outlined, size: 18),
            label: Text(
              l10n.rollupItems(
                formatMinutes(r.childTracked),
                formatMinutes(r.childEstimates),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _editEstimate(BuildContext context, WidgetRef ref) async {
    final minutes = await showDialog<int?>(
      context: context,
      builder: (_) => _EstimateDialog(current: node.estimateMinutes),
    );
    if (minutes == null) return;
    await (await ref.read(nodeRepositoryProvider.future))
        .setEstimate(node.id, minutes <= 0 ? null : minutes);
  }
}

class _EstimateDialog extends StatefulWidget {
  const _EstimateDialog({this.current});
  final int? current;

  @override
  State<_EstimateDialog> createState() => _EstimateDialogState();
}

class _EstimateDialogState extends State<_EstimateDialog> {
  static const presets = [15, 30, 45, 60, 90, 120, 240, 480];
  late final _custom = TextEditingController(
    text: widget.current == null ? '' : '${widget.current}',
  );

  @override
  void dispose() {
    _custom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.estimateTitle),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in presets)
                  ChoiceChip(
                    label: Text(formatMinutes(m)),
                    selected: widget.current == m,
                    onSelected: (_) => Navigator.pop(context, m),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _custom,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.estimateMinutes,
                suffixText: 'min',
              ),
              onSubmitted: (v) => Navigator.pop(context, int.tryParse(v)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, int.tryParse(_custom.text)),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

/// The item's time entries, newest first, with Add time…, edit and delete.
class _TimeEntriesDialog extends ConsumerWidget {
  const _TimeEntriesDialog({required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final entries = ref.watch(timeEntriesProvider(node.id)).value ?? const [];
    final day = DateFormat.MMMEd(locale);
    String time(DateTime t) =>
        TimeOfDay.fromDateTime(t.toLocal()).format(context);
    Future<NodeRepository> repo() => ref.read(nodeRepositoryProvider.future);

    return AlertDialog(
      title: Text(l10n.timeEntriesTitle),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(l10n.timeEntriesEmpty),
              ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final e in entries)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        e.endedAt == null
                            ? Icons.timer
                            : e.source == TimeSource.manual
                            ? Icons.edit_calendar_outlined
                            : Icons.timer_outlined,
                      ),
                      title: Text(
                        '${day.format(e.startedAt.toLocal())} · '
                        '${time(e.startedAt)}–'
                        '${e.endedAt == null ? l10n.timerNow : time(e.endedAt!)}',
                      ),
                      subtitle: Text(
                        [
                          formatMinutes(entryMinutes(e)),
                          if (e.note != null && e.note!.isNotEmpty) e.note!,
                        ].join(' · '),
                      ),
                      trailing: e.endedAt == null
                          ? null
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: l10n.timeEdit,
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () => showDialog<void>(
                                    context: context,
                                    builder: (_) =>
                                        _ManualDialog(node: node, entry: e),
                                  ),
                                ),
                                IconButton(
                                  tooltip: l10n.timeDelete,
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () async =>
                                      (await repo()).time.delete(e.id),
                                ),
                              ],
                            ),
                    ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l10n.timeAdd),
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => _ManualDialog(node: node),
                ),
              ),
            ),
            Text(l10n.timePersonal, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.done),
        ),
      ],
    );
  }
}

/// Adds (or, with [entry], edits) time after the fact: day, start, length
/// and a note.
class _ManualDialog extends ConsumerStatefulWidget {
  const _ManualDialog({required this.node, this.entry});

  final Node node;
  final TimeEntry? entry;

  @override
  ConsumerState<_ManualDialog> createState() => _ManualDialogState();
}

class _ManualDialogState extends ConsumerState<_ManualDialog> {
  late DateTime _day;
  late TimeOfDay _start;
  late final _minutes = TextEditingController();
  late final _note = TextEditingController(text: widget.entry?.note);

  @override
  void initState() {
    super.initState();
    final e = widget.entry;
    final start =
        e?.startedAt.toLocal() ??
        DateTime.now().subtract(const Duration(minutes: 30));
    _day = DateTime(start.year, start.month, start.day);
    _start = TimeOfDay.fromDateTime(start);
    _minutes.text = '${e == null ? 30 : entryMinutes(e)}';
  }

  @override
  void dispose() {
    _minutes.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final minutes = int.tryParse(_minutes.text);
    if (minutes == null || minutes <= 0) return;
    final start = DateTime(
      _day.year,
      _day.month,
      _day.day,
      _start.hour,
      _start.minute,
    );
    final end = start.add(Duration(minutes: minutes));
    final time = (await ref.read(nodeRepositoryProvider.future)).time;
    final e = widget.entry;
    e == null
        ? await time.addManual(
            widget.node.id,
            start: start,
            end: end,
            note: _note.text.trim(),
          )
        : await time.edit(
            e.id,
            start: start,
            end: end,
            note: _note.text.trim(),
          );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final material = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.entry == null ? l10n.timeAdd : l10n.timeEdit),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(material.formatMediumDate(_day)),
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _day,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (d != null) setState(() => _day = d);
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.schedule, size: 18),
                  label: Text(_start.format(context)),
                  onPressed: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: _start,
                    );
                    if (t != null) setState(() => _start = t);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _minutes,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.timeLength,
                suffixText: 'min',
              ),
            ),
            TextField(
              controller: _note,
              decoration: InputDecoration(labelText: l10n.timeNote),
              onSubmitted: (_) => _save(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(material.cancelButtonLabel),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.save)),
      ],
    );
  }
}

/// A progress bar for an item with items under it (or a hand-set
/// percentage): "4/12 · 33%".
class ProgressRow extends ConsumerWidget {
  const ProgressRow({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = ref.watch(progressProvider(node.id)).value;
    if (p == null || (p.total == 0 && p.override == null)) {
      return const SizedBox.shrink();
    }
    final percent = (p.fraction * 100).round();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: p.fraction, minHeight: 8),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            p.override != null
                ? l10n.progressManual(percent)
                : l10n.progressItems(p.done, p.total, percent),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// ⋮ → "Set progress manually…": a slider; "Count items again" clears it.
Future<void> editProgress(
  BuildContext context,
  WidgetRef ref,
  Node node,
) async {
  final result = await showDialog<int>(
    context: context,
    builder: (_) => _ProgressDialog(initial: node.progressOverride ?? 0),
  );
  if (result == null) return;
  await (await ref.read(nodeRepositoryProvider.future))
      .setProgressOverride(node.id, result < 0 ? null : result);
}

class _ProgressDialog extends StatefulWidget {
  const _ProgressDialog({required this.initial});
  final int initial;

  @override
  State<_ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<_ProgressDialog> {
  late double _value = widget.initial.toDouble();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.progressSetTitle),
      content: SizedBox(
        width: 360,
        child: Slider(
          value: _value,
          max: 100,
          divisions: 20,
          label: '${_value.round()}%',
          onChanged: (v) => setState(() => _value = v),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, -1),
          child: Text(l10n.progressUseItems),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _value.round()),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

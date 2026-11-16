import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/completion.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'prompt_dialog.dart';
import 'timer.dart';

/// Requirements in a task's Items (DESIGN.md §6.7.1): its counter and timer
/// rows, and "+ Requirement". Its checkboxes are its items.

final requirementsProvider = StreamProvider.family<RequirementsState, String>((
  ref,
  id,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  final db = ref.watch(databaseProvider);
  yield* db
      .customSelect(
        'SELECT 1 AS requirements_state',
        readsFrom: {
          db.nodes,
          db.occurrenceCompletions,
          db.counterTicks,
          db.timeEntries,
        },
      )
      .watch()
      .asyncMap((_) => repo.completion.state(id));
});

Future<CompletionService> _svc(WidgetRef ref) async =>
    (await ref.read(nodeRepositoryProvider.future)).completion;

/// "+ Requirement": a checkbox, a counter or a timer.
class AddRequirementButton extends ConsumerWidget {
  const AddRequirementButton({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.check_box_outlined),
          onPressed: () async {
            final title = await promptText(
              context,
              title: l10n.requirementCheckboxAsk,
            );
            if (title == null || title.isEmpty) return;
            await (await _svc(ref)).addCheckbox(node.id, title);
          },
          child: Text(l10n.requirementCheckbox),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.exposure_plus_1),
          onPressed: node.counterTarget != null
              ? null
              : () async {
                  final n = await promptNumber(
                    context,
                    title: l10n.completionCounterAsk,
                    initial: 4,
                  );
                  if (n != null) await (await _svc(ref)).setCounter(node.id, n);
                },
          child: Text(l10n.completionCounter),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.timer_outlined),
          onPressed: node.timerMinutes != null
              ? null
              : () async {
                  final n = await promptNumber(
                    context,
                    title: l10n.completionTimerAsk,
                    initial: 30,
                    suffix: 'min',
                  );
                  if (n != null) await (await _svc(ref)).setTimer(node.id, n);
                },
          child: Text(l10n.completionTimer),
        ),
      ],
      builder: (context, controller, _) => TextButton.icon(
        icon: const Icon(Icons.add_task),
        label: Text(l10n.requirementAdd),
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}

/// The counter and timer rows above a task's checkboxes.
class RequirementRows extends ConsumerWidget {
  const RequirementRows({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final s = ref.watch(requirementsProvider(node.id)).value;

    Widget row({
      required IconData icon,
      required String label,
      required Tally? tally,
      required String text,
      required List<Widget> actions,
      required VoidCallback onEdit,
      required VoidCallback onRemove,
    }) {
      final t = tally;
      final met = t != null && t.value >= t.target;
      return Card(
        margin: const EdgeInsets.only(bottom: 6),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 4, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    met ? Icons.check_circle : icon,
                    size: 20,
                    color: met ? theme.colorScheme.primary : null,
                  ),
                  const SizedBox(width: 10),
                  Text(label, style: theme.textTheme.titleSmall),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: onEdit,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(text, style: theme.textTheme.bodyLarge),
                      ),
                    ),
                  ),
                  ...actions,
                  IconButton(
                    tooltip: l10n.requirementRemove,
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: onRemove,
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: t == null || t.target == 0
                      ? 0
                      : (t.value / t.target).clamp(0, 1),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (node.timerMinutes case final minutes?)
          row(
            icon: Icons.timer_outlined,
            label: l10n.completionTimer,
            tally: s?.timer,
            text: l10n.completionTimerState(s?.timer?.value ?? 0, minutes),
            actions: [TimerButton(node: node)],
            onEdit: () async {
              final n = await promptNumber(
                context,
                title: l10n.completionTimerAsk,
                initial: minutes,
                suffix: 'min',
              );
              if (n != null) await (await _svc(ref)).setTimer(node.id, n);
            },
            onRemove: () async => (await _svc(ref)).setTimer(node.id, null),
          ),
        if (node.counterTarget case final target?)
          row(
            icon: Icons.exposure_plus_1,
            label: l10n.completionCounter,
            tally: s?.counter,
            text: l10n.completionCounterState(s?.counter?.value ?? 0, target),
            actions: [
              IconButton(
                tooltip: l10n.completionCountDown,
                icon: const Icon(Icons.remove),
                onPressed: (s?.counter?.value ?? 0) <= 0
                    ? null
                    : () async => (await _svc(ref)).tick(node.id, delta: -1),
              ),
              FilledButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.completionCountUp),
                onPressed: () async => (await _svc(ref)).tick(node.id),
              ),
            ],
            onEdit: () async {
              final n = await promptNumber(
                context,
                title: l10n.completionCounterAsk,
                initial: target,
              );
              if (n != null) await (await _svc(ref)).setCounter(node.id, n);
            },
            onRemove: () async => (await _svc(ref)).setCounter(node.id, null),
          ),
      ],
    );
  }
}

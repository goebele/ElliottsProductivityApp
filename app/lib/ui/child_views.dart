import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/markdown_format.dart';
import '../domain/node_repository.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'labels.dart';
import 'peek.dart';
import 'time_ui.dart';
import 'tree_pane.dart';
import 'tree_providers.dart';

/// An item's sub-items, drawn in its child view (DESIGN.md §6.13): panels
/// (cards, the default), a checklist, or numbered steps. Every view can be
/// reordered by its drag handles and drilled into.
class ChildrenSection extends ConsumerStatefulWidget {
  const ChildrenSection({
    super.key,
    required this.parent,
    required this.onOpen,
  });

  final Node parent;
  final OpenNode onOpen;

  @override
  ConsumerState<ChildrenSection> createState() => _ChildrenSectionState();
}

class _ChildrenSectionState extends ConsumerState<ChildrenSection> {
  final _addController = TextEditingController();
  final _addFocus = FocusNode();

  @override
  void dispose() {
    _addController.dispose();
    _addFocus.dispose();
    super.dispose();
  }

  Future<NodeRepository> get _repo => ref.read(nodeRepositoryProvider.future);

  Future<void> _add(String title) async {
    if (title.trim().isEmpty) return;
    _addController.clear();
    _addFocus.requestFocus();
    await (await _repo).create(title: title.trim(), parentId: widget.parent.id);
    // Show the new child in the tree too.
    ref.read(expandedNodesProvider.notifier).expandAll([widget.parent.id]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final parentId = widget.parent.id;
    final exclusive = ref.watch(exclusiveProvider(parentId)).value;
    // Shortcuts don't take turns in a one-at-a-time set (D36).
    final children = [
      for (final c in ref.watch(childrenProvider(parentId)).value ?? const [])
        if (exclusive == null || !c.isShortcut) c,
    ];
    final view = widget.parent.childView ?? ChildView.panels;

    Widget handle(int index) => ReorderableDragStartListener(
      index: index,
      child: Tooltip(
        message: l10n.reorderHandle,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Icon(Icons.drag_indicator),
        ),
      ),
    );

    // In a one-at-a-time set, rows show their cadence instead of being
    // ticked: completing happens per occurrence, on the card (D36).
    // Inside a repeating item, "done" is per occurrence (D24).
    bool done(Node n) => _isDone(ref, n);
    final nextStep = view == ChildView.steps
        ? children.indexWhere((c) => !done(c.node))
        : -1;
    Widget rowContent(int i, NodeWithChildCount entry) {
      void open() {
        ref
            .read(openedViaProvider.notifier)
            .opening(
              entry.node.id,
              viaParent: entry.isShortcut ? parentId : null,
            );
        widget.onOpen(entry.node.id);
      }

      if (exclusive != null) {
        return _CadenceRow(
          key: ValueKey(entry.key),
          entry: entry,
          exclusive: exclusive,
          handle: handle(i),
          onOpen: open,
        );
      }
      return switch (view) {
        ChildView.panels => _Panel(
          key: ValueKey(entry.key),
          entry: entry,
          handle: handle(i),
          onOpen: open,
        ),
        ChildView.checklist => _ChecklistRow(
          key: ValueKey(entry.key),
          entry: entry,
          handle: handle(i),
          onOpen: open,
        ),
        ChildView.steps => _StepRow(
          key: ValueKey(entry.key),
          entry: entry,
          number: i + 1,
          state: i == nextStep
              ? _StepState.next
              : done(entry.node)
              ? _StepState.finished
              : _StepState.later,
          handle: handle(i),
          onOpen: open,
        ),
      };
    }

    Widget row(int i, NodeWithChildCount entry) => KeyedSubtree(
      key: ValueKey(entry.key),
      child: PeekTarget(
        nodeId: entry.node.id,
        onOpen: widget.onOpen,
        child: rowContent(i, entry),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.childrenHeading,
                style: theme.textTheme.titleMedium,
              ),
            ),
            if (exclusive == null)
              SegmentedButton<ChildView>(
                showSelectedIcon: false,
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                segments: [
                  ButtonSegment(
                    value: ChildView.panels,
                    icon: const Icon(Icons.view_agenda_outlined),
                    tooltip: l10n.viewPanels,
                  ),
                  ButtonSegment(
                    value: ChildView.checklist,
                    icon: const Icon(Icons.checklist),
                    tooltip: l10n.viewChecklist,
                  ),
                  ButtonSegment(
                    value: ChildView.steps,
                    icon: const Icon(Icons.format_list_numbered),
                    tooltip: l10n.viewSteps,
                  ),
                ],
                selected: {view},
                onSelectionChanged: (s) async =>
                    (await _repo).setChildView(parentId, s.single),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (exclusive != null) _ExclusiveCard(status: exclusive),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          onReorderItem: (from, to) async {
            if (to == from) return;
            final entry = children[from];
            final repo = await _repo;
            entry.isShortcut
                ? await repo.movePlacement(
                    entry.placementId!,
                    newParentId: parentId,
                    index: to,
                  )
                : await repo.move(
                    entry.node.id,
                    newParentId: parentId,
                    index: to,
                  );
          },
          children: [for (final (i, entry) in children.indexed) row(i, entry)],
        ),
        TextField(
          controller: _addController,
          focusNode: _addFocus,
          decoration: InputDecoration(
            hintText: l10n.addChildHint,
            prefixIcon: const Icon(Icons.add),
            border: InputBorder.none,
          ),
          onSubmitted: _add,
        ),
      ],
    );
  }
}

TextStyle? _finishedStyle(bool finished, TextStyle? base, ThemeData theme) =>
    finished
    ? base?.copyWith(
            decoration: TextDecoration.lineThrough,
            color: theme.colorScheme.onSurfaceVariant,
          ) ??
          TextStyle(
            decoration: TextDecoration.lineThrough,
            color: theme.colorScheme.onSurfaceVariant,
          )
    : base;

Future<void> _setDone(WidgetRef ref, Node node, bool done) async =>
    (await ref.read(nodeRepositoryProvider.future)).setDone(node.id, done);

/// Done for good, or for this occurrence when it repeats or sits inside a
/// repeating item (D24).
bool _isDone(WidgetRef ref, Node node) {
  final occ = ref.watch(occurrenceProvider(node.id)).value;
  return occ != null ? occ.done : isFinished(node.status);
}

/// One card per child: status, dates, progress, a description preview and
/// how many items it has.
class _Panel extends ConsumerWidget {
  const _Panel({
    super.key,
    required this.entry,
    required this.handle,
    required this.onOpen,
  });

  final NodeWithChildCount entry;
  final Widget handle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final material = MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final node = entry.node;
    final finished = _isDone(ref, node);

    final meta = [
      if (node.status != NodeStatus.open) l10n.nodeStatus(node.status),
      if (node.dueDate != null)
        l10n.dueOn(material.formatMediumDate(parseDateKey(node.dueDate!))),
      if (node.startAt != null)
        material.formatMediumDate(node.startAt!.toLocal()),
      if (node.rrule != null) l10n.repeatSummary(node.rrule!, locale),
    ];
    final description = markdownPlainText(node.bodyMd);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onOpen,
          child: Opacity(
            opacity: finished ? 0.6 : 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 4, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        nodeIcon(node) ?? nodeTypeIcon(node.type),
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.titleOrUntitled(node.title),
                          style: _finishedStyle(
                            finished,
                            theme.textTheme.titleMedium,
                            theme,
                          ),
                        ),
                      ),
                      if (entry.isShortcut) const ShortcutMarker(),
                      if (entry.noteCount > 0) ...[
                        Icon(
                          Icons.sticky_note_2_outlined,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        Text(
                          ' ${entry.noteCount}',
                          style: theme.textTheme.labelSmall,
                        ),
                        const SizedBox(width: 4),
                      ],
                      handle,
                    ],
                  ),
                  if (meta.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 28, top: 2),
                      child: Text(
                        meta.join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  if (entry.childCount > 0 || node.progressOverride != null)
                    if (ref.watch(progressProvider(node.id)).value
                        case final p?)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 8, 12, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: p.fraction,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              p.override != null
                                  ? '${p.override}%'
                                  : l10n.progressCount(p.done, p.total),
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                  if (description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 6, 12, 0),
                      child: Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A plain row with a checkbox. Rows with their own items show "›".
class _ChecklistRow extends ConsumerWidget {
  const _ChecklistRow({
    super.key,
    required this.entry,
    required this.handle,
    required this.onOpen,
  });

  final NodeWithChildCount entry;
  final Widget handle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final node = entry.node;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Checkbox(
        value: _isDone(ref, node),
        onChanged: (checked) => _setDone(ref, node, checked == true),
      ),
      title: Text(
        l10n.titleOrUntitled(node.title),
        style: _finishedStyle(_isDone(ref, node), null, theme),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (entry.isShortcut) const ShortcutMarker(),
          if (entry.childCount > 0) ...[
            Text('${entry.childCount}', style: theme.textTheme.labelSmall),
            const Icon(Icons.chevron_right),
          ],
          handle,
        ],
      ),
      onTap: onOpen,
    );
  }
}

enum _StepState { finished, next, later }

/// A numbered step. Only the next unfinished step is highlighted and can be
/// marked done; later ones are dimmed, finished ones can be unticked.
class _StepRow extends ConsumerWidget {
  const _StepRow({
    super.key,
    required this.entry,
    required this.number,
    required this.state,
    required this.handle,
    required this.onOpen,
  });

  final NodeWithChildCount entry;
  final int number;
  final _StepState state;
  final Widget handle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final node = entry.node;

    final marker = switch (state) {
      _StepState.finished => IconButton(
        tooltip: l10n.markNotDone,
        icon: Icon(Icons.check_circle, color: scheme.primary),
        onPressed: () => _setDone(ref, node, false),
      ),
      _ => SizedBox(
        width: 48,
        child: Center(
          child: CircleAvatar(
            radius: 14,
            backgroundColor: state == _StepState.next
                ? scheme.primary
                : scheme.surfaceContainerHighest,
            foregroundColor: state == _StepState.next
                ? scheme.onPrimary
                : scheme.onSurfaceVariant,
            child: Text('$number', style: theme.textTheme.labelLarge),
          ),
        ),
      ),
    };

    final tile = ListTile(
      contentPadding: const EdgeInsets.only(right: 0),
      leading: marker,
      title: Text(
        l10n.titleOrUntitled(node.title),
        style: _finishedStyle(
          state == _StepState.finished,
          state == _StepState.next ? theme.textTheme.titleMedium : null,
          theme,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (entry.isShortcut) const ShortcutMarker(),
          if (state == _StepState.next)
            FilledButton.tonalIcon(
              icon: const Icon(Icons.check),
              label: Text(l10n.actionDone),
              onPressed: () => _setDone(ref, node, true),
            ),
          if (entry.childCount > 0) const Icon(Icons.chevron_right),
          handle,
        ],
      ),
      onTap: onOpen,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: switch (state) {
        _StepState.next => Material(
          color: scheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: tile,
        ),
        _StepState.later => Opacity(opacity: 0.5, child: tile),
        _StepState.finished => tile,
      },
    );
  }
}

/// A child of a one-at-a-time set: its cadence and last completion.
class _CadenceRow extends ConsumerWidget {
  const _CadenceRow({
    super.key,
    required this.entry,
    required this.exclusive,
    required this.handle,
    required this.onOpen,
  });

  final NodeWithChildCount entry;
  final ExclusiveStatus exclusive;
  final Widget handle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final material = MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final node = entry.node;
    final rule = node.rrule == null
        ? l10n.cadenceParent
        : l10n.repeatSummary(node.rrule!, locale);
    final last = exclusive.lastDone[node.id];
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: 24,
          child: switch (nodeIcon(node)) {
            final icon? => Icon(icon),
            null => null,
          },
        ),
      ),
      title: Text(l10n.titleOrUntitled(node.title)),
      subtitle: Text(
        '$rule · ${last == null ? l10n.neverDone : l10n.lastDoneOn(material.formatMediumDate(last))}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (entry.childCount > 0) const Icon(Icons.chevron_right),
          handle,
        ],
      ),
      onTap: onOpen,
    );
  }
}

/// The current turn of a one-at-a-time set (D36): what's up next, what was
/// already done for this occurrence, or that nothing is due.
class _ExclusiveCard extends ConsumerWidget {
  const _ExclusiveCard({required this.status});

  final ExclusiveStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    Future<void> act(Future<void> Function(NodeRepository repo) f) async =>
        f(await ref.read(nodeRepositoryProvider.future));

    final (
      IconData icon,
      String title,
      String? detail,
      Widget? action,
    ) = switch (status.state) {
      ExclusiveDue(:final childId, :final overdueDays, :final periodStart) => (
        Icons.arrow_forward,
        l10n.exclusiveNext(
          l10n.titleOrUntitled(status.child(childId)?.title ?? ''),
        ),
        overdueDays == null ? l10n.neverDone : l10n.overdueDays(overdueDays),
        FilledButton.tonal(
          onPressed: () =>
              act((r) => r.completeOccurrence(childId, periodStart)),
          child: Text(l10n.markDone),
        ),
      ),
      ExclusiveDone(:final childId, :final periodStart) => (
        Icons.check_circle_outline,
        l10n.exclusiveDone(
          l10n.titleOrUntitled(status.child(childId)?.title ?? ''),
        ),
        null,
        TextButton(
          onPressed: () =>
              act((r) => r.uncompleteOccurrence(childId, periodStart)),
          child: Text(l10n.undo),
        ),
      ),
      ExclusiveNothingDue() => (
        Icons.hourglass_empty,
        l10n.exclusiveNothing,
        null,
        null,
      ),
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: theme.colorScheme.secondaryContainer,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: detail == null ? null : Text(detail),
        trailing: action,
      ),
    );
  }
}

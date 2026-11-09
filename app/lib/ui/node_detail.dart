import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/node_repository.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'autosave_field.dart';
import 'done_button.dart';
import 'labels.dart';
import 'node_add_ons.dart';
import 'notes_column.dart';
import 'removal.dart';
import 'tree_pane.dart';
import 'tree_providers.dart';

/// Everything about one node: breadcrumbs, title, type, status, note and its
/// children (DESIGN.md §6.1). Child views (panels, checklist, steps) come in
/// a later slice; for now children are a simple list.
class NodeDetail extends ConsumerWidget {
  const NodeDetail({
    super.key,
    required this.nodeId,
    required this.onOpen,
    required this.onLeave,
  });

  final String nodeId;
  final OpenNode onOpen;

  /// Called after the node is archived or trashed from its page, with its
  /// parent, so the page can move away.
  final void Function(String? parentId) onLeave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return switch (ref.watch(nodeProvider(nodeId))) {
      AsyncData(value: final Node node) => _Detail(
        // Fresh text fields per node, so edits never leak across nodes.
        key: ValueKey(node.id),
        node: node,
        onOpen: onOpen,
        onLeave: onLeave,
      ),
      AsyncData() => Center(child: Text(l10n.itemNotFound)),
      AsyncError(:final error) => Center(child: Text('$error')),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _Detail extends ConsumerStatefulWidget {
  const _Detail({
    super.key,
    required this.node,
    required this.onOpen,
    required this.onLeave,
  });

  final Node node;
  final OpenNode onOpen;
  final void Function(String? parentId) onLeave;

  @override
  ConsumerState<_Detail> createState() => _DetailState();
}

class _DetailState extends ConsumerState<_Detail> {
  /// The description is optional. Its editor opens from "+ Description" or by
  /// clicking the text, and closes with its ✕ or Esc; while closed, a
  /// non-empty description shows as read-only text.
  bool _editingDescription = false;

  /// From this width the notes column sits beside the item; narrower, notes
  /// are a collapsed section at the bottom.
  static const _sideColumnWidth = 900.0;

  Future<NodeRepository> _repo(WidgetRef ref) =>
      ref.read(nodeRepositoryProvider.future);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final side = constraints.maxWidth >= _sideColumnWidth;
      final node = widget.node;
      final main = _main(context, sideColumn: side);
      if (node.type == NodeType.note ||
          !side ||
          !ref.watch(notesColumnOpenProvider)) {
        return main;
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: main),
          const VerticalDivider(width: 1),
          SizedBox(
            width: 300,
            child: NotesColumn(parentId: node.id, onOpen: widget.onOpen),
          ),
        ],
      );
    },
  );

  Widget _main(BuildContext context, {required bool sideColumn}) {
    final node = widget.node;
    final onOpen = widget.onOpen;
    final isNote = node.type == NodeType.note;
    final descriptionShown = _editingDescription || node.bodyMd.isNotEmpty;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        if (node.lifecycle != Lifecycle.live) RemovedBanner(node: node),
        Row(
          children: [
            Expanded(
              child: _Breadcrumbs(nodeId: node.id, onOpen: onOpen),
            ),
            if (!isNote && sideColumn) NotesToggle(parentId: node.id),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AutosaveField(
                value: node.title,
                autofocus: node.title.isEmpty,
                style: theme.textTheme.headlineSmall?.copyWith(
                  decoration: isFinished(node.status) && !isNote
                      ? TextDecoration.lineThrough
                      : null,
                ),
                decoration: InputDecoration(
                  hintText: l10n.titleHint,
                  border: InputBorder.none,
                ),
                onSave: (title) async =>
                    (await _repo(ref)).rename(node.id, title),
              ),
            ),
            if (!isNote) ...[
              StatusMenuButton(node: node),
              const SizedBox(width: 24),
              DoneButton(node: node),
            ],
            NodeMenu(node: node, onLeave: widget.onLeave),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            DropdownMenu<NodeType>(
              key: ValueKey(node.type),
              label: Text(l10n.fieldType),
              initialSelection: node.type,
              leadingIcon: Icon(nodeTypeIcon(node.type)),
              dropdownMenuEntries: [
                for (final t in NodeType.values)
                  DropdownMenuEntry(
                    value: t,
                    label: l10n.nodeType(t),
                    leadingIcon: Icon(nodeTypeIcon(t)),
                  ),
              ],
              onSelected: (t) async {
                if (t != null && t != node.type) {
                  await (await _repo(ref)).setType(node.id, t);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isNote)
          // A note is its text: always shown, nothing else to add.
          AutosaveField(
            value: node.bodyMd,
            maxLines: null,
            minLines: 10,
            decoration: InputDecoration(
              hintText: l10n.noteBodyHint,
              border: const OutlineInputBorder(),
            ),
            onSave: (body) async => (await _repo(ref)).setBody(node.id, body),
          )
        else ...[
          NodeAddOns(
            node: node,
            descriptionShown: descriptionShown,
            onAddDescription: () => setState(() => _editingDescription = true),
          ),
          if (_editingDescription) ...[
            const SizedBox(height: 16),
            CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.escape): () =>
                    setState(() => _editingDescription = false),
              },
              child: Stack(
                children: [
                  AutosaveField(
                    value: node.bodyMd,
                    maxLines: null,
                    minLines: 4,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: l10n.descriptionHint,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.fromLTRB(12, 16, 48, 16),
                    ),
                    onSave: (body) async =>
                        (await _repo(ref)).setBody(node.id, body),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      tooltip: l10n.closeDescription,
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          setState(() => _editingDescription = false),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (node.bodyMd.isNotEmpty) ...[
            const SizedBox(height: 16),
            Tooltip(
              message: l10n.editDescription,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () => setState(() => _editingDescription = true),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(node.bodyMd, style: theme.textTheme.bodyLarge),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text(l10n.childrenHeading, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          _Children(parentId: node.id, onOpen: onOpen),
          if (!sideColumn) ...[
            const SizedBox(height: 16),
            NotesSection(parentId: node.id, onOpen: onOpen),
          ],
        ],
      ],
    );
  }
}

class _Breadcrumbs extends ConsumerWidget {
  const _Breadcrumbs({required this.nodeId, required this.onOpen});

  final String nodeId;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ancestors = ref.watch(ancestorsProvider(nodeId)).value ?? const [];
    if (ancestors.isEmpty) return const SizedBox(height: 24);

    final theme = Theme.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final a in ancestors) ...[
          InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () => onOpen(a.id),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                l10n.titleOrUntitled(a.title),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ],
    );
  }
}

class _Children extends ConsumerStatefulWidget {
  const _Children({required this.parentId, required this.onOpen});

  final String parentId;
  final OpenNode onOpen;

  @override
  ConsumerState<_Children> createState() => _ChildrenState();
}

class _ChildrenState extends ConsumerState<_Children> {
  final _addController = TextEditingController();
  final _addFocus = FocusNode();

  @override
  void dispose() {
    _addController.dispose();
    _addFocus.dispose();
    super.dispose();
  }

  Future<void> _add(String title) async {
    if (title.trim().isEmpty) return;
    _addController.clear();
    _addFocus.requestFocus();
    final repo = await ref.read(nodeRepositoryProvider.future);
    await repo.create(title: title.trim(), parentId: widget.parentId);
    // Show the new child in the tree too.
    ref.read(expandedNodesProvider.notifier).expandAll([widget.parentId]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final children =
        ref.watch(childrenProvider(widget.parentId)).value ?? const [];
    final exclusive = ref.watch(exclusiveProvider(widget.parentId)).value;
    final material = MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();

    /// In a one-at-a-time set, a row shows its cadence and last completion
    /// instead of a checkbox: completing happens per occurrence, on the card.
    String? cadence(Node node) {
      if (exclusive == null) return null;
      final rule = node.rrule == null
          ? l10n.cadenceParent
          : l10n.repeatSummary(node.rrule!, locale);
      final last = exclusive.lastDone[node.id];
      return '$rule · ${last == null ? l10n.neverDone : l10n.lastDoneOn(material.formatMediumDate(last))}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (exclusive != null) _ExclusiveCard(status: exclusive),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          onReorderItem: (from, to) async {
            if (to == from) return;
            final repo = await ref.read(nodeRepositoryProvider.future);
            await repo.move(
              children[from].node.id,
              newParentId: widget.parentId,
              index: to,
            );
          },
          children: [
            for (final (i, entry) in children.indexed)
              ListTile(
                key: ValueKey(entry.node.id),
                contentPadding: EdgeInsets.zero,
                dense: true,
                subtitle: switch (cadence(entry.node)) {
                  final text? => Text(text),
                  null => null,
                },
                leading: exclusive != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: SizedBox(
                          width: 24,
                          child: switch (nodeIcon(entry.node)) {
                            final icon? => Icon(icon),
                            null => null,
                          },
                        ),
                      )
                    : Checkbox(
                        value: entry.node.status == NodeStatus.done,
                        onChanged: (checked) async {
                          final repo = await ref.read(
                            nodeRepositoryProvider.future,
                          );
                          await repo.setStatus(
                            entry.node.id,
                            checked == true ? NodeStatus.done : NodeStatus.open,
                          );
                        },
                      ),
                title: Text(
                  l10n.titleOrUntitled(entry.node.title),
                  style: TextStyle(
                    decoration: isFinished(entry.node.status)
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (entry.childCount > 0)
                      Text(
                        '${entry.childCount}',
                        style: theme.textTheme.labelSmall,
                      ),
                    const Icon(Icons.chevron_right),
                    ReorderableDragStartListener(
                      index: i,
                      child: Tooltip(
                        message: l10n.reorderHandle,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.drag_indicator),
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () => widget.onOpen(entry.node.id),
              ),
          ],
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

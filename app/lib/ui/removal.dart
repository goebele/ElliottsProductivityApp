import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/ics.dart';
import '../domain/node_repository.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'calendar_page.dart';
import 'time_ui.dart';
import 'today_page.dart';
import 'labels.dart';
import 'markup.dart' show saveBytesAs;
import 'node_picker.dart';
import 'tree_providers.dart';

/// Archive and Trash (DESIGN.md §6.11): the confirmations, the node page's
/// ⋮ menu and banner, and the Archive and Trash lists.

enum Removal { archive, trash, deleteForever }

/// Asks before archiving, trashing or deleting [node] and the [count]
/// items inside it. Every removal is confirmed.
Future<bool> confirmRemoval(
  BuildContext context,
  Removal kind,
  Node node,
  int count, {
  ExternalUses uses = const ExternalUses(),
}) async {
  final l10n = AppLocalizations.of(context);
  final title = '“${l10n.titleOrUntitled(node.title)}”';
  final (heading, body, action) = switch (kind) {
    Removal.archive => (
      l10n.archiveConfirmTitle(title),
      l10n.archiveConfirmBody(count),
      l10n.actionArchive,
    ),
    Removal.trash => (
      l10n.trashConfirmTitle(title),
      l10n.trashConfirmBody(count),
      l10n.actionMoveToTrash,
    ),
    Removal.deleteForever => (
      l10n.deleteForeverTitle(title),
      l10n.deleteForeverBody(count),
      l10n.actionDeleteForever,
    ),
  };
  // What outside the group will notice (§6.11).
  final notes = [
    if (uses.linkingItems > 0) l10n.usedByElsewhere(uses.linkingItems),
    if (uses.shortcuts > 0) l10n.shortcutsElsewhere(uses.shortcuts),
  ];
  return _confirm(
    context,
    heading,
    notes.isEmpty ? body : '$body\n\n${notes.join('\n')}',
    action,
    destructive: kind != Removal.archive,
  );
}

Future<bool> _confirm(
  BuildContext context,
  String heading,
  String body,
  String action, {
  required bool destructive,
}) async {
  final scheme = Theme.of(context).colorScheme;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(heading),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: scheme.error,
                  foregroundColor: scheme.onError,
                )
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(action),
        ),
      ],
    ),
  );
  return ok ?? false;
}

/// Confirms, then archives or trashes [node] and offers Undo. Returns true
/// if it went.
Future<bool> removeNode(
  BuildContext context,
  WidgetRef ref,
  Node node,
  Removal kind,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.maybeOf(context);
  final repo = await ref.read(nodeRepositoryProvider.future);
  final wasRemoved = node.lifecycle != Lifecycle.live;
  final count = wasRemoved
      ? (await repo.removedGroups(node.lifecycle))
                .where((g) => g.root.id == node.id)
                .firstOrNull
                ?.others ??
            0
      : await repo.subtreeSize(node.id);
  final uses = await repo.externalUses(node.id);
  if (!context.mounted ||
      !await confirmRemoval(context, kind, node, count, uses: uses)) {
    return false;
  }
  final title = l10n.titleOrUntitled(node.title);
  switch (kind) {
    case Removal.archive:
      await repo.archive(node.id);
    case Removal.trash:
      await repo.trash(node.id);
    case Removal.deleteForever:
      await repo.purge(node.id);
      return true; // nothing to undo
  }
  messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          kind == Removal.archive
              ? l10n.archivedItem(title)
              : l10n.trashedItem(title),
        ),
        // Undo puts it back as it was: live, or archived if it came from
        // the Archive.
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () =>
              wasRemoved ? repo.archive(node.id) : repo.restore(node.id),
        ),
      ),
    );
  return true;
}

/// Restores the group [rootId] belongs to and says where it went.
Future<void> restoreGroup(
  BuildContext context,
  WidgetRef ref,
  Node root,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.maybeOf(context);
  final repo = await ref.read(nodeRepositoryProvider.future);
  final movedToTop = await repo.restore(root.id);
  final title = l10n.titleOrUntitled(root.title);
  messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          movedToTop ? l10n.restoredToTop(title) : l10n.restoredItem(title),
        ),
      ),
    );
}

/// Picks a place and adds a shortcut to [node] there, with Undo.
Future<void> addShortcut(BuildContext context, WidgetRef ref, Node node) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.maybeOf(context);
  final picked = await pickShortcutParent(context, node);
  if (picked == null) return;
  final repo = await ref.read(nodeRepositoryProvider.future);
  final parentId = picked.parentId;
  final String placementId;
  try {
    placementId = await repo.addPlacement(node.id, parentId);
  } on Exception {
    messenger?.showSnackBar(SnackBar(content: Text(l10n.cantMoveThere)));
    return;
  }
  if (parentId != null) {
    ref.read(expandedNodesProvider.notifier).expandAll([parentId]);
  }
  final parent = parentId == null ? null : await repo.get(parentId);
  messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          l10n.alsoShownIn(
            parent == null ? l10n.topLevel : l10n.titleOrUntitled(parent.title),
          ),
        ),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => repo.removePlacement(placementId),
        ),
      ),
    );
}

/// The ⋮ menu at the end of a node's title row. [onLeave] is called after
/// the node is archived or trashed, with its parent, so the page can move
/// away from it.
class NodeMenu extends ConsumerWidget {
  const NodeMenu({super.key, required this.node, required this.onLeave});

  final Node node;
  final void Function(String? parentId) onLeave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final live = node.lifecycle == Lifecycle.live;
    final isRoot = node.lifecycleRootId == node.id;

    Future<void> remove(Removal kind) async {
      if (await removeNode(context, ref, node, kind) && live) {
        onLeave(node.parentId);
      }
    }

    final shortcuts = node.type.isItem && live
        ? ref.watch(placementsOfProvider(node.id)).value ?? const []
        : const <PlacementInfo>[];

    final items = <Widget>[
      if (live && node.type.isItem) ...[
        MenuItemButton(
          leadingIcon: const Icon(Icons.north_east),
          onPressed: () => addShortcut(context, ref, node),
          child: Text(l10n.alsoShowIn),
        ),
        for (final s in shortcuts)
          MenuItemButton(
            leadingIcon: const Icon(Icons.link_off),
            onPressed: () async =>
                (await ref.read(nodeRepositoryProvider.future))
                    .removePlacement(s.id),
            child: Text(
              l10n.removeShortcutFrom(
                s.parentId == null
                    ? l10n.topLevel
                    : l10n.titleOrUntitled(s.parentTitle ?? ''),
              ),
            ),
          ),
        TodayMenuItem(node: node),
        MenuItemButton(
          leadingIcon: const Icon(Icons.percent),
          onPressed: () => editProgress(context, ref, node),
          child: Text(l10n.progressSet),
        ),
        if (node.progressOverride != null)
          MenuItemButton(
            leadingIcon: const Icon(Icons.checklist),
            onPressed: () async =>
                (await ref.read(nodeRepositoryProvider.future))
                    .setProgressOverride(node.id, null),
            child: Text(l10n.progressUseItems),
          ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.calendar_month_outlined),
          onPressed: () => showInCalendar(context, ref, node),
          child: Text(l10n.showInCalendar),
        ),
        if (node.startAt != null || node.dueDate != null || node.rrule != null)
          MenuItemButton(
            leadingIcon: const Icon(Icons.ios_share),
            onPressed: () => saveBytesAs(
              context,
              '${l10n.titleOrUntitled(node.title)}.ics',
              utf8.encode(buildIcs([node])),
              'text/calendar',
            ),
            child: Text(l10n.icsExportItem),
          ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.zoom_in),
          onPressed: () => ref.read(treeZoomProvider.notifier).zoom(node.id),
          child: Text(l10n.zoomTreeHere),
        ),
        const Divider(height: 1),
      ],
      if (live) ...[
        MenuItemButton(
          leadingIcon: const Icon(Icons.archive_outlined),
          onPressed: () => remove(Removal.archive),
          child: Text(l10n.actionArchive),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.delete_outline),
          onPressed: () => remove(Removal.trash),
          child: Text(l10n.actionMoveToTrash),
        ),
      ] else if (isRoot) ...[
        MenuItemButton(
          leadingIcon: const Icon(Icons.restore),
          onPressed: () => restoreGroup(context, ref, node),
          child: Text(l10n.actionRestore),
        ),
        if (node.lifecycle == Lifecycle.archived)
          MenuItemButton(
            leadingIcon: const Icon(Icons.delete_outline),
            onPressed: () => remove(Removal.trash),
            child: Text(l10n.actionMoveToTrash),
          )
        else
          MenuItemButton(
            leadingIcon: const Icon(Icons.delete_forever_outlined),
            onPressed: () => remove(Removal.deleteForever),
            child: Text(l10n.actionDeleteForever),
          ),
      ],
    ];
    if (items.isEmpty) return const SizedBox.shrink();

    return MenuAnchor(
      menuChildren: items,
      builder: (context, controller, _) => IconButton(
        tooltip: l10n.moreActions,
        icon: const Icon(Icons.more_vert),
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}

/// Shown at the top of an archived or trashed node's page.
class RemovedBanner extends ConsumerWidget {
  const RemovedBanner({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rootId = node.lifecycleRootId ?? node.id;
    final root = rootId == node.id
        ? node
        : ref.watch(nodeProvider(rootId)).value;
    final archived = node.lifecycle == Lifecycle.archived;
    final rootTitle = l10n.titleOrUntitled(root?.title ?? '');
    final text = rootId == node.id
        ? (archived ? l10n.inArchive : l10n.inTrash)
        : (archived
              ? l10n.inArchiveWith(rootTitle)
              : l10n.inTrashWith(rootTitle));

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(archived ? Icons.archive_outlined : Icons.delete_outline),
        title: Text(text),
        trailing: root == null
            ? null
            : FilledButton.tonal(
                onPressed: () => restoreGroup(context, ref, root),
                child: Text(l10n.actionRestore),
              ),
      ),
    );
  }
}

/// The Archive or Trash: one row per group, newest first.
class RemovedList extends ConsumerWidget {
  const RemovedList({super.key, required this.which, required this.onOpen});

  final Lifecycle which;
  final void Function(String id) onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final material = MaterialLocalizations.of(context);
    final trash = which == Lifecycle.trashed;
    final groups = ref.watch(removedGroupsProvider(which)).value ?? const [];

    String subtitle(RemovedGroup g) {
      final at = g.root.lifecycleAt?.toLocal();
      return [
        if (g.others > 0) l10n.groupOthers(g.others),
        if (g.parentTitle != null)
          l10n.wasIn(l10n.titleOrUntitled(g.parentTitle!)),
        if (at != null)
          trash
              ? '${l10n.trashedOn(material.formatMediumDate(at))} · '
                    '${l10n.daysLeft(_daysLeft(at))}'
              : l10n.archivedOn(material.formatMediumDate(at)),
      ].join(' · ');
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        Row(
          children: [
            Icon(trash ? Icons.delete_outline : Icons.archive_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                trash ? l10n.trashView : l10n.archiveView,
                style: theme.textTheme.headlineSmall,
              ),
            ),
            if (trash && groups.isNotEmpty)
              TextButton.icon(
                icon: const Icon(Icons.delete_forever_outlined),
                label: Text(l10n.actionEmptyTrash),
                onPressed: () async {
                  final ok = await _confirm(
                    context,
                    l10n.emptyTrashTitle,
                    l10n.emptyTrashBody,
                    l10n.actionEmptyTrash,
                    destructive: true,
                  );
                  if (!ok) return;
                  await (await ref.read(nodeRepositoryProvider.future))
                      .emptyTrash();
                },
              ),
          ],
        ),
        if (trash) ...[
          const SizedBox(height: 4),
          Text(l10n.trashHint, style: theme.textTheme.bodySmall),
        ],
        const SizedBox(height: 16),
        if (groups.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(trash ? l10n.trashEmpty : l10n.archiveEmpty),
            ),
          ),
        for (final g in groups)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(nodeIcon(g.root) ?? nodeTypeIcon(g.root.type)),
            title: Text(l10n.titleOrUntitled(g.root.title)),
            subtitle: Text(subtitle(g)),
            onTap: () => onOpen(g.root.id),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => restoreGroup(context, ref, g.root),
                  child: Text(l10n.actionRestore),
                ),
                IconButton(
                  tooltip: trash
                      ? l10n.actionDeleteForever
                      : l10n.actionMoveToTrash,
                  icon: Icon(
                    trash
                        ? Icons.delete_forever_outlined
                        : Icons.delete_outline,
                  ),
                  onPressed: () => removeNode(
                    context,
                    ref,
                    g.root,
                    trash ? Removal.deleteForever : Removal.trash,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

int _daysLeft(DateTime trashedAt) {
  final purgeOn = trashedAt.add(const Duration(days: NodeRepository.trashDays));
  final left = purgeOn.difference(DateTime.now()).inHours / 24;
  return left <= 0 ? 0 : left.ceil();
}

/// The two entries under the tree: Archive and Trash, with group counts.
class RemovedEntries extends ConsumerWidget {
  const RemovedEntries({super.key, required this.onOpen});

  final void Function(Lifecycle which) onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final counts = ref.watch(removedCountsProvider).value ?? const {};
    Widget entry(Lifecycle which, IconData icon, String label) {
      final n = counts[which] ?? 0;
      return ListTile(
        dense: true,
        leading: Icon(icon, size: 20),
        title: Text(label),
        trailing: n == 0 ? null : Text('$n'),
        onTap: () => onOpen(which),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        entry(Lifecycle.archived, Icons.archive_outlined, l10n.archiveView),
        entry(Lifecycle.trashed, Icons.delete_outline, l10n.trashView),
      ],
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/node_repository.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import '../data/database.dart';
import 'done_button.dart';
import 'removal.dart';
import 'labels.dart';
import 'search_pane.dart';
import 'tree_providers.dart';

typedef OpenNode = void Function(String id);

/// The whole tree, expandable to any depth (DESIGN.md §6.1). Rows can be
/// dragged above, below or into other rows.
class TreePane extends ConsumerWidget {
  const TreePane({
    super.key,
    required this.onOpen,
    required this.onOpenRemoved,
    required this.onOpenPage,
    this.selectedId,
  });

  final OpenNode onOpen;

  /// Opens the Values or Tags page.
  final void Function(SidePage page) onOpenPage;

  /// Opens the Archive or Trash list.
  final void Function(Lifecycle which) onOpenRemoved;

  /// Highlighted row (wide layout only).
  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final zoom = ref.watch(treeZoomProvider);
    final topLevel = ref.watch(childrenProvider(zoom));
    final searching = ref.watch(searchingProvider);
    final rootPlace = TreePlace(
      parentId: zoom,
      path: [?zoom],
      siblings: [for (final s in topLevel.value ?? const []) s.key],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: SearchBox(),
        ),
        if (!searching)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: FilledButton.tonalIcon(
              icon: const Icon(Icons.add),
              label: Text(l10n.newItem),
              onPressed: () async {
                final repo = await ref.read(nodeRepositoryProvider.future);
                onOpen(await repo.create(title: '', parentId: zoom));
              },
            ),
          ),
        if (!searching && zoom != null)
          _ZoomHeader(zoomId: zoom, onOpen: onOpen),
        Expanded(
          child: searching
              ? SearchResults(onOpen: onOpen, selectedId: selectedId)
              : switch (topLevel) {
                  AsyncData(value: final nodes) when nodes.isEmpty => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(l10n.treeEmpty, textAlign: TextAlign.center),
                    ),
                  ),
                  AsyncData(value: final nodes) => SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final n in nodes)
                          _TreeBranch(
                            entry: n,
                            depth: 0,
                            onOpen: onOpen,
                            selectedId: selectedId,
                            place: rootPlace,
                          ),
                        // Drop below everything: last at the top level.
                        _EndDropTarget(place: rootPlace),
                      ],
                    ),
                  ),
                  AsyncError(:final error) => Center(child: Text('$error')),
                  _ => const Center(child: CircularProgressIndicator()),
                },
        ),
        const Divider(height: 1),
        ListTile(
          dense: true,
          leading: const Icon(Icons.wb_sunny_outlined, size: 20),
          title: Text(l10n.todayView),
          onTap: () => onOpenPage(SidePage.todayPage),
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.calendar_month_outlined, size: 20),
          title: Text(l10n.calendarView),
          onTap: () => onOpenPage(SidePage.calendarPage),
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.insights_outlined, size: 20),
          title: Text(l10n.reviewView),
          onTap: () => onOpenPage(SidePage.reviewPage),
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.favorite_border, size: 20),
          title: Text(l10n.valuesView),
          onTap: () => onOpenPage(SidePage.valuesPage),
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.sell_outlined, size: 20),
          title: Text(l10n.tagsView),
          onTap: () => onOpenPage(SidePage.tagsPage),
        ),
        RemovedEntries(onOpen: onOpenRemoved),
      ],
    );
  }
}

/// A row's position in the tree, which drag and drop needs.
class TreePlace {
  const TreePlace({
    required this.parentId,
    required this.path,
    required this.siblings,
  });

  final String? parentId;

  /// Ancestors of the row, top-level first.
  final List<String> path;

  /// Row keys ([NodeWithChildCount.key]) of the row and its siblings, in
  /// order.
  final List<String> siblings;
}

/// What is being dragged: a node (or one of its shortcuts) and where it came
/// from (for Undo).
class TreeDrag {
  const TreeDrag({
    required this.id,
    required this.title,
    required this.place,
    this.placementId,
  });
  final String id;
  final String title;
  final TreePlace place;

  /// Set when a shortcut row is dragged: the shortcut moves, not the node.
  final String? placementId;
  String get key => placementId ?? id;
}

/// Where a drop on a row lands: just above it, inside it (as its last
/// item), or just below it.
enum DropZone { before, inside, after }

/// Whether [drag] may be dropped on the row [id] at [place]: never on itself
/// or anywhere inside its own subtree.
bool canDrop(TreeDrag drag, String id, TreePlace place) =>
    drag.id != id && !place.path.contains(drag.id);

/// Moves [drag] relative to the row for node [targetId] (row key
/// [targetKey]) at [targetPlace] (null = the end of that list), then offers
/// Undo. A dragged shortcut moves only the shortcut.
Future<void> moveDropped(
  BuildContext context,
  WidgetRef ref,
  TreeDrag drag, {
  required String? targetId,
  String? targetKey,
  required TreePlace targetPlace,
  required DropZone zone,
}) async {
  targetKey ??= targetId;
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.maybeOf(context);
  final expanded = ref.read(expandedNodesProvider.notifier);
  final repo = await ref.read(nodeRepositoryProvider.future);

  final String? newParent;
  final int? index;
  if (zone == DropZone.inside) {
    newParent = targetId;
    index = null;
  } else {
    newParent = targetPlace.parentId;
    final others = [
      for (final key in targetPlace.siblings)
        if (key != drag.key) key,
    ];
    final at = targetKey == null ? others.length : others.indexOf(targetKey);
    index = zone == DropZone.after && targetKey != null ? at + 1 : at;
  }

  final oldParent = drag.place.parentId;
  final oldIndex = drag.place.siblings.indexOf(drag.key);
  if (newParent == oldParent && (index ?? -1) == oldIndex) return;

  Future<void> moveTo(String? parent, int? at) => drag.placementId == null
      ? repo.move(drag.id, newParentId: parent, index: at)
      : repo.movePlacement(drag.placementId!, newParentId: parent, index: at);
  try {
    await moveTo(newParent, index);
  } on MoveWouldCreateCycleException {
    messenger?.showSnackBar(SnackBar(content: Text(l10n.cantMoveThere)));
    return;
  } on PlacementNotAllowedException {
    messenger?.showSnackBar(SnackBar(content: Text(l10n.cantMoveThere)));
    return;
  }
  if (newParent != null) expanded.expandAll([newParent]);
  messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(l10n.movedItem(l10n.titleOrUntitled(drag.title))),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => moveTo(oldParent, oldIndex),
        ),
      ),
    );
}

/// Touch devices start a drag with a long press; with a mouse, dragging
/// starts as soon as the pointer moves.
bool get touchFirst =>
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

/// One row plus, when expanded, its children.
class _TreeBranch extends ConsumerWidget {
  const _TreeBranch({
    required this.entry,
    required this.depth,
    required this.onOpen,
    required this.selectedId,
    required this.place,
  });

  final NodeWithChildCount entry;
  final int depth;
  final OpenNode onOpen;
  final String? selectedId;
  final TreePlace place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final node = entry.node;
    final expanded = ref.watch(expandedNodesProvider).contains(node.id);
    final hasChildren = entry.childCount > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TreeRow(
          entry: entry,
          depth: depth,
          expanded: expanded && hasChildren,
          selected: node.id == selectedId,
          onTap: () {
            ref
                .read(openedViaProvider.notifier)
                .opening(
                  node.id,
                  viaParent: entry.isShortcut ? place.parentId : null,
                );
            onOpen(node.id);
          },
          onToggle: hasChildren
              ? () => ref.read(expandedNodesProvider.notifier).toggle(node.id)
              : null,
          place: place,
        ),
        if (expanded && hasChildren)
          switch (ref.watch(childrenProvider(node.id))) {
            AsyncData(value: final children) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final child in children)
                  _TreeBranch(
                    entry: child,
                    depth: depth + 1,
                    onOpen: onOpen,
                    selectedId: selectedId,
                    place: TreePlace(
                      parentId: node.id,
                      path: [...place.path, node.id],
                      siblings: [for (final c in children) c.key],
                    ),
                  ),
              ],
            ),
            _ => const SizedBox.shrink(),
          },
      ],
    );
  }
}

class _TreeRow extends ConsumerStatefulWidget {
  const _TreeRow({
    required this.entry,
    required this.depth,
    required this.expanded,
    required this.selected,
    required this.onTap,
    required this.onToggle,
    required this.place,
  });

  final NodeWithChildCount entry;
  final int depth;
  final bool expanded;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onToggle;
  final TreePlace place;

  @override
  ConsumerState<_TreeRow> createState() => _TreeRowState();
}

class _TreeRowState extends ConsumerState<_TreeRow> {
  /// Right-click on an item opens its status menu at the pointer (notes have
  /// no status); with a mouse, so does long-press. On touch, long-press
  /// drags instead.
  final _menu = MenuController();

  /// Where a drag hovering over this row would land, if one is.
  DropZone? _zone;

  DropZone _zoneAt(Offset global) {
    final box = context.findRenderObject()! as RenderBox;
    final y = box.globalToLocal(global).dy / box.size.height;
    // Notes don't hold items, so there is no "inside" band.
    if (!widget.entry.node.type.isItem) {
      return y < 0.5 ? DropZone.before : DropZone.after;
    }
    if (y < 0.25) return DropZone.before;
    if (y > 0.75) return DropZone.after;
    return DropZone.inside;
  }

  void _setZone(DropZone? zone) {
    if (zone != _zone) setState(() => _zone = zone);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final _TreeRow(:entry, :depth, :expanded, :selected, :onTap, :onToggle) =
        widget;
    final node = entry.node;
    final done = isFinished(node.status);
    final hasStatus = node.type.isItem;
    final indent = 4.0 + depth * 20;

    final content = Padding(
      padding: EdgeInsets.only(left: indent, right: 12),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: onToggle == null
                  ? null
                  : IconButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      tooltip: expanded ? l10n.collapse : l10n.expand,
                      icon: Icon(
                        expanded ? Icons.expand_more : Icons.chevron_right,
                      ),
                      onPressed: onToggle,
                    ),
            ),
            SizedBox(
              width: 18,
              child: switch (nodeIcon(node)) {
                final icon? => Icon(
                  icon,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                null => null,
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.titleOrUntitled(node.title),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decoration: done ? TextDecoration.lineThrough : null,
                  color: node.title.trim().isEmpty || done
                      ? theme.colorScheme.onSurfaceVariant
                      : null,
                ),
              ),
            ),
            if (entry.isShortcut) const ShortcutMarker(),
            if (entry.childCount > 0)
              Text(
                '${entry.childCount}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );

    final row = MenuAnchor(
      controller: _menu,
      menuChildren: [
        if (hasStatus) ...statusMenuItems(context, ref, node),
        if (entry.childCount > 0) ...[
          const Divider(height: 1),
          MenuItemButton(
            leadingIcon: const Icon(Icons.zoom_in),
            onPressed: () => ref.read(treeZoomProvider.notifier).zoom(node.id),
            child: Text(l10n.zoomIn),
          ),
        ],
        if (entry.isShortcut) ...[
          const Divider(height: 1),
          MenuItemButton(
            leadingIcon: const Icon(Icons.link_off),
            onPressed: () async =>
                (await ref.read(nodeRepositoryProvider.future))
                    .removePlacement(entry.placementId!),
            child: Text(l10n.removeShortcut),
          ),
        ],
      ],
      child: Material(
        color: _zone == DropZone.inside
            ? theme.colorScheme.primaryContainer
            : selected
            ? theme.colorScheme.secondaryContainer
            : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onSecondaryTapUp: hasStatus || entry.isShortcut
              ? (d) => _menu.open(position: d.localPosition)
              : null,
          onLongPress: hasStatus && !touchFirst ? () => _menu.open() : null,
          child: content,
        ),
      ),
    );

    final drag = TreeDrag(
      id: node.id,
      title: node.title,
      place: widget.place,
      placementId: entry.placementId,
    );
    final feedback = Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(l10n.titleOrUntitled(node.title)),
      ),
    );
    final dimmed = Opacity(opacity: 0.4, child: row);
    final draggable = touchFirst
        ? LongPressDraggable<TreeDrag>(
            data: drag,
            dragAnchorStrategy: pointerDragAnchorStrategy,
            feedback: feedback,
            childWhenDragging: dimmed,
            child: row,
          )
        : Draggable<TreeDrag>(
            data: drag,
            dragAnchorStrategy: pointerDragAnchorStrategy,
            feedback: feedback,
            childWhenDragging: dimmed,
            child: row,
          );

    return DragTarget<TreeDrag>(
      onWillAcceptWithDetails: (d) => canDrop(d.data, node.id, widget.place),
      onMove: (d) {
        if (canDrop(d.data, node.id, widget.place)) _setZone(_zoneAt(d.offset));
      },
      onLeave: (_) => _setZone(null),
      onAcceptWithDetails: (d) {
        final zone = _zoneAt(d.offset);
        _setZone(null);
        moveDropped(
          context,
          ref,
          d.data,
          targetId: node.id,
          targetKey: entry.key,
          targetPlace: widget.place,
          zone: zone,
        );
      },
      builder: (context, candidates, rejected) {
        final zone = _zone;
        // A line where the item would land, above or below this row. The
        // Stack is always there so rows keep their state while hovered.
        return Stack(
          children: [
            draggable,
            if (zone == DropZone.before || zone == DropZone.after)
              Positioned(
                left: indent + 32,
                right: 8,
                top: zone == DropZone.before ? 0 : null,
                bottom: zone == DropZone.after ? 0 : null,
                child: IgnorePointer(
                  child: Container(height: 2, color: theme.colorScheme.primary),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Space under the last top-level row: dropping there moves the item to the
/// end of the top level.
class _EndDropTarget extends ConsumerWidget {
  const _EndDropTarget({required this.place});

  final TreePlace place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return DragTarget<TreeDrag>(
      onAcceptWithDetails: (d) => moveDropped(
        context,
        ref,
        d.data,
        targetId: null,
        targetPlace: place,
        zone: DropZone.after,
      ),
      builder: (context, candidates, _) => Container(
        height: 48,
        alignment: Alignment.topCenter,
        child: candidates.isEmpty
            ? null
            : Container(
                margin: const EdgeInsets.fromLTRB(36, 0, 8, 0),
                height: 2,
                color: theme.colorScheme.primary,
              ),
      ),
    );
  }
}

/// The ↗ on a shortcut row: the node really lives elsewhere (§6.12).
class ShortcutMarker extends StatelessWidget {
  const ShortcutMarker({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: l10n.shortcutTooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(
          Icons.north_east,
          size: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Above a zoomed tree: the item it is zoomed into, a step out, and back to
/// the whole tree.
class _ZoomHeader extends ConsumerWidget {
  const _ZoomHeader({required this.zoomId, required this.onOpen});

  final String zoomId;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final node = ref.watch(nodeProvider(zoomId)).value;
    final zoom = ref.read(treeZoomProvider.notifier);
    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            IconButton(
              tooltip: l10n.zoomOut,
              icon: const Icon(Icons.arrow_upward),
              onPressed: () => zoom.zoom(node?.parentId),
            ),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () => onOpen(zoomId),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    l10n.titleOrUntitled(node?.title ?? ''),
                    style: theme.textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: l10n.zoomReset,
              icon: const Icon(Icons.close),
              onPressed: () => zoom.zoom(null),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../l10n/app_localizations.dart';
import 'labels.dart';
import 'markdown.dart';
import 'tags.dart';
import 'tree_pane.dart';
import 'tree_providers.dart';
import 'values.dart';

/// Peek (DESIGN.md §6.1.1): look at another item without leaving this one.
/// On Windows, hover for a card (pin it to keep it as a side panel); on
/// touch screens, long-press for a bottom sheet.

/// The item pinned as a side panel beside the detail pane (wide layout).
final pinnedPeekProvider = NotifierProvider<PinnedPeek, String?>(
  PinnedPeek.new,
);

class PinnedPeek extends Notifier<String?> {
  @override
  String? build() => null;

  void pin(String? id) => state = id;
}

bool get _touch => switch (defaultTargetPlatform) {
  TargetPlatform.android || TargetPlatform.iOS => true,
  _ => false,
};

/// Wraps something that names an item (a breadcrumb, an Items row, a "from"
/// tag) so it can be peeked at.
class PeekTarget extends StatefulWidget {
  const PeekTarget({
    super.key,
    required this.nodeId,
    required this.onOpen,
    required this.child,
    this.longPress = true,
  });

  final String nodeId;
  final OpenNode onOpen;
  final Widget child;

  /// On touch screens, long-press opens the peek. Off where long-press
  /// already means something (dragging).
  final bool longPress;

  static const hoverDelay = Duration(milliseconds: 700);

  @override
  State<PeekTarget> createState() => _PeekTargetState();
}

class _PeekTargetState extends State<PeekTarget> {
  final _portal = OverlayPortalController();
  Timer? _show;
  Timer? _hide;
  bool _overCard = false;

  @override
  void dispose() {
    _show?.cancel();
    _hide?.cancel();
    super.dispose();
  }

  void _enter() {
    _hide?.cancel();
    if (_portal.isShowing) return;
    _show?.cancel();
    _show = Timer(PeekTarget.hoverDelay, () {
      if (mounted) _portal.show();
    });
  }

  void _exit() {
    _show?.cancel();
    _hide?.cancel();
    _hide = Timer(const Duration(milliseconds: 250), () {
      if (mounted && !_overCard && _portal.isShowing) _portal.hide();
    });
  }

  void _close() {
    _show?.cancel();
    _hide?.cancel();
    if (_portal.isShowing) _portal.hide();
  }

  @override
  Widget build(BuildContext context) {
    if (_touch) {
      if (!widget.longPress) return widget.child;
      return GestureDetector(
        onLongPress: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (context, scroll) => PeekCard(
              nodeId: widget.nodeId,
              scrollController: scroll,
              onOpen: (id) {
                Navigator.pop(context);
                widget.onOpen(id);
              },
            ),
          ),
        ),
        child: widget.child,
      );
    }
    // The card is placed on the overlay from the target's position when it
    // opens. (Not a CompositedTransformFollower: tooltips inside a follower
    // can't work out where they are, and threw on hovering the pin.)
    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: (overlayContext) => Positioned.fill(
        child: CustomSingleChildLayout(
          delegate: _PeekLayout(_targetRect(overlayContext)),
          child: MouseRegion(
            onEnter: (_) {
              _overCard = true;
              _hide?.cancel();
            },
            onExit: (_) {
              _overCard = false;
              _exit();
            },
            child: TapRegion(
              onTapOutside: (_) => _close(),
              child: SizedBox(
                width: 360,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 420),
                    child: PeekCard(
                      nodeId: widget.nodeId,
                      onOpen: (id) {
                        _close();
                        widget.onOpen(id);
                      },
                      onPinned: _close,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      child: MouseRegion(
        onEnter: (_) => _enter(),
        onExit: (_) => _exit(),
        child: widget.child,
      ),
    );
  }

  /// Where the target is, in the overlay's coordinates.
  Rect _targetRect(BuildContext overlayContext) {
    final box = context.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(overlayContext).context.findRenderObject() as RenderBox?;
    if (box == null || overlay == null || !box.attached) return Rect.zero;
    return MatrixUtils.transformRect(
      box.getTransformTo(overlay),
      Offset.zero & box.size,
    );
  }
}

/// Puts the peek card just below its target, or above it when there is no
/// room below, kept inside the window.
class _PeekLayout extends SingleChildLayoutDelegate {
  const _PeekLayout(this.target);

  final Rect target;
  static const _gap = 4.0;
  static const _margin = 8.0;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.loose(constraints.biggest)
          .deflate(const EdgeInsets.all(_margin));

  @override
  Offset getPositionForChild(Size size, Size child) {
    final below = target.bottom + _gap;
    final y = below + child.height <= size.height - _margin
        ? below
        : (target.top - _gap - child.height).clamp(
            _margin,
            size.height - child.height - _margin,
          );
    final x = target.left.clamp(_margin, size.width - child.width - _margin);
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PeekLayout old) => old.target != target;
}

/// An item at a glance: type, status, values, tags, description, notes and
/// how many items it has. "Open" goes there; on Windows, "Pin" keeps it as a
/// side panel.
class PeekCard extends ConsumerWidget {
  const PeekCard({
    super.key,
    required this.nodeId,
    required this.onOpen,
    this.scrollController,
    this.onPinned,
    this.pinned = false,
  });

  final String nodeId;
  final OpenNode onOpen;
  final ScrollController? scrollController;
  final VoidCallback? onPinned;

  /// Shown as the side panel: Unpin instead of Pin.
  final bool pinned;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final node = ref.watch(nodeProvider(nodeId)).value;
    if (node == null) return const SizedBox(height: 80);
    final isNote = node.type == NodeType.note;
    final notes = isNote
        ? const <Node>[]
        : ref.watch(notesProvider(nodeId)).value ?? const [];
    final children = isNote
        ? const []
        : ref.watch(childrenProvider(nodeId)).value ?? const [];
    final values = isNote
        ? const []
        : ref.watch(effectiveValuesProvider(nodeId)).value ?? const [];
    final tags = ref.watch(nodeTagsProvider(nodeId)).value ?? const [];
    final ancestors = ref.watch(ancestorsProvider(nodeId)).value ?? const [];

    return ListView(
      controller: scrollController,
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      children: [
        if (ancestors.isNotEmpty)
          Text(
            ancestors.map((a) => l10n.titleOrUntitled(a.title)).join(' › '),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        Row(
          children: [
            Icon(nodeTypeIcon(node.type), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.titleOrUntitled(node.title),
                style: theme.textTheme.titleMedium,
              ),
            ),
            if (!_touch)
              IconButton(
                tooltip: pinned ? l10n.peekUnpin : l10n.peekPin,
                icon: Icon(pinned ? Icons.close : Icons.push_pin_outlined),
                onPressed: () {
                  ref
                      .read(pinnedPeekProvider.notifier)
                      .pin(pinned ? null : nodeId);
                  onPinned?.call();
                },
              ),
          ],
        ),
        if (!isNote)
          Text(
            [
              l10n.nodeType(node.type),
              l10n.nodeStatus(node.status),
              if (children.isNotEmpty) l10n.peekItems(children.length),
            ].join(' · '),
            style: theme.textTheme.bodySmall,
          ),
        if (values.isNotEmpty || tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final v in values)
                Chip(
                  visualDensity: VisualDensity.compact,
                  avatar: Icon(
                    valueIcon(v.value),
                    size: 14,
                    color: valueColor(v.value, theme),
                  ),
                  label: Text(v.value.name),
                ),
              for (final t in tags)
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text('#${t.tag.name}'),
                ),
            ],
          ),
        ],
        if (node.bodyMd.trim().isNotEmpty) ...[
          const SizedBox(height: 8),
          MarkdownView(node.bodyMd),
        ],
        if (notes.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(l10n.notesHeading, style: theme.textTheme.labelLarge),
          for (final n in notes)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.sticky_note_2_outlined, size: 18),
              title: Text(l10n.titleOrUntitled(n.title)),
              onTap: () => onOpen(n.id),
            ),
        ],
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton.tonalIcon(
            icon: const Icon(Icons.open_in_new),
            label: Text(l10n.peekOpen),
            onPressed: () => onOpen(nodeId),
          ),
        ),
      ],
    );
  }
}

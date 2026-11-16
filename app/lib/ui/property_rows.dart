import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Pieces of the task page's labelled rows (DESIGN.md §6.1): a label on the
/// left, chips and a small + on the right.

/// One labelled row: "Tags   #work #home  +".
class PropertyRow extends StatelessWidget {
  const PropertyRow({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: c.maxWidth < 480 ? 84 : 108,
              child: Padding(
                // Lines up with the middle of a compact chip.
                padding: const EdgeInsets.only(top: 9),
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

/// The small + at the end of a row.
class RowAddButton extends StatelessWidget {
  const RowAddButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
    this.icon = Icons.add,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    visualDensity: VisualDensity.compact,
    iconSize: 20,
    icon: Icon(icon),
    onPressed: onPressed,
  );
}

/// Muted text that does something when clicked: "Add a description…".
class RowPlaceholder extends StatelessWidget {
  const RowPlaceholder({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

/// Whether a chip's ✕ is always shown: on touch screens there's no hover.
bool get _touch =>
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

/// Builds a chip whose ✕ shows only while it's hovered or focused (on
/// desktop); [builder] gets the ✕ icon to pass as the chip's deleteIcon.
/// The ✕ keeps its room while hidden, so nothing moves on hover.
class HoverDeleteChip extends StatefulWidget {
  const HoverDeleteChip({super.key, required this.builder});

  final Widget Function(Widget deleteIcon) builder;

  @override
  State<HoverDeleteChip> createState() => _HoverDeleteChipState();
}

class _HoverDeleteChipState extends State<HoverDeleteChip> {
  bool _hover = false;
  bool _focus = false;

  @override
  Widget build(BuildContext context) {
    final shown = _touch || _hover || _focus;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onFocusChange: (f) => setState(() => _focus = f),
        child: widget.builder(
          AnimatedOpacity(
            opacity: shown ? 1 : 0,
            duration: const Duration(milliseconds: 120),
            child: const Icon(Icons.close, size: 18),
          ),
        ),
      ),
    );
  }
}

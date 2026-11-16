import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'labels.dart';

/// A compact "Open ▾" button that sets any status.
class StatusChip extends ConsumerWidget {
  const StatusChip({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = switch (node.status) {
      NodeStatus.open => (scheme.surfaceContainerHighest, scheme.onSurface),
      NodeStatus.done => (scheme.primaryContainer, scheme.onPrimaryContainer),
      NodeStatus.dropped => (
        scheme.surfaceContainerHigh,
        scheme.onSurfaceVariant,
      ),
      _ => (scheme.tertiaryContainer, scheme.onTertiaryContainer),
    };
    return MenuAnchor(
      menuChildren: statusMenuItems(context, ref, node),
      builder: (context, controller, _) => Material(
        color: bg,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () =>
              controller.isOpen ? controller.close() : controller.open(),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 6, 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.nodeStatus(node.status),
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: fg),
                ),
                Icon(Icons.arrow_drop_down, size: 20, color: fg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// All five statuses, the current one ticked. "Done" here ends a repeating
/// item for good; the Done button only completes its current occurrence.
List<Widget> statusMenuItems(BuildContext context, WidgetRef ref, Node node) {
  final l10n = AppLocalizations.of(context);
  return [
    for (final s in NodeStatus.values)
      MenuItemButton(
        leadingIcon: Icon(s == node.status ? Icons.check : null),
        onPressed: s == node.status
            ? null
            : () async =>
                  (await ref.read(nodeRepositoryProvider.future))
                      .setStatus(node.id, s),
        child: Text(l10n.nodeStatus(s)),
      ),
  ];
}

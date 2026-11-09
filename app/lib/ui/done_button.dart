import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/node_repository.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'labels.dart';
import 'tree_providers.dart';

/// The explicit "Done" button at the end of an item's title row (§6.1). It
/// only ever completes: open, active or waiting go to done, and a repeating
/// item is done for its current occurrence. Pressing it plays a short burst
/// (and a haptic tap on phones) and offers Undo. Once done, it gives way to
/// a "Completed" label with a small Reopen/Undo link.
class DoneButton extends ConsumerStatefulWidget {
  const DoneButton({super.key, required this.node});

  final Node node;

  @override
  ConsumerState<DoneButton> createState() => _DoneButtonState();
}

class _DoneButtonState extends ConsumerState<DoneButton>
    with SingleTickerProviderStateMixin {
  late final _burst = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );
  final _menu = MenuController();

  @override
  void dispose() {
    _burst.dispose();
    super.dispose();
  }

  Future<NodeRepository> get _repo => ref.read(nodeRepositoryProvider.future);

  Future<void> _complete(OccurrenceStatus? occurrence) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    final material = MaterialLocalizations.of(context);
    HapticFeedback.heavyImpact();
    _burst.forward(from: 0);

    final repo = await _repo;
    final id = widget.node.id;
    final period = occurrence?.period;
    final String message;
    final Future<void> Function() undo;
    if (period != null) {
      await repo.completeOccurrence(id, period);
      message = _isToday(period)
          ? l10n.completedToday
          : l10n.completedFor(material.formatMediumDate(period));
      undo = () => repo.uncompleteOccurrence(id, period);
    } else {
      final before = widget.node.status;
      await repo.setStatus(id, NodeStatus.done);
      message = l10n.markedDone(l10n.titleOrUntitled(widget.node.title));
      undo = () => repo.setStatus(id, before);
    }
    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(label: l10n.undo, onPressed: undo),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final material = MaterialLocalizations.of(context);
    final node = widget.node;
    final finished = isFinished(node.status);

    // A repeating item that is still going is done per occurrence.
    final occurrence = finished
        ? null
        : ref.watch(occurrenceProvider(node.id)).value;
    final period = occurrence?.period;

    final Widget body;
    if (finished || (occurrence?.done ?? false)) {
      final label = finished
          ? (node.status == NodeStatus.dropped
                ? l10n.nodeStatus(NodeStatus.dropped)
                : node.completedAt == null
                ? l10n.completed
                : l10n.completedOn(
                    material.formatMediumDate(node.completedAt!.toLocal()),
                  ))
          : _isToday(period!)
          ? l10n.completedToday
          : l10n.completedFor(material.formatMediumDate(period));
      body = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            node.status == NodeStatus.dropped
                ? Icons.cancel_outlined
                : Icons.check_circle,
            color: node.status == NodeStatus.dropped
                ? theme.colorScheme.outline
                : theme.colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(label, style: theme.textTheme.labelLarge),
          TextButton(
            onPressed: () async {
              final repo = await _repo;
              finished
                  ? await repo.setStatus(node.id, NodeStatus.open)
                  : await repo.uncompleteOccurrence(node.id, period!);
            },
            child: Text(finished ? l10n.reopen : l10n.undo),
          ),
        ],
      );
    } else {
      final notStarted = occurrence != null && period == null;
      final label = occurrence == null
          ? l10n.actionDone
          : notStarted
          ? l10n.repeatNotStarted(
              material.formatMediumDate(occurrence.seriesStart),
            )
          : _isToday(period!)
          ? l10n.actionDoneToday
          : l10n.actionDoneFor(material.formatMediumDate(period));
      body = GestureDetector(
        onSecondaryTap: _menu.open,
        onLongPress: _menu.open,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            textStyle: theme.textTheme.titleSmall,
          ),
          icon: const Icon(Icons.check),
          label: Text(label),
          onPressed: notStarted ? null : () => _complete(occurrence),
        ),
      );
    }

    return MenuAnchor(
      controller: _menu,
      menuChildren: statusMenuItems(context, ref, node),
      child: AnimatedBuilder(
        animation: _burst,
        builder: (context, child) => CustomPaint(
          foregroundPainter: _BurstPainter(
            progress: _burst.value,
            color: theme.colorScheme.primary,
          ),
          child: Transform.scale(
            // A quick pop: up to 1.12 and back, with a little overshoot.
            scale: 1 + 0.12 * math.sin(math.pi * _burst.value),
            child: child,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(key: ValueKey(body.runtimeType), child: body),
        ),
      ),
    );
  }
}

bool _isToday(DateTime day) {
  final now = DateTime.now();
  return day.year == now.year && day.month == now.month && day.day == now.day;
}

/// An expanding ring with sparks, fading out as [progress] goes 0 → 1.
class _BurstPainter extends CustomPainter {
  _BurstPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0 || progress == 1) return;
    final center = size.center(Offset.zero);
    final eased = Curves.easeOutCubic.transform(progress);
    final fade = 1 - progress;
    final base = size.shortestSide / 2;

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * fade
      ..color = color.withValues(alpha: 0.6 * fade);
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size.width + 40 * eased,
        height: size.height + 40 * eased,
      ),
      ring,
    );

    final spark = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3
      ..color = color.withValues(alpha: fade);
    for (var i = 0; i < 10; i++) {
      final angle = i * 2 * math.pi / 10;
      final dir = Offset(
        math.cos(angle) * size.width / size.shortestSide,
        math.sin(angle),
      );
      final from = center + dir * (base + 6 + 20 * eased);
      final to = center + dir * (base + 12 + 32 * eased);
      canvas.drawLine(from, to, spark);
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) =>
      old.progress != progress || old.color != color;
}

/// A compact "Open ▾" button that sets any status.
class StatusMenuButton extends ConsumerWidget {
  const StatusMenuButton({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return MenuAnchor(
      menuChildren: statusMenuItems(context, ref, node),
      builder: (context, controller, _) => TextButton.icon(
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
        iconAlignment: IconAlignment.end,
        icon: const Icon(Icons.arrow_drop_down),
        label: Text(l10n.nodeStatus(node.status)),
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

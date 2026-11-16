import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/review.dart' show formatMinutes;
import '../domain/time_tracking.dart';
import '../l10n/app_localizations.dart';
import '../platform/timer_platform.dart';
import '../providers.dart';
import 'labels.dart';
import 'tree_providers.dart';

/// Timers and focus mode (DESIGN.md §6.15): the bar across the top of the
/// app while one runs, and the controls on an item.

final runningEntryProvider = StreamProvider<TimeEntry?>((ref) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.time.watchRunning();
});

/// What the bar shows besides a running timer: a paused one (this device
/// only), or a break counting down after a focus session.
typedef TimerExtras = ({String? pausedNodeId, DateTime? breakUntil});

final timerExtrasProvider = NotifierProvider<TimerController, TimerExtras>(
  TimerController.new,
);

/// Starts, pauses, resumes and stops timers. A pause ends the time entry;
/// resuming starts a new one on the same item.
class TimerController extends Notifier<TimerExtras> {
  @override
  TimerExtras build() => (pausedNodeId: null, breakUntil: null);

  Future<TimeRepository> get _time async =>
      (await ref.read(nodeRepositoryProvider.future)).time;

  Future<void> start(String nodeId, {int? focusMinutes}) async {
    state = (pausedNodeId: null, breakUntil: null);
    await (await _time).start(nodeId, focusMinutes: focusMinutes);
  }

  Future<void> pause() async {
    final stopped = await (await _time).stop();
    state = (pausedNodeId: stopped?.nodeId, breakUntil: null);
  }

  Future<void> resume() async {
    final id = state.pausedNodeId;
    if (id != null) await start(id);
  }

  Future<void> stop() async {
    await (await _time).stop();
    state = (pausedNodeId: null, breakUntil: null);
  }

  /// Ends a focus session with a short break.
  Future<void> takeBreak({Duration length = const Duration(minutes: 5)}) async {
    await (await _time).stop();
    state = (pausedNodeId: null, breakUntil: DateTime.now().add(length));
  }

  void endBreak() => state = (pausedNodeId: null, breakUntil: null);
}

String formatClock(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes % 60;
  final s = d.inSeconds % 60;
  String two(int n) => n.toString().padLeft(2, '0');
  return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
}

/// "⏱ Pack bags · 0:23:41 [Pause] [Stop]" across the top of the app, while
/// a timer runs, is paused, or a break is on. Focus sessions count down and
/// end with a chime and "Keep going / Done / Take a break".
class TimerBar extends ConsumerStatefulWidget {
  const TimerBar({super.key, required this.onOpen, this.compact = false});

  final void Function(String id) onOpen;

  /// The mini window: no title link, tighter.
  final bool compact;

  @override
  ConsumerState<TimerBar> createState() => _TimerBarState();
}

class _TimerBarState extends ConsumerState<TimerBar> {
  Timer? _tick;

  /// Focus sessions already wrapped up (so the prompt shows once).
  static final _prompted = <String>{};
  static bool _breakChimed = false;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  Future<void> _focusEnded(TimeEntry e, String title) async {
    _prompted.add(e.id);
    final l10n = AppLocalizations.of(context);
    unawaited(SystemSound.play(SystemSoundType.alert));
    if (!mounted) return;
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.focusEndedTitle),
        content: Text(l10n.focusEndedBody(title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'break'),
            child: Text(l10n.focusBreak),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'done'),
            child: Text(l10n.focusDone),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'keep'),
            child: Text(l10n.focusKeepGoing),
          ),
        ],
      ),
    );
    final timer = ref.read(timerExtrasProvider.notifier);
    switch (choice) {
      case 'done':
        await timer.stop();
        await (await ref.read(nodeRepositoryProvider.future))
            .setDone(e.nodeId, true);
      case 'break':
        await timer.takeBreak();
      default:
        break; // Keep going: the timer keeps counting up.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final running = ref.watch(runningEntryProvider).value;
    final extras = ref.watch(timerExtrasProvider);
    final timer = ref.read(timerExtrasProvider.notifier);
    final nodeId = running?.nodeId ?? extras.pausedNodeId;
    final node = nodeId == null ? null : ref.watch(nodeProvider(nodeId)).value;
    final title = l10n.titleOrUntitled(node?.title ?? '');
    final now = DateTime.now();

    // Keep the tray, mini window and phone notification in step.
    TimerPlatform.instance.update(
      running: running,
      title: title,
      paused: running == null && extras.pausedNodeId != null,
    );

    final breakUntil = extras.breakUntil;
    if (running == null && extras.pausedNodeId == null && breakUntil == null) {
      return const SizedBox.shrink();
    }

    Widget bar({
      required IconData icon,
      required String text,
      double? progress,
      required List<Widget> actions,
      VoidCallback? onTap,
    }) => Material(
      color: theme.colorScheme.secondaryContainer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 8 : 16,
              vertical: 2,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: widget.compact ? null : onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                ),
                ...actions,
              ],
            ),
          ),
          if (progress != null)
            LinearProgressIndicator(value: progress.clamp(0, 1), minHeight: 3),
        ],
      ),
    );

    final mini = TimerPlatform.instance.canMiniWindow
        ? IconButton(
            tooltip: widget.compact ? l10n.timerExpand : l10n.timerMiniWindow,
            icon: Icon(
              widget.compact
                  ? Icons.open_in_full
                  : Icons.picture_in_picture_alt,
            ),
            onPressed: () => widget.compact
                ? TimerPlatform.instance.exitMiniWindow()
                : TimerPlatform.instance.enterMiniWindow(),
          )
        : null;

    if (running == null && breakUntil != null) {
      final left = breakUntil.difference(now);
      if (left <= Duration.zero) {
        if (!_breakChimed) {
          _breakChimed = true;
          unawaited(SystemSound.play(SystemSoundType.alert));
        }
      } else {
        _breakChimed = false;
      }
      return bar(
        icon: Icons.free_breakfast_outlined,
        text: left <= Duration.zero
            ? l10n.breakOver
            : l10n.breakLeft(formatClock(left)),
        progress: 1 - left.inSeconds / 300,
        actions: [
          TextButton(onPressed: timer.endBreak, child: Text(l10n.breakEnd)),
          ?mini,
        ],
      );
    }

    if (running == null) {
      return bar(
        icon: Icons.pause_circle_outline,
        text: l10n.timerPaused(title),
        onTap: () => widget.onOpen(nodeId!),
        actions: [
          IconButton(
            tooltip: l10n.timerResume,
            icon: const Icon(Icons.play_arrow),
            onPressed: timer.resume,
          ),
          IconButton(
            tooltip: l10n.timerStop,
            icon: const Icon(Icons.stop),
            onPressed: timer.stop,
          ),
          ?mini,
        ],
      );
    }

    final elapsed = now.toUtc().difference(running.startedAt);
    final focus = running.focusMinutes;
    String text;
    double? progress;
    if (focus != null) {
      final left = Duration(minutes: focus) - elapsed;
      progress = elapsed.inSeconds / (focus * 60);
      text = left > Duration.zero
          ? l10n.focusLeft(title, formatClock(left))
          : l10n.focusOver(title, formatClock(elapsed));
      if (left <= Duration.zero && !_prompted.contains(running.id)) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _focusEnded(running, title),
        );
        _prompted.add(running.id);
      }
    } else {
      text = '$title · ${formatClock(elapsed)}';
    }
    return bar(
      icon: focus != null ? Icons.center_focus_strong : Icons.timer_outlined,
      text: text,
      progress: progress,
      onTap: () => widget.onOpen(running.nodeId),
      actions: [
        IconButton(
          tooltip: l10n.timerPause,
          icon: const Icon(Icons.pause),
          onPressed: timer.pause,
        ),
        IconButton(
          tooltip: l10n.timerStop,
          icon: const Icon(Icons.stop),
          onPressed: timer.stop,
        ),
        ?mini,
      ],
    );
  }
}

/// ▶ on an item: start a timer or a focus session; ■ while it's the one
/// running.
class TimerButton extends ConsumerWidget {
  const TimerButton({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final running = ref.watch(runningEntryProvider).value;
    final timer = ref.read(timerExtrasProvider.notifier);
    if (running?.nodeId == node.id) {
      return IconButton(
        tooltip: l10n.timerStop,
        icon: const Icon(Icons.stop_circle_outlined),
        onPressed: timer.stop,
      );
    }
    final estimate = node.estimateMinutes;
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.timer_outlined),
          onPressed: () => timer.start(node.id),
          child: Text(l10n.timerStart),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.center_focus_strong),
          onPressed: () => timer.start(node.id, focusMinutes: 25),
          child: Text(l10n.focusFor(formatMinutes(25))),
        ),
        if (estimate != null && estimate != 25)
          MenuItemButton(
            leadingIcon: const Icon(Icons.center_focus_strong),
            onPressed: () => timer.start(node.id, focusMinutes: estimate),
            child: Text(l10n.focusForEstimate(formatMinutes(estimate))),
          ),
      ],
      builder: (context, controller, _) => IconButton(
        tooltip: l10n.timerStartMenu,
        icon: const Icon(Icons.play_circle_outline),
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../platform/reminder_notifier.dart';
import '../providers.dart';
import 'labels.dart';
import 'attachment_page.dart';
import 'calendar_page.dart';
import 'review_page.dart';
import 'timer.dart';
import 'today_page.dart';
import '../platform/timer_platform.dart';
import 'files.dart';
import 'node_detail.dart';
import 'peek.dart';
import 'removal.dart';
import 'search_pane.dart';
import 'tags.dart';
import 'tree_pane.dart';
import 'tree_providers.dart';
import 'values.dart';

/// Two panes (tree + detail) on wide screens such as Windows; drill-down
/// navigation on narrow ones such as phones (DESIGN.md §6.1).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const wideBreakpoint = 720.0;

  /// Opens the timer's item: in the detail pane, or as a page on phones.
  static void _openFromBar(BuildContext context, WidgetRef ref, String id) {
    if (MediaQuery.sizeOf(context).width >= wideBreakpoint) {
      ref.read(sidePageProvider.notifier).show(null);
      ref.read(removedViewProvider.notifier).show(null);
      ref.read(openAttachmentProvider.notifier).open(null);
      ref.read(selectedNodeProvider.notifier).select(id);
    } else {
      openNodePage(context, id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ready = ref.watch(nodeRepositoryProvider);
    // Tray menu and phone notification buttons control the timer.
    TimerPlatform.instance.onAction = (action) {
      final timer = ref.read(timerExtrasProvider.notifier);
      switch (action) {
        case 'pause':
          timer.pause();
        case 'resume':
          timer.resume();
        case 'stop':
          timer.stop();
        case 'show':
          TimerPlatform.instance.show();
      }
    };
    // Reminders are scheduled once the data is open, and kept up to date.
    ref.listen(nodeRepositoryProvider, (_, next) {
      if (next case AsyncData(:final value)) {
        ReminderNotifier.instance.start(value);
      }
    });

    // The mini timer window (Windows): just the timer, always on top.
    return ValueListenableBuilder<bool>(
      valueListenable: TimerPlatform.instance.miniWindow,
      builder: (context, mini, child) => mini
          ? Scaffold(
              body: Center(
                child: TimerBar(
                  compact: true,
                  onOpen: (id) => _openFromBar(context, ref, id),
                ),
              ),
            )
          : child!,
      child: _full(context, ref, l10n, ready),
    );
  }

  Widget _full(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AsyncValue<Object?> ready,
  ) {
    // Ctrl+F reaches the search box from anywhere.
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
            ref.read(searchFocusProvider).requestFocus(),
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.appTitle)),
        body: switch (ready) {
          AsyncData() => Column(
            children: [
              // A running timer shows across the top of every screen.
              TimerBar(onOpen: (id) => _openFromBar(context, ref, id)),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) =>
                      constraints.maxWidth >= wideBreakpoint
                      ? const _WideLayout()
                      : const _NarrowLayout(),
                ),
              ),
            ],
          ),
          AsyncError(:final error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l10n.startupError('$error'),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _WideLayout extends ConsumerWidget {
  const _WideLayout();

  Future<void> _open(WidgetRef ref, String id) async {
    ref.read(removedViewProvider.notifier).show(null);
    ref.read(sidePageProvider.notifier).show(null);
    ref.read(openAttachmentProvider.notifier).open(null);
    ref.read(selectedNodeProvider.notifier).select(id);
    // Reveal the node in the tree.
    final repo = await ref.read(nodeRepositoryProvider.future);
    final ancestors = await repo.ancestors(id);
    ref
        .read(expandedNodesProvider.notifier)
        .expandAll(ancestors.map((a) => a.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedNodeProvider);
    final removedView = ref.watch(removedViewProvider);
    final sidePage = ref.watch(sidePageProvider);
    final attachment = ref.watch(openAttachmentProvider);
    final pinned = ref.watch(pinnedPeekProvider);
    void open(String id) => _open(ref, id);
    void leave(String? parentId) => parentId == null
        ? ref.read(selectedNodeProvider.notifier).select(null)
        : open(parentId);

    return _OpenFromReminders(
      onOpen: open,
      child: CalendarOpener(
        open: () {
          ref.read(removedViewProvider.notifier).show(null);
          ref.read(openAttachmentProvider.notifier).open(null);
          ref.read(sidePageProvider.notifier).show(SidePage.calendarPage);
        },
        child: AttachmentOpener(
          open: (id, {via}) {
            ref.read(sidePageProvider.notifier).show(null);
            ref.read(removedViewProvider.notifier).show(null);
            ref.read(openAttachmentProvider.notifier).open((id: id, via: via));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 320,
                child: _Pane(
                  child: TreePane(
                    onOpen: open,
                    onOpenRemoved: (which) {
                      ref.read(selectedNodeProvider.notifier).select(null);
                      ref.read(sidePageProvider.notifier).show(null);
                      ref.read(removedViewProvider.notifier).show(which);
                    },
                    onOpenPage: (page) {
                      ref.read(selectedNodeProvider.notifier).select(null);
                      ref.read(removedViewProvider.notifier).show(null);
                      ref.read(sidePageProvider.notifier).show(page);
                    },
                    selectedId: selected,
                  ),
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: _Pane(
                  child: sidePage == SidePage.calendarPage && attachment == null
                      ? CalendarPage(onOpen: open)
                      : sidePage == SidePage.reviewPage && attachment == null
                      ? ReviewPage(onOpen: open)
                      : attachment != null
                      ? AttachmentPage(
                          key: ValueKey(attachment.id),
                          attachmentId: attachment.id,
                          via: attachment.via,
                          onOpen: open,
                          onBack: open,
                        )
                      : sidePage == SidePage.valuesPage
                      ? ValuesPage(onOpen: open)
                      : sidePage == SidePage.tagsPage
                      ? const TagsPage()
                      : removedView != null
                      ? RemovedList(which: removedView, onOpen: open)
                      : selected == null
                      ? TodayPage(onOpen: open)
                      : NodeDetail(
                          nodeId: selected,
                          onOpen: open,
                          onLeave: leave,
                        ),
                ),
              ),
              // A pinned peek (§6.1.1) stays beside whatever is open.
              if (pinned != null) ...[
                const VerticalDivider(width: 1),
                SizedBox(
                  width: 320,
                  child: PeekCard(nodeId: pinned, onOpen: open, pinned: true),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// One pane of the wide layout, with its own snack bars, so a message (and
/// its Undo) never covers the other pane.
class _Pane extends StatelessWidget {
  const _Pane({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ScaffoldMessenger(
    child: Scaffold(backgroundColor: Colors.transparent, body: child),
  );
}

/// Phones: Today, the tree and the calendar as tabs (Today first); items
/// and other pages open full screen on top.
class _NarrowLayout extends StatefulWidget {
  const _NarrowLayout();

  @override
  State<_NarrowLayout> createState() => _NarrowLayoutState();
}

class _NarrowLayoutState extends State<_NarrowLayout> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    void open(String id) => openNodePage(context, id);
    final body = switch (_tab) {
      0 => TodayPage(onOpen: open),
      2 => CalendarPage(onOpen: open),
      _ => TreePane(
        onOpen: open,
        onOpenPage: (page) => switch (page) {
          SidePage.todayPage => setState(() => _tab = 0),
          SidePage.calendarPage => setState(() => _tab = 2),
          _ => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => Scaffold(
                appBar: AppBar(),
                body: switch (page) {
                  SidePage.reviewPage => ReviewPage(onOpen: open),
                  SidePage.valuesPage => ValuesPage(onOpen: open),
                  // Searching shows results in the tree pane, under this page.
                  SidePage.tagsPage => TagsPage(
                    onSearched: () => Navigator.of(context).maybePop(),
                  ),
                  _ => const SizedBox.shrink(),
                },
              ),
            ),
          ),
        },
        onOpenRemoved: (which) => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => Scaffold(
              appBar: AppBar(),
              body: RemovedList(which: which, onOpen: open),
            ),
          ),
        ),
      ),
    };
    return _OpenFromReminders(
      onOpen: open,
      child: CalendarOpener(
        open: () => setState(() => _tab = 2),
        child: AttachmentOpener(
          open: (id, {via}) => openAttachmentPage(context, id, via: via),
          child: Column(
            children: [
              Expanded(child: body),
              NavigationBar(
                selectedIndex: _tab,
                onDestinationSelected: (i) => setState(() => _tab = i),
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.wb_sunny_outlined),
                    selectedIcon: const Icon(Icons.wb_sunny),
                    label: l10n.todayView,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.account_tree_outlined),
                    selectedIcon: const Icon(Icons.account_tree),
                    label: l10n.treeView,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.calendar_month_outlined),
                    selectedIcon: const Icon(Icons.calendar_month),
                    label: l10n.calendarView,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Phones: pushes the calendar page.
void openCalendarPage(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => Scaffold(
        appBar: AppBar(),
        body: CalendarPage(onOpen: (id) => openNodePage(context, id)),
      ),
    ),
  );
}

/// Pushes a full-screen detail page; the system back gesture returns.
void openNodePage(BuildContext context, String id) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (context) => _NodePage(nodeId: id)));
}

/// Phones: pushes an attachment's page; Back pops it.
void openAttachmentPage(BuildContext context, String id, {String? via}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => Scaffold(
        appBar: AppBar(),
        body: AttachmentPage(
          attachmentId: id,
          via: via,
          onOpen: (n) => openNodePage(context, n),
          onBack: (_) => Navigator.of(context).maybePop(),
        ),
      ),
    ),
  );
}

class _NodePage extends ConsumerWidget {
  const _NodePage({required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final node = ref.watch(nodeProvider(nodeId)).value;
    return Scaffold(
      appBar: AppBar(
        title: Text(node == null ? '' : l10n.titleOrUntitled(node.title)),
      ),
      body: CalendarOpener(
        open: () => openCalendarPage(context),
        child: AttachmentOpener(
          open: (id, {via}) => openAttachmentPage(context, id, via: via),
          child: NodeDetail(
            nodeId: nodeId,
            onOpen: (id) => openNodePage(context, id),
            onLeave: (_) => Navigator.of(context).maybePop(),
          ),
        ),
      ),
    );
  }
}

/// Opens the item of a tapped reminder notification.
class _OpenFromReminders extends StatefulWidget {
  const _OpenFromReminders({required this.onOpen, required this.child});

  final void Function(String id) onOpen;
  final Widget child;

  @override
  State<_OpenFromReminders> createState() => _OpenFromRemindersState();
}

class _OpenFromRemindersState extends State<_OpenFromReminders> {
  final _opened = ReminderNotifier.instance.opened;

  void _onOpened() {
    final id = _opened.value;
    if (id == null) return;
    _opened.value = null;
    widget.onOpen(id);
  }

  @override
  void initState() {
    super.initState();
    _opened.addListener(_onOpened);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onOpened());
  }

  @override
  void dispose() {
    _opened.removeListener(_onOpened);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

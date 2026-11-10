import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'labels.dart';
import 'attachment_page.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ready = ref.watch(nodeRepositoryProvider);

    // Ctrl+F reaches the search box from anywhere.
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
            ref.read(searchFocusProvider).requestFocus(),
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.appTitle)),
        body: switch (ready) {
          AsyncData() => LayoutBuilder(
            builder: (context, constraints) =>
                constraints.maxWidth >= wideBreakpoint
                ? const _WideLayout()
                : const _NarrowLayout(),
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
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(selectedNodeProvider);
    final removedView = ref.watch(removedViewProvider);
    final sidePage = ref.watch(sidePageProvider);
    final attachment = ref.watch(openAttachmentProvider);
    final pinned = ref.watch(pinnedPeekProvider);
    void open(String id) => _open(ref, id);
    void leave(String? parentId) => parentId == null
        ? ref.read(selectedNodeProvider.notifier).select(null)
        : open(parentId);

    return AttachmentOpener(
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
              child: attachment != null
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
                  ? Center(child: Text(l10n.noSelection))
                  : NodeDetail(nodeId: selected, onOpen: open, onLeave: leave),
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

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout();

  @override
  Widget build(BuildContext context) => AttachmentOpener(
    open: (id, {via}) => openAttachmentPage(context, id, via: via),
    child: TreePane(
      onOpen: (id) => openNodePage(context, id),
      onOpenPage: (page) => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => Scaffold(
            appBar: AppBar(),
            body: switch (page) {
              SidePage.valuesPage => ValuesPage(
                onOpen: (id) => openNodePage(context, id),
              ),
              // Searching shows results in the tree pane, under this page.
              SidePage.tagsPage => TagsPage(
                onSearched: () => Navigator.of(context).maybePop(),
              ),
            },
          ),
        ),
      ),
      onOpenRemoved: (which) => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => Scaffold(
            appBar: AppBar(),
            body: RemovedList(
              which: which,
              onOpen: (id) => openNodePage(context, id),
            ),
          ),
        ),
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
      body: AttachmentOpener(
        open: (id, {via}) => openAttachmentPage(context, id, via: via),
        child: NodeDetail(
          nodeId: nodeId,
          onOpen: (id) => openNodePage(context, id),
          onLeave: (_) => Navigator.of(context).maybePop(),
        ),
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/node_repository.dart';
import '../providers.dart';

/// Live children (with child counts) of a parent; null = top level.
final childrenProvider =
    StreamProvider.family<List<NodeWithChildCount>, String?>((
      ref,
      parentId,
    ) async* {
      final repo = await ref.watch(nodeRepositoryProvider.future);
      yield* repo.watchChildrenWithCounts(parentId);
    });

/// A single node, live. Null once it is gone.
final nodeProvider = StreamProvider.family<Node?, String>((ref, id) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.watch(id);
});

/// The node's ancestors, top-level first, live.
final ancestorsProvider = StreamProvider.family<List<Node>, String>((
  ref,
  id,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.watchAncestors(id);
});

/// Live notes under a node, shown in its notes column.
final notesProvider = StreamProvider.family<List<Node>, String>((
  ref,
  parentId,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.watchNotes(parentId);
});

/// An item's one-at-a-time set (D36), or null if its children don't take
/// turns.
final exclusiveProvider = StreamProvider.family<ExclusiveStatus?, String>((
  ref,
  parentId,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.watchExclusive(parentId);
});

/// A repeating item's current occurrence and whether it was done; null if
/// the item doesn't repeat.
final occurrenceProvider = StreamProvider.family<OccurrenceStatus?, String>((
  ref,
  id,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.watchOccurrence(id);
});

/// The groups in the Archive or Trash, live.
final removedGroupsProvider =
    StreamProvider.family<List<RemovedGroup>, Lifecycle>((ref, which) async* {
      final repo = await ref.watch(nodeRepositoryProvider.future);
      yield* repo.watchRemovedGroups(which);
    });

/// How many groups are in the Archive and in Trash.
final removedCountsProvider = StreamProvider<Map<Lifecycle, int>>((ref) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.watchRemovedCounts();
});

/// The Archive or Trash list when it is shown in the detail pane (wide
/// layout) instead of a node.
final removedViewProvider = NotifierProvider<RemovedView, Lifecycle?>(
  RemovedView.new,
);

class RemovedView extends Notifier<Lifecycle?> {
  @override
  Lifecycle? build() => null;

  void show(Lifecycle? which) => state = which;
}

/// A node's shortcuts (§6.12), live.
final placementsOfProvider = StreamProvider.family<List<PlacementInfo>, String>(
  (ref, nodeId) async* {
    final repo = await ref.watch(nodeRepositoryProvider.future);
    yield* repo.watchPlacementsOf(nodeId);
  },
);

/// The shortcut the open node was reached through, if any, so its
/// breadcrumb can say "via Errands".
final openedViaProvider = NotifierProvider<OpenedVia, OpenedViaShortcut?>(
  OpenedVia.new,
);

/// [link]: opened from an item the note is linked into (§6.10), rather
/// than through a shortcut.
typedef OpenedViaShortcut = ({String nodeId, String parentId, bool link});

class OpenedVia extends Notifier<OpenedViaShortcut?> {
  @override
  OpenedViaShortcut? build() => null;

  /// Records how [nodeId] is being opened: through a shortcut under
  /// [parentId], or (null) in its real place.
  void opening(String nodeId, {String? viaParent, bool link = false}) =>
      state = viaParent == null
      ? null
      : (nodeId: nodeId, parentId: viaParent, link: link);
}

/// Whether the notes column beside an item is open. Collapsed by default;
/// one setting for all items, per device, in memory for now.
final notesColumnOpenProvider = NotifierProvider<NotesColumnOpen, bool>(
  NotesColumnOpen.new,
);

class NotesColumnOpen extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

/// The node shown in the detail pane (wide layout).
final selectedNodeProvider = NotifierProvider<SelectedNode, String?>(
  SelectedNode.new,
);

class SelectedNode extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;
}

/// Which tree rows are expanded. Per device, in memory for now.
final expandedNodesProvider = NotifierProvider<ExpandedNodes, Set<String>>(
  ExpandedNodes.new,
);

class ExpandedNodes extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  void toggle(String id) =>
      state = state.contains(id) ? ({...state}..remove(id)) : {...state, id};

  void expandAll(Iterable<String> ids) => state = {...state, ...ids};
}

/// The item the tree is zoomed into (§6.1): its children show as the top
/// level. Null = the whole tree.
final treeZoomProvider = NotifierProvider<TreeZoom, String?>(TreeZoom.new);

class TreeZoom extends Notifier<String?> {
  @override
  String? build() => null;

  void zoom(String? id) => state = id;
}

/// Pages opened from the entries under the tree.
enum SidePage { calendarPage, valuesPage, tagsPage }

/// The page filling the detail pane instead of an item (wide layout).
final sidePageProvider = NotifierProvider<SidePageState, SidePage?>(
  SidePageState.new,
);

class SidePageState extends Notifier<SidePage?> {
  @override
  SidePage? build() => null;

  void show(SidePage? page) => state = page;
}

/// The attachment shown in the detail pane (wide layout), and the item it
/// was opened from when that isn't its owner.
typedef OpenedAttachment = ({String id, String? via});

final openAttachmentProvider =
    NotifierProvider<OpenAttachmentState, OpenedAttachment?>(
      OpenAttachmentState.new,
    );

class OpenAttachmentState extends Notifier<OpenedAttachment?> {
  @override
  OpenedAttachment? build() => null;

  void open(OpenedAttachment? a) => state = a;
}

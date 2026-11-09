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

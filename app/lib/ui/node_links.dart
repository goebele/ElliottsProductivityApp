import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'labels.dart';
import 'peek.dart';
import 'tree_pane.dart';

/// Links written in text to other items and notes (§6.3).

final linkedFromProvider = StreamProvider.family<List<Node>, String>((
  ref,
  id,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.watchLinkedFrom(id);
});

/// "Linked from: Trip · Packing ideas": the items and notes whose text
/// links here (backlinks).
class LinkedFromRow extends ConsumerWidget {
  const LinkedFromRow({super.key, required this.nodeId, required this.onOpen});

  final String nodeId;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final from = ref.watch(linkedFromProvider(nodeId)).value ?? const [];
    if (from.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(l10n.linkedFrom2(from.length)),
          for (final n in from)
            PeekTarget(
              nodeId: n.id,
              onOpen: onOpen,
              child: ActionChip(
                visualDensity: VisualDensity.compact,
                avatar: Icon(
                  n.type == NodeType.note
                      ? Icons.sticky_note_2_outlined
                      : nodeTypeIcon(n.type),
                  size: 16,
                ),
                label: Text(l10n.titleOrUntitled(n.title)),
                onPressed: () => onOpen(n.id),
              ),
            ),
        ],
      ),
    );
  }
}

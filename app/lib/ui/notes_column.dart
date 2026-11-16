import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/markdown_format.dart';
import '../data/database.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'files.dart';
import 'labels.dart';
import 'linked_notes.dart';
import 'tree_pane.dart';
import 'tree_providers.dart';

/// The item's own notes and files, plus the ones from above.
int _noteCount(WidgetRef ref, String parentId) =>
    (ref.watch(notesProvider(parentId)).value?.length ?? 0) +
    (ref.watch(filesProvider(parentId)).value?.length ?? 0) +
    (ref.watch(linkedNotesProvider(parentId)).value?.length ?? 0) +
    (ref.watch(linkedFilesProvider(parentId)).value?.length ?? 0);

/// The notes column, collapsed: a thin strip with the count; click to open.
class NotesStrip extends ConsumerWidget {
  const NotesStrip({super.key, required this.parentId});

  final String parentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final count = _noteCount(ref, parentId);
    return InkWell(
      onTap: () => ref.read(notesColumnOpenProvider.notifier).toggle(),
      child: Tooltip(
        message: l10n.notesShow,
        child: SizedBox(
          width: 44,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Badge(
                isLabelVisible: count > 0,
                label: Text('$count'),
                child: const Icon(Icons.sticky_note_2_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The column beside an item listing its notes (DESIGN.md §6.1, v0.5).
/// Below them, notes from above: linked or shared down by ancestors (§6.10).
/// Its files (§6.4) sit between the two.
class NotesColumn extends ConsumerWidget {
  const NotesColumn({super.key, required this.parentId, required this.onOpen});

  final String parentId;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 8, 24),
      children: [
        Row(
          children: [
            const Icon(Icons.sticky_note_2_outlined, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.notesToggle(_noteCount(ref, parentId)),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: l10n.notesHide,
              icon: const Icon(Icons.chevron_right),
              onPressed: () =>
                  ref.read(notesColumnOpenProvider.notifier).toggle(),
            ),
          ],
        ),
        const SizedBox(height: 4),
        NotesList(parentId: parentId, onOpen: onOpen),
        FilesList(nodeId: parentId),
        LinkedNotesList(childId: parentId, onOpen: onOpen),
      ],
    );
  }
}

/// Narrow layout: notes as a collapsed section under the item's items.
class NotesSection extends ConsumerWidget {
  const NotesSection({super.key, required this.parentId, required this.onOpen});

  final String parentId;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final count = _noteCount(ref, parentId);
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 8),
      leading: const Icon(Icons.sticky_note_2_outlined),
      title: Text(l10n.notesToggle(count)),
      children: [
        NotesList(parentId: parentId, onOpen: onOpen),
        FilesList(nodeId: parentId),
        LinkedNotesList(childId: parentId, onOpen: onOpen),
      ],
    );
  }
}

/// The notes under [parentId] as cards, plus "New note".
class NotesList extends ConsumerWidget {
  const NotesList({super.key, required this.parentId, required this.onOpen});

  final String parentId;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final notes = ref.watch(notesProvider(parentId)).value ?? const <Node>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (notes.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.notesEmpty,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        for (final note in notes)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.sticky_note_2_outlined),
              title: Text(
                l10n.titleOrUntitled(note.title),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: note.bodyMd.trim().isEmpty
                  ? null
                  : Text(
                      markdownPlainText(note.bodyMd),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
              trailing: IconButton(
                tooltip: note.sharedWithChildren
                    ? l10n.stopSharing
                    : l10n.shareWithAll,
                isSelected: note.sharedWithChildren,
                icon: const Icon(Icons.push_pin_outlined),
                selectedIcon: const Icon(Icons.push_pin),
                onPressed: () async =>
                    (await ref.read(nodeRepositoryProvider.future))
                        .setNoteShared(note.id, !note.sharedWithChildren),
              ),
              onTap: () => onOpen(note.id),
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l10n.newNote),
            onPressed: () async {
              final repo = await ref.read(nodeRepositoryProvider.future);
              onOpen(
                await repo.create(
                  title: '',
                  type: NodeType.note,
                  parentId: parentId,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/markdown_format.dart';
import '../domain/node_repository.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'labels.dart';
import 'removal.dart';
import 'tree_pane.dart';
import 'tree_providers.dart';

/// Linked ancestor notes (DESIGN.md §6.10): an item reuses notes from the
/// items above it. Nothing is copied: a linked note is the ancestor's note,
/// opened and edited in its own page.

final linkedNotesProvider = StreamProvider.family<List<LinkedNote>, String>((
  ref,
  childId,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.watchLinkedNotes(childId);
});

final linkedIntoProvider = StreamProvider.family<List<Node>, String>((
  ref,
  noteId,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.watchLinkedInto(noteId);
});

/// The ancestors' notes, re-read whenever nodes change.
final ancestorNotesProvider =
    StreamProvider.family<List<(Node, List<Node>)>, String>((
      ref,
      childId,
    ) async* {
      final repo = await ref.watch(nodeRepositoryProvider.future);
      final db = ref.watch(databaseProvider);
      yield* db
          .customSelect('SELECT 1', readsFrom: {db.nodes})
          .watch()
          .asyncMap((_) => repo.ancestorNotes(childId));
    });

/// The "From above" list in an item's notes column: notes linked from
/// ancestors, and notes an ancestor shares with all its sub-items (📌).
/// Hidden when nothing is linked and nothing above has notes.
class LinkedNotesList extends ConsumerWidget {
  const LinkedNotesList({
    super.key,
    required this.childId,
    required this.onOpen,
  });

  final String childId;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final linked = ref.watch(linkedNotesProvider(childId)).value ?? const [];
    final above = ref.watch(ancestorNotesProvider(childId)).value ?? const [];
    if (linked.isEmpty && above.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text(l10n.linkedNotesHeading, style: theme.textTheme.titleSmall),
        const SizedBox(height: 4),
        for (final l in linked)
          _LinkedNoteCard(childId: childId, linked: l, onOpen: onOpen),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: const Icon(Icons.add_link),
            label: Text(l10n.linkFromAbove),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => _LinkPicker(childId: childId),
            ),
          ),
        ),
      ],
    );
  }
}

/// A small "↳ from: Trip" tag that opens the owner.
class _FromTag extends StatelessWidget {
  const _FromTag({
    required this.owner,
    required this.onOpen,
    this.shared = false,
  });

  final Node owner;
  final OpenNode onOpen;
  final bool shared;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final style = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.primary,
    );
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () => onOpen(owner.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              shared ? Icons.push_pin : Icons.subdirectory_arrow_right,
              size: 12,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                shared
                    ? l10n.sharedFrom(l10n.titleOrUntitled(owner.title))
                    : l10n.linkedFrom(l10n.titleOrUntitled(owner.title)),
                style: style,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkedNoteCard extends ConsumerWidget {
  const _LinkedNoteCard({
    required this.childId,
    required this.linked,
    required this.onOpen,
  });

  final String childId;
  final LinkedNote linked;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final note = linked.note;
    final owner = linked.owner;
    final live = note != null && note.lifecycle == Lifecycle.live;

    Future<void> unlink() async =>
        (await ref.read(nodeRepositoryProvider.future))
            .unlinkNote(childId, linked.noteId);

    // Shared notes come from the ancestor; there is nothing to unlink here.
    final unlinkButton = linked.shared
        ? null
        : IconButton(
            tooltip: l10n.unlink,
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.link_off),
            onPressed: unlink,
          );

    if (!live) {
      // Source archived, trashed, or purged: a greyed placeholder.
      final (text, action) = switch (note?.lifecycle) {
        null => (
          l10n.sourceDeleted,
          TextButton(onPressed: unlink, child: Text(l10n.clearLink)),
        ),
        final lifecycle => (
          lifecycle == Lifecycle.archived
              ? l10n.sourceArchived
              : l10n.sourceTrashed,
          TextButton(
            onPressed: () async {
              final repo = await ref.read(nodeRepositoryProvider.future);
              final root = await repo.get(note!.lifecycleRootId ?? note.id);
              if (root != null && context.mounted) {
                await restoreGroup(context, ref, root);
              }
            },
            child: Text(l10n.restoreSource),
          ),
        ),
      };
      return Opacity(
        opacity: 0.6,
        child: Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 4, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note == null ? text : l10n.titleOrUntitled(note.title),
                  style: theme.textTheme.titleSmall,
                ),
                if (note != null) Text(text, style: theme.textTheme.bodySmall),
                Row(children: [action, ?unlinkButton]),
              ],
            ),
          ),
        ),
      );
    }

    final preview = markdownPlainText(note.bodyMd);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          ref
              .read(openedViaProvider.notifier)
              .opening(note.id, viaParent: childId, link: true);
          onOpen(note.id);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 4, 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.titleOrUntitled(note.title),
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (preview.isNotEmpty)
                      Text(
                        preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    if (owner != null)
                      _FromTag(
                        owner: owner,
                        onOpen: onOpen,
                        shared: linked.shared,
                      ),
                  ],
                ),
              ),
              ?unlinkButton,
            ],
          ),
        ),
      ),
    );
  }
}

/// Ticks the ancestors' notes to link, grouped by ancestor, nearest first.
/// Changes apply at once; unticking unlinks.
class _LinkPicker extends ConsumerWidget {
  const _LinkPicker({required this.childId});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final above = ref.watch(ancestorNotesProvider(childId)).value ?? const [];
    final linked = ref.watch(linkedNotesProvider(childId)).value ?? const [];
    final linkedIds = {
      for (final l in linked)
        if (!l.shared) l.noteId,
    };
    final aboveIds = {
      for (final (_, notes) in above)
        for (final n in notes) n.id,
    };
    // Linked earlier but no longer above (the item moved, D17).
    final elsewhere = [
      for (final l in linked)
        if (!aboveIds.contains(l.noteId) && l.note != null) l,
    ];

    Future<void> toggle(String noteId, bool on) async {
      final repo = await ref.read(nodeRepositoryProvider.future);
      on
          ? await repo.linkNote(childId, noteId)
          : await repo.unlinkNote(childId, noteId);
    }

    // Shared down by the ancestor: already here, and not this item's to
    // unlink.
    Widget note(Node n, {String? from}) => CheckboxListTile(
      dense: true,
      value: n.sharedWithChildren || linkedIds.contains(n.id),
      title: Text(l10n.titleOrUntitled(n.title)),
      subtitle: n.sharedWithChildren
          ? Text(l10n.sharedWithAll)
          : from == null
          ? null
          : Text(l10n.linkedFrom(from)),
      onChanged: n.sharedWithChildren
          ? null
          : (on) => toggle(n.id, on ?? false),
    );

    Widget heading(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(text, style: theme.textTheme.labelLarge),
    );

    return AlertDialog(
      title: Text(l10n.linkPickerTitle),
      contentPadding: const EdgeInsets.only(top: 8),
      content: SizedBox(
        width: 420,
        child: ListView(
          shrinkWrap: true,
          children: [
            if (above.isEmpty && elsewhere.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.linkPickerEmpty),
              ),
            for (final (i, (ancestor, notes)) in above.indexed) ...[
              heading(
                i == 0
                    ? l10n.linkGroupParent(l10n.titleOrUntitled(ancestor.title))
                    : l10n.titleOrUntitled(ancestor.title),
              ),
              for (final n in notes) note(n),
            ],
            if (elsewhere.isNotEmpty) ...[
              heading(l10n.linkGroupElsewhere),
              for (final l in elsewhere)
                note(
                  l.note!,
                  from: l.owner == null
                      ? null
                      : l10n.titleOrUntitled(l.owner!.title),
                ),
            ],
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.done),
        ),
      ],
    );
  }
}

/// On a note's page: the items it is linked into.
class LinkedIntoRow extends ConsumerWidget {
  const LinkedIntoRow({super.key, required this.note, required this.onOpen});

  final Node note;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final into = ref.watch(linkedIntoProvider(note.id)).value ?? const [];
    if (into.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(l10n.linkedInto(into.length)),
          for (final n in into)
            ActionChip(
              visualDensity: VisualDensity.compact,
              avatar: const Icon(Icons.link, size: 16),
              label: Text(l10n.titleOrUntitled(n.title)),
              onPressed: () => onOpen(n.id),
            ),
        ],
      ),
    );
  }
}

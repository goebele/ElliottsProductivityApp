import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/node_repository.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'autosave_field.dart';
import 'child_views.dart';
import 'done_button.dart';
import 'labels.dart';
import 'node_add_ons.dart';
import 'linked_notes.dart';
import 'markdown.dart';
import 'notes_column.dart';
import 'removal.dart';
import 'tree_pane.dart';
import 'tree_providers.dart';

/// Everything about one node: breadcrumbs, title, type, status, note and its
/// children in its child view (DESIGN.md §6.1, §6.13).
class NodeDetail extends ConsumerWidget {
  const NodeDetail({
    super.key,
    required this.nodeId,
    required this.onOpen,
    required this.onLeave,
  });

  final String nodeId;
  final OpenNode onOpen;

  /// Called after the node is archived or trashed from its page, with its
  /// parent, so the page can move away.
  final void Function(String? parentId) onLeave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return switch (ref.watch(nodeProvider(nodeId))) {
      AsyncData(value: final Node node) => _Detail(
        // Fresh text fields per node, so edits never leak across nodes.
        key: ValueKey(node.id),
        node: node,
        onOpen: onOpen,
        onLeave: onLeave,
      ),
      AsyncData() => Center(child: Text(l10n.itemNotFound)),
      AsyncError(:final error) => Center(child: Text('$error')),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _Detail extends ConsumerStatefulWidget {
  const _Detail({
    super.key,
    required this.node,
    required this.onOpen,
    required this.onLeave,
  });

  final Node node;
  final OpenNode onOpen;
  final void Function(String? parentId) onLeave;

  @override
  ConsumerState<_Detail> createState() => _DetailState();
}

class _DetailState extends ConsumerState<_Detail> {
  /// The description is optional. Its editor opens from "+ Description" or by
  /// clicking the text, and closes with its ✕ or Esc; while closed, a
  /// non-empty description shows as read-only text.
  bool _editingDescription = false;

  /// A note opens formatted and read-only, with Edit; a new (empty) note
  /// opens in its editor. Save goes back to the formatted view.
  late bool _editingNote = widget.node.bodyMd.isEmpty;
  final _noteEditor = GlobalKey<MarkdownEditorState>();

  /// The text Save just showed, until the saved copy comes back from the
  /// database (so the view never flashes the old text).
  String? _savedNote;

  void _saveNote() => setState(() {
    _savedNote = _noteEditor.currentState?.text;
    _editingNote = false;
  });

  /// From this width the notes column sits beside the item; narrower, notes
  /// are a collapsed section at the bottom.
  static const _sideColumnWidth = 900.0;

  Future<NodeRepository> _repo(WidgetRef ref) =>
      ref.read(nodeRepositoryProvider.future);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final side = constraints.maxWidth >= _sideColumnWidth;
      final node = widget.node;
      final main = _main(context, sideColumn: side);
      if (node.type == NodeType.note ||
          !side ||
          !ref.watch(notesColumnOpenProvider)) {
        return main;
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: main),
          const VerticalDivider(width: 1),
          SizedBox(
            width: 300,
            child: NotesColumn(parentId: node.id, onOpen: widget.onOpen),
          ),
        ],
      );
    },
  );

  /// The item this note was opened from, if it was opened from an item it
  /// is linked into.
  String? _openedFromLink(Node node) {
    final via = ref.watch(openedViaProvider);
    return via != null && via.link && via.nodeId == node.id
        ? via.parentId
        : null;
  }

  /// The formatted note; clicking it edits.
  Widget _noteView(Node node, AppLocalizations l10n, ThemeData theme) {
    final saved = _savedNote;
    final body = saved != null && saved != node.bodyMd ? saved : node.bodyMd;
    return Tooltip(
      message: l10n.noteEdit,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () => setState(() => _editingNote = true),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: body.trim().isEmpty
              ? Text(
                  l10n.noteEmpty,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              : MarkdownView(body),
        ),
      ),
    );
  }

  Widget _main(BuildContext context, {required bool sideColumn}) {
    final node = widget.node;
    final onOpen = widget.onOpen;
    final isNote = node.type == NodeType.note;
    final descriptionShown = _editingDescription || node.bodyMd.isNotEmpty;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        if (node.lifecycle != Lifecycle.live) RemovedBanner(node: node),
        Row(
          children: [
            Expanded(
              child: _Breadcrumbs(nodeId: node.id, onOpen: onOpen),
            ),
            if (!isNote && sideColumn) NotesToggle(parentId: node.id),
          ],
        ),
        if (isNote) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              // Takes the room left by Edit/Save; a long title is cut short.
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  // Opened from an item it is linked into: back there.
                  child: switch (_openedFromLink(node) ?? node.parentId) {
                    final back? => _BackToParent(
                      parentId: back,
                      onBack: () => widget.onLeave(back),
                    ),
                    null => null,
                  },
                ),
              ),
              if (node.parentId != null)
                IconButton(
                  tooltip: node.sharedWithChildren
                      ? l10n.stopSharing
                      : l10n.shareWithAll,
                  isSelected: node.sharedWithChildren,
                  icon: const Icon(Icons.push_pin_outlined),
                  selectedIcon: const Icon(Icons.push_pin),
                  onPressed: () async =>
                      (await _repo(ref))
                          .setNoteShared(node.id, !node.sharedWithChildren),
                ),
              if (_editingNote)
                FilledButton.icon(
                  icon: const Icon(Icons.check),
                  label: Text(l10n.noteSave),
                  onPressed: _saveNote,
                )
              else
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l10n.noteEdit),
                  onPressed: () => setState(() => _editingNote = true),
                ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AutosaveField(
                value: node.title,
                autofocus: node.title.isEmpty,
                style: theme.textTheme.headlineSmall?.copyWith(
                  decoration: isFinished(node.status) && !isNote
                      ? TextDecoration.lineThrough
                      : null,
                ),
                decoration: InputDecoration(
                  hintText: l10n.titleHint,
                  border: InputBorder.none,
                ),
                onSave: (title) async =>
                    (await _repo(ref)).rename(node.id, title),
              ),
            ),
            if (!isNote) ...[
              StatusMenuButton(node: node),
              const SizedBox(width: 24),
              DoneButton(node: node),
            ],
            NodeMenu(node: node, onLeave: widget.onLeave),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            DropdownMenu<NodeType>(
              key: ValueKey(node.type),
              label: Text(l10n.fieldType),
              initialSelection: node.type,
              leadingIcon: Icon(nodeTypeIcon(node.type)),
              dropdownMenuEntries: [
                for (final t in NodeType.values)
                  DropdownMenuEntry(
                    value: t,
                    label: l10n.nodeType(t),
                    leadingIcon: Icon(nodeTypeIcon(t)),
                  ),
              ],
              onSelected: (t) async {
                if (t != null && t != node.type) {
                  await (await _repo(ref)).setType(node.id, t);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isNote)
          // A note is its text: always shown, nothing else to add.
          _editingNote
              ? CallbackShortcuts(
                  bindings: {
                    const SingleActivator(LogicalKeyboardKey.escape): _saveNote,
                  },
                  child: MarkdownEditor(
                    key: _noteEditor,
                    value: node.bodyMd,
                    minLines: 10,
                    autofocus: node.title.isNotEmpty,
                    hint: l10n.noteBodyHint,
                    onSave: (body) async =>
                        (await _repo(ref)).setBody(node.id, body),
                  ),
                )
              : _noteView(node, l10n, theme),
        if (isNote)
          LinkedIntoRow(note: node, onOpen: onOpen)
        else ...[
          NodeAddOns(
            node: node,
            descriptionShown: descriptionShown,
            onAddDescription: () => setState(() => _editingDescription = true),
          ),
          if (_editingDescription) ...[
            const SizedBox(height: 16),
            CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.escape): () =>
                    setState(() => _editingDescription = false),
              },
              child: MarkdownEditor(
                value: node.bodyMd,
                autofocus: true,
                hint: l10n.descriptionHint,
                onSave: (body) async =>
                    (await _repo(ref)).setBody(node.id, body),
                trailing: IconButton(
                  tooltip: l10n.closeDescription,
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _editingDescription = false),
                ),
              ),
            ),
          ] else if (node.bodyMd.isNotEmpty) ...[
            const SizedBox(height: 16),
            Tooltip(
              message: l10n.editDescription,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () => setState(() => _editingDescription = true),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: MarkdownView(node.bodyMd),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          ChildrenSection(parent: node, onOpen: onOpen),
          if (!sideColumn) ...[
            const SizedBox(height: 16),
            NotesSection(parentId: node.id, onOpen: onOpen),
          ],
        ],
      ],
    );
  }
}

class _Breadcrumbs extends ConsumerWidget {
  const _Breadcrumbs({required this.nodeId, required this.onOpen});

  final String nodeId;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ancestors = ref.watch(ancestorsProvider(nodeId)).value ?? const [];
    final via = ref.watch(openedViaProvider);
    final viaParent = via != null && via.nodeId == nodeId
        ? ref.watch(nodeProvider(via.parentId)).value
        : null;
    if (ancestors.isEmpty && viaParent == null) {
      return const SizedBox(height: 24);
    }

    final theme = Theme.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Opened through a shortcut: the real path, plus where you came from.
        if (viaParent != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              visualDensity: VisualDensity.compact,
              avatar: Icon(via!.link ? Icons.link : Icons.north_east, size: 16),
              label: Text(
                l10n.viaShortcut(l10n.titleOrUntitled(viaParent.title)),
              ),
              onPressed: () => onOpen(viaParent.id),
            ),
          ),
        for (final a in ancestors) ...[
          InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () => onOpen(a.id),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                l10n.titleOrUntitled(a.title),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ],
    );
  }
}

/// "← Back to Trip": from a note to the item it belongs to.
class _BackToParent extends ConsumerWidget {
  const _BackToParent({required this.parentId, required this.onBack});

  final String parentId;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final parent = ref.watch(nodeProvider(parentId)).value;
    return TextButton.icon(
      icon: const Icon(Icons.arrow_back),
      label: Text(
        l10n.backTo(l10n.titleOrUntitled(parent?.title ?? '')),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      onPressed: onBack,
    );
  }
}

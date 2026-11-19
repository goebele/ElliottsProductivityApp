import 'dart:async';

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
import 'files.dart';
import 'labels.dart';
import 'node_add_ons.dart';
import 'linked_notes.dart';
import 'markdown.dart';
import 'node_links.dart';
import 'notes_column.dart';
import 'peek.dart';
import 'property_rows.dart';
import 'tags.dart';
import 'timer.dart';
import 'time_ui.dart';
import 'values.dart';
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

  /// The title as typed. An item without a title has its controls locked
  /// until it gets one (§6.1), so a fresh item is named before anything
  /// else happens to it (and "+" can't be tapped again and again).
  late final _titleController = TextEditingController(text: widget.node.title)
    ..addListener(_titleChanged);
  late bool _titled = widget.node.title.trim().isNotEmpty;

  void _titleChanged() {
    final titled = _titleController.text.trim().isNotEmpty;
    if (titled != _titled) setState(() => _titled = titled);
  }

  /// Kept for dispose, where context can't be used: leaving a blank item
  /// moves it to Trash, with Undo (§6.1).
  ScaffoldMessengerState? _messenger;
  Future<NodeRepository>? _repoFuture;
  late AppLocalizations _l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messenger = ScaffoldMessenger.maybeOf(context);
    _repoFuture ??= ref.read(nodeRepositoryProvider.future);
    _l10n = AppLocalizations.of(context);
  }

  Future<void> _dropIfBlank() async {
    final id = widget.node.id;
    final messenger = _messenger;
    final l10n = _l10n;
    try {
      final repo = await _repoFuture!;
      if (!await repo.isBlank(id)) return;
      await repo.trash(id);
      messenger
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            persist: false,
            content: Text(l10n.emptyItemRemoved),
            action: SnackBarAction(
              label: l10n.undo,
              onPressed: () => repo.restore(id),
            ),
          ),
        );
    } catch (_) {
      // The app is closing (the database is gone): nothing to tidy.
    }
  }

  @override
  void dispose() {
    if (_titleController.text.trim().isEmpty) unawaited(_dropIfBlank());
    _titleController.removeListener(_titleChanged);
    super.dispose();
    // AutosaveField saves on dispose with this controller; drop it after.
    _titleController.dispose();
  }

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
  Widget build(BuildContext context) => FileDropZone(
    nodeId: widget.node.id,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final node = widget.node;
        final isNote = node.type == NodeType.note;
        final side = !isNote && constraints.maxWidth >= _sideColumnWidth;
        const pad = EdgeInsets.fromLTRB(24, 8, 24, 32);
        final header = _header(context);
        if (isNote) {
          return ListView(
            padding: pad,
            children: [...header, ..._noteBody(context)],
          );
        }
        final body = _Locked(
          locked: !_titled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _itemBody(context, sideColumn: side),
          ),
        );
        // Narrow: one scrolling page, notes at the bottom.
        if (!side) {
          return ListView(padding: pad, children: [...header, body]);
        }
        // Wide: the title across the top; below it the item on the left and
        // its notes and files on the right (§6.1).
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: header,
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                      children: [body],
                    ),
                  ),
                  _Locked(
                    locked: !_titled,
                    child: _NotesPanel(
                      parentId: node.id,
                      onOpen: widget.onOpen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  /// The item this note was opened from, if it was opened from an item it
  /// is linked into.
  String? _openedFromLink(Node node) {
    final via = ref.watch(openedViaProvider);
    return via != null && via.link && via.nodeId == node.id
        ? via.parentId
        : null;
  }

  /// A link in the text to another item or note: open it, with Back
  /// returning here.
  void _openLinked(String id) {
    ref
        .read(openedViaProvider.notifier)
        .opening(id, viaParent: widget.node.id, link: true);
    widget.onOpen(id);
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
              : MarkdownView(body, onOpenNode: _openLinked),
        ),
      ),
    );
  }

  /// Breadcrumbs (a note's bar), the title with its status, and the lock
  /// hint for an untitled item.
  List<Widget> _header(BuildContext context) {
    final node = widget.node;
    final onOpen = widget.onOpen;
    final isNote = node.type == NodeType.note;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final title = AutosaveField(
      value: node.title,
      controller: _titleController,
      autofocus: node.title.isEmpty,
      style: theme.textTheme.headlineSmall?.copyWith(
        decoration: isFinished(node.status) && !isNote
            ? TextDecoration.lineThrough
            : null,
      ),
      decoration: InputDecoration(
        hintText: l10n.titleHint,
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
      onSave: (title) async => (await _repo(ref)).rename(node.id, title),
    );
    return [
      if (node.lifecycle != Lifecycle.live) RemovedBanner(node: node),
      _Breadcrumbs(nodeId: node.id, onOpen: onOpen),
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
        const SizedBox(height: 4),
      ],
      // The title, then its status as a chip right after it; ⋮ at the end.
      Row(
        children: [
          if (isNote)
            Expanded(child: title)
          else
            // The title is the only flexible thing in here, so it can use
            // all the room up to the chip (a Spacer beside it would take
            // half).
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 120),
                      child: IntrinsicWidth(child: title),
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(node: node),
                ],
              ),
            ),
          NodeMenu(node: node, onLeave: widget.onLeave),
        ],
      ),
      if (!isNote)
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          child: _titled
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          l10n.titleFirst,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      const SizedBox(height: 8),
    ];
  }

  /// A note: its tags, its text, and where it's linked.
  List<Widget> _noteBody(BuildContext context) {
    final node = widget.node;
    final onOpen = widget.onOpen;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return [
      TagChips(node: node),
      const SizedBox(height: 16),
      // A note is its text: always shown, nothing else to add.
      if (_editingNote)
        CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.escape): _saveNote,
          },
          child: MarkdownEditor(
            key: _noteEditor,
            value: node.bodyMd,
            minLines: 10,
            autofocus: node.title.isNotEmpty,
            hint: l10n.noteBodyHint,
            onSave: (body) async => (await _repo(ref)).setBody(node.id, body),
          ),
        )
      else
        _noteView(node, l10n, theme),
      LinkedIntoRow(note: node, onOpen: onOpen),
      LinkedFromRow(nodeId: node.id, onOpen: onOpen),
    ];
  }

  /// An item, below its title: labelled rows (tags and value, when, time,
  /// description), progress, then its items; notes at the bottom when
  /// there's no room beside (§6.1). Locked while it has no title.
  List<Widget> _itemBody(BuildContext context, {required bool sideColumn}) {
    final node = widget.node;
    final onOpen = widget.onOpen;
    final l10n = AppLocalizations.of(context);
    void editDescription() => setState(() => _editingDescription = true);
    return [
      PropertyRow(
        label: l10n.rowTags,
        child: TagChips(node: node, addAsIcon: true),
      ),
      // Values can be long: a row of their own.
      PropertyRow(
        label: l10n.rowValue,
        child: ValueChips(node: node, onOpen: onOpen),
      ),
      PropertyRow(
        label: l10n.rowWhen,
        child: NodeAddOns(node: node),
      ),
      PropertyRow(
        label: l10n.rowTime,
        child: TimeChips(
          node: node,
          trailing: [TimerButton(node: node)],
        ),
      ),
      PropertyRow(
        label: l10n.rowDescription,
        child: _editingDescription
            ? CallbackShortcuts(
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
                    onPressed: () =>
                        setState(() => _editingDescription = false),
                  ),
                ),
              )
            : node.bodyMd.isNotEmpty
            ? Tooltip(
                message: l10n.editDescription,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: editDescription,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    child: MarkdownView(node.bodyMd, onOpenNode: _openLinked),
                  ),
                ),
              )
            : RowPlaceholder(
                text: l10n.descriptionPlaceholder,
                onTap: editDescription,
              ),
      ),
      ProgressRow(node: node),
      LinkedFromRow(nodeId: node.id, onOpen: onOpen),
      const SizedBox(height: 20),
      ChildrenSection(parent: node, onOpen: onOpen),
      if (!sideColumn) ...[
        const SizedBox(height: 16),
        NotesSection(parentId: node.id, onOpen: onOpen),
      ],
    ];
  }
}

/// The notes and files column on the right of a wide item page, below its
/// title. Collapses to a thin strip that still shows how many there are.
class _NotesPanel extends ConsumerWidget {
  const _NotesPanel({required this.parentId, required this.onOpen});

  final String parentId;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final open = ref.watch(notesColumnOpenProvider);
    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      alignment: AlignmentDirectional.centerEnd,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VerticalDivider(width: 1),
          if (open)
            SizedBox(
              width: 300,
              child: NotesColumn(parentId: parentId, onOpen: onOpen),
            )
          else
            NotesStrip(parentId: parentId),
        ],
      ),
    );
  }
}

/// Greys out and disables its child while [locked], fading between.
class _Locked extends StatelessWidget {
  const _Locked({required this.locked, required this.child});

  final bool locked;
  final Widget child;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    ignoring: locked,
    child: ExcludeFocus(
      excluding: locked,
      child: AnimatedOpacity(
        opacity: locked ? 0.35 : 1,
        duration: const Duration(milliseconds: 180),
        child: child,
      ),
    ),
  );
}

class _Breadcrumbs extends ConsumerStatefulWidget {
  const _Breadcrumbs({required this.nodeId, required this.onOpen});

  final String nodeId;
  final OpenNode onOpen;

  /// Narrower than this, a long path shows its first and last levels with
  /// "…" between; tapping "…" shows the rest.
  static const collapseWidth = 600.0;

  @override
  ConsumerState<_Breadcrumbs> createState() => _BreadcrumbsState();
}

class _BreadcrumbsState extends ConsumerState<_Breadcrumbs> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final nodeId = widget.nodeId;
    final onOpen = widget.onOpen;
    final ancestors = ref.watch(ancestorsProvider(nodeId)).value ?? const [];
    final via = ref.watch(openedViaProvider);
    final viaParent = via != null && via.nodeId == nodeId
        ? ref.watch(nodeProvider(via.parentId)).value
        : null;
    if (ancestors.isEmpty && viaParent == null) {
      return const SizedBox(height: 24);
    }

    final theme = Theme.of(context);
    final chevron = Icon(
      Icons.chevron_right,
      size: 16,
      color: theme.colorScheme.onSurfaceVariant,
    );
    Widget crumb(Node a) => PeekTarget(
      nodeId: a.id,
      onOpen: onOpen,
      child: InkWell(
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
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final collapse =
            !_expanded &&
            ancestors.length > 2 &&
            constraints.maxWidth < _Breadcrumbs.collapseWidth;
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Opened through a shortcut: the real path, plus where you came
            // from.
            if (viaParent != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  visualDensity: VisualDensity.compact,
                  avatar: Icon(
                    via!.link ? Icons.link : Icons.north_east,
                    size: 16,
                  ),
                  label: Text(
                    l10n.viaShortcut(l10n.titleOrUntitled(viaParent.title)),
                  ),
                  onPressed: () => onOpen(viaParent.id),
                ),
              ),
            if (collapse) ...[
              crumb(ancestors.first),
              chevron,
              Tooltip(
                message: l10n.breadcrumbsShowAll,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () => setState(() => _expanded = true),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    child: Text('…', style: theme.textTheme.bodySmall),
                  ),
                ),
              ),
              chevron,
              crumb(ancestors.last),
              chevron,
            ] else
              for (final a in ancestors) ...[crumb(a), chevron],
          ],
        );
      },
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

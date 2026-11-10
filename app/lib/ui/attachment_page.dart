import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../data/database.dart';
import '../domain/attachment_repository.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'files.dart';
import 'labels.dart';
import 'markdown.dart';
import 'markup.dart';
import 'tree_pane.dart';
import 'tree_providers.dart';

/// One attachment (DESIGN.md §6.4): images (zoom, pan, markup), text files
/// (formatted `.md`, highlights), and a file card for everything else.
/// Open in…, Replace file, Export with markup and Remove are on the page.
class AttachmentPage extends ConsumerStatefulWidget {
  const AttachmentPage({
    super.key,
    required this.attachmentId,
    required this.onOpen,
    required this.onBack,
    this.via,
  });

  final String attachmentId;
  final OpenNode onOpen;

  /// Goes back to [nodeId] (the owner, or the item it was opened from).
  final void Function(String nodeId) onBack;

  /// The item it was opened from, when that isn't the owner.
  final String? via;

  @override
  ConsumerState<AttachmentPage> createState() => _AttachmentPageState();
}

class _AttachmentPageState extends ConsumerState<AttachmentPage> {
  bool _editing = false;
  bool _showMarkup = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final a = ref.watch(attachmentProvider(widget.attachmentId)).value;
    if (a == null) return const Center(child: CircularProgressIndicator());
    final back = widget.via ?? a.nodeId;
    final backNode = ref.watch(nodeProvider(back)).value;
    final markable =
        a.kind == AttachmentKind.image || a.kind == AttachmentKind.text;
    final isMd = a.mime == 'text/markdown';
    final marks = ref.watch(annotationsProvider(a.id)).value ?? const [];
    final linkedInto =
        ref.watch(fileLinkedIntoProvider(a.id)).value ?? const [];

    final body = switch (a.kind) {
      AttachmentKind.image => ImageMarkupView(
        attachment: a,
        editing: _editing,
        showMarkup: _showMarkup,
      ),
      AttachmentKind.text => TextMarkupView(
        attachment: a,
        editing: _editing,
        showMarkup: _showMarkup,
        formatted: isMd ? (text) => MarkdownView(text) : null,
      ),
      _ => _FileCard(attachment: a),
    };

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            _editing ? setState(() => _editing = false) : widget.onBack(back),
      },
      child: Focus(
        autofocus: true,
        child: ListView(
          // While marking up, drags draw: the page mustn't take vertical
          // ones as scrolling.
          physics: _editing ? const NeverScrollableScrollPhysics() : null,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: Text(
                        l10n.backTo(
                          l10n.titleOrUntitled(backNode?.title ?? ''),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      onPressed: () => widget.onBack(back),
                    ),
                  ),
                ),
                if (markable && !_editing && marks.isNotEmpty)
                  IconButton(
                    tooltip: _showMarkup ? l10n.markupHide : l10n.markupShow,
                    isSelected: _showMarkup,
                    icon: const Icon(Icons.layers_outlined),
                    selectedIcon: const Icon(Icons.layers),
                    onPressed: () => setState(() => _showMarkup = !_showMarkup),
                  ),
                if (markable)
                  _editing
                      ? FilledButton.icon(
                          icon: const Icon(Icons.check),
                          label: Text(l10n.markupDone),
                          onPressed: () => setState(() => _editing = false),
                        )
                      : FilledButton.tonalIcon(
                          icon: const Icon(Icons.draw_outlined),
                          label: Text(l10n.markup),
                          onPressed: () => setState(() {
                            _editing = true;
                            _showMarkup = true;
                          }),
                        ),
                _AttachmentMenu(
                  attachment: a,
                  onRemoved: () => widget.onBack(back),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(attachmentIcon(a.kind)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(a.filename, style: theme.textTheme.titleLarge),
                ),
              ],
            ),
            Text(
              [
                formatBytes(a.sizeBytes),
                if (a.width != null) '${a.width} × ${a.height}',
                if (a.nodeId != back && backNode != null)
                  l10n.fileOwnedBy(
                    l10n.titleOrUntitled(
                      ref.watch(nodeProvider(a.nodeId)).value?.title ?? '',
                    ),
                  ),
              ].join(' · '),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            body,
            if (linkedInto.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(l10n.linkedInto(linkedInto.length)),
                    for (final n in linkedInto)
                      ActionChip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.link, size: 16),
                        label: Text(l10n.titleOrUntitled(n.title)),
                        onPressed: () => widget.onOpen(n.id),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// For PDFs and other files: name, type and Open in….
class _FileCard extends ConsumerWidget {
  const _FileCard({required this.attachment});

  final Attachment attachment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(attachmentIcon(attachment.kind), size: 64),
            const SizedBox(height: 12),
            Text(attachment.filename, style: theme.textTheme.titleMedium),
            Text(
              '${p.extension(attachment.filename).replaceFirst('.', '').toUpperCase()} · ${formatBytes(attachment.sizeBytes)}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.open_in_new),
              label: Text(l10n.fileOpenIn),
              onPressed: () => openInDefaultApp(context, ref, attachment),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.fileOpenInNote,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// ⋮ on an attachment: Open in…, Replace file, Export with markup, Rename,
/// Remove (with Undo).
class _AttachmentMenu extends ConsumerWidget {
  const _AttachmentMenu({required this.attachment, required this.onRemoved});

  final Attachment attachment;
  final VoidCallback onRemoved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final a = attachment;
    Future<AttachmentRepository> repo() async =>
        (await ref.read(nodeRepositoryProvider.future)).files;

    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.open_in_new),
          onPressed: () => openInDefaultApp(context, ref, a),
          child: Text(l10n.fileOpenIn),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.upload_file),
          onPressed: () async {
            final picked = await FilePicker.pickFiles();
            if (picked.isEmpty) return;
            final f = picked.first.xFile;
            final bytes = await f.readAsBytes();
            final dims = await imageSize(bytes);
            await (await repo()).replace(
              a.id,
              filename: f.name,
              open: () => Stream.value(bytes),
              width: dims?.$1,
              height: dims?.$2,
            );
          },
          child: Text(l10n.fileReplace),
        ),
        if (a.kind == AttachmentKind.image)
          MenuItemButton(
            leadingIcon: const Icon(Icons.ios_share),
            onPressed: () async {
              final png = await flattenImage(ref, a);
              if (png == null || !context.mounted) return;
              await saveBytesAs(
                context,
                '${p.basenameWithoutExtension(a.filename)} (marked up).png',
                png,
                'image/png',
              );
            },
            child: Text(l10n.fileExportMarkup),
          ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.drive_file_rename_outline),
          onPressed: () async {
            final controller = TextEditingController(text: a.filename);
            final name = await showDialog<String>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(l10n.fileRename),
                content: TextField(
                  controller: controller,
                  autofocus: true,
                  onSubmitted: (v) => Navigator.pop(context, v),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      MaterialLocalizations.of(context).cancelButtonLabel,
                    ),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, controller.text),
                    child: Text(l10n.save),
                  ),
                ],
              ),
            );
            controller.dispose();
            if (name != null && name.trim().isNotEmpty) {
              await (await repo()).rename(a.id, name.trim());
            }
          },
          child: Text(l10n.fileRename),
        ),
        const Divider(height: 1),
        MenuItemButton(
          leadingIcon: const Icon(Icons.delete_outline),
          onPressed: () async {
            final messenger = ScaffoldMessenger.maybeOf(context);
            final files = await repo();
            await files.remove(a.id);
            onRemoved();
            messenger
              ?..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(l10n.fileRemoved(a.filename)),
                  action: SnackBarAction(
                    label: l10n.undo,
                    onPressed: () => files.restore(a.id),
                  ),
                ),
              );
          },
          child: Text(l10n.fileRemove),
        ),
      ],
      builder: (context, controller, _) => IconButton(
        tooltip: l10n.moreActions,
        icon: const Icon(Icons.more_vert),
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}

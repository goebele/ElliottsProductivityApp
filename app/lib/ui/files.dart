import 'dart:io';
import 'dart:ui' as ui;

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pasteboard/pasteboard.dart';

import '../data/blob_store.dart';
import '../data/database.dart';
import '../domain/attachment_repository.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';

/// Attachments (DESIGN.md §6.4): the Files list in the notes column, the
/// ways of adding files, and opening one.

final filesProvider = StreamProvider.family<List<Attachment>, String>((
  ref,
  nodeId,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.files.watchOf(nodeId);
});

final attachmentProvider = StreamProvider.family<Attachment?, String>((
  ref,
  id,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.files.watch(id);
});

final annotationsProvider = StreamProvider.family<List<Annotation>, String>((
  ref,
  id,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.files.watchAnnotations(id);
});

final linkedFilesProvider = StreamProvider.family<List<LinkedFile>, String>((
  ref,
  childId,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.files.watchLinked(childId);
});

final fileLinkedIntoProvider = StreamProvider.family<List<Node>, String>((
  ref,
  id,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.files.watchLinkedInto(id);
});

/// The ancestors' files, re-read whenever nodes or files change.
final ancestorFilesProvider =
    StreamProvider.family<List<(Node, List<Attachment>)>, String>((
      ref,
      childId,
    ) async* {
      final repo = await ref.watch(nodeRepositoryProvider.future);
      final db = ref.watch(databaseProvider);
      yield* db
          .customSelect(
            'SELECT 1 AS ancestor_files',
            readsFrom: {db.nodes, db.attachments},
          )
          .watch()
          .asyncMap((_) => repo.files.ancestorFiles(childId));
    });

/// Opens an attachment's page. [via] is the item it was opened from when
/// that isn't its owner (a linked file), so Back returns there.
typedef OpenAttachment = void Function(String attachmentId, {String? via});

/// Provides [OpenAttachment] to everything below (the wide layout shows the
/// page in the detail pane; phones push it).
class AttachmentOpener extends InheritedWidget {
  const AttachmentOpener({super.key, required this.open, required super.child});

  final OpenAttachment open;

  static OpenAttachment of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AttachmentOpener>()?.open ??
      (_, {via}) {};

  @override
  bool updateShouldNotify(AttachmentOpener old) => old.open != open;
}

bool get _isWindows => defaultTargetPlatform == TargetPlatform.windows;
bool get _isPhone =>
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

/// "2.4 MB".
String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  final kb = bytes / 1024;
  if (kb < 1024) return '${kb.toStringAsFixed(kb < 10 ? 1 : 0)} KB';
  final mb = kb / 1024;
  return '${mb.toStringAsFixed(mb < 10 ? 1 : 0)} MB';
}

IconData attachmentIcon(AttachmentKind kind) => switch (kind) {
  AttachmentKind.image => Icons.image_outlined,
  AttachmentKind.text => Icons.description_outlined,
  AttachmentKind.pdf => Icons.picture_as_pdf_outlined,
  AttachmentKind.other => Icons.insert_drive_file_outlined,
};

/// Width and height of an encoded image, without decoding all of it.
Future<(int, int)?> imageSize(Uint8List bytes) async {
  try {
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final size = (descriptor.width, descriptor.height);
    descriptor.dispose();
    buffer.dispose();
    return size;
  } catch (_) {
    return null;
  }
}

/// Attaches [files] to [nodeId]: files over the soft cap ask first. Shows
/// "Attached …" with Undo.
Future<void> attachFiles(
  BuildContext context,
  WidgetRef ref,
  String nodeId,
  List<XFile> files,
) async {
  if (files.isEmpty) return;
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.maybeOf(context);
  final repo = (await ref.read(nodeRepositoryProvider.future)).files;
  final added = <String>[];
  for (final f in files) {
    final size = await f.length();
    if (size > BlobStore.softCapBytes) {
      if (!context.mounted) return;
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.fileTooBigTitle),
          content: Text(l10n.fileTooBigBody(f.name, formatBytes(size))),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.fileSkip),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.fileAttachAnyway),
            ),
          ],
        ),
      );
      if (ok != true) continue;
    }
    final type = AttachmentRepository.kindOf(f.name);
    (int, int)? dims;
    if (type.kind == AttachmentKind.image) {
      dims = await imageSize(await f.readAsBytes());
    }
    added.add(
      await repo.add(
        nodeId,
        filename: f.name,
        open: f.openRead,
        width: dims?.$1,
        height: dims?.$2,
      ),
    );
  }
  if (added.isEmpty) return;
  messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          added.length == 1
              ? l10n.fileAttached(files.first.name)
              : l10n.filesAttached(added.length),
        ),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () async {
            for (final id in added) {
              await repo.remove(id);
            }
          },
        ),
      ),
    );
}

Future<void> pickAndAttach(
  BuildContext context,
  WidgetRef ref,
  String nodeId,
) async {
  final picked = await FilePicker.pickFiles();
  if (!context.mounted) return;
  await attachFiles(context, ref, nodeId, [for (final f in picked) f.xFile]);
}

/// Phones: take a photo (downscaled to 2560 px, §6.4) and attach it.
Future<void> photoAndAttach(
  BuildContext context,
  WidgetRef ref,
  String nodeId,
) async {
  final photo = await ImagePicker().pickImage(
    source: ImageSource.camera,
    maxWidth: 2560,
    maxHeight: 2560,
    imageQuality: 85,
  );
  if (photo == null || !context.mounted) return;
  await attachFiles(context, ref, nodeId, [photo]);
}

/// Windows: attaches the image on the clipboard, if there is one. Returns
/// whether there was.
Future<bool> pasteAndAttach(
  BuildContext context,
  WidgetRef ref,
  String nodeId,
) async {
  final bytes = await Pasteboard.image;
  if (bytes == null || !context.mounted) return false;
  final stamp = DateFormat('yyyy-MM-dd HH.mm.ss').format(DateTime.now());
  await attachFiles(context, ref, nodeId, [
    XFile.fromData(
      bytes,
      name: 'Pasted image $stamp.png',
      mimeType: 'image/png',
    ),
  ]);
  return true;
}

/// Lets files be dropped onto [child] (Windows) and screenshots pasted with
/// Ctrl+V while no text field has focus, attaching them to [nodeId].
class FileDropZone extends ConsumerStatefulWidget {
  const FileDropZone({super.key, required this.nodeId, required this.child});

  final String nodeId;
  final Widget child;

  @override
  ConsumerState<FileDropZone> createState() => _FileDropZoneState();
}

class _FileDropZoneState extends ConsumerState<FileDropZone> {
  bool _over = false;

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final paste =
        event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.keyV &&
        HardwareKeyboard.instance.isControlPressed;
    if (!paste) return KeyEventResult.ignored;
    // In a text field, Ctrl+V pastes text as usual.
    final focused = FocusManager.instance.primaryFocus?.context;
    if (focused == null ||
        focused.widget is EditableText ||
        focused.findAncestorWidgetOfExactType<EditableText>() != null) {
      return KeyEventResult.ignored;
    }
    pasteAndAttach(context, ref, widget.nodeId);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    if (!_isWindows) return widget.child;
    return Focus(
      onKeyEvent: _onKey,
      child: DropTarget(
        onDragEntered: (_) => setState(() => _over = true),
        onDragExited: (_) => setState(() => _over = false),
        onDragDone: (d) {
          setState(() => _over = false);
          attachFiles(context, ref, widget.nodeId, d.files);
        },
        child: Stack(
          children: [
            widget.child,
            if (_over)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.85,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.fileDropHere,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// "Files (n)  [+ Add]" and the files: thumbnails for images, rows for the
/// rest. Clicking one opens its page.
class FilesList extends ConsumerWidget {
  const FilesList({super.key, required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final files = ref.watch(filesProvider(nodeId)).value ?? const [];
    final open = AttachmentOpener.of(context);
    final images = [
      for (final f in files)
        if (f.kind == AttachmentKind.image) f,
    ];
    final others = [
      for (final f in files)
        if (f.kind != AttachmentKind.image) f,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.filesHeading(files.length),
                style: theme.textTheme.titleSmall,
              ),
            ),
            MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  leadingIcon: const Icon(Icons.attach_file),
                  onPressed: () => pickAndAttach(context, ref, nodeId),
                  child: Text(l10n.fileChoose),
                ),
                if (_isPhone)
                  MenuItemButton(
                    leadingIcon: const Icon(Icons.photo_camera_outlined),
                    onPressed: () => photoAndAttach(context, ref, nodeId),
                    child: Text(l10n.fileTakePhoto),
                  ),
                if (_isWindows)
                  MenuItemButton(
                    leadingIcon: const Icon(Icons.content_paste),
                    onPressed: () async {
                      if (!await pasteAndAttach(context, ref, nodeId) &&
                          context.mounted) {
                        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                          SnackBar(content: Text(l10n.fileNoImageToPaste)),
                        );
                      }
                    },
                    child: Text(l10n.filePasteImage),
                  ),
              ],
              builder: (context, controller, _) => TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l10n.fileAdd),
                onPressed: () =>
                    controller.isOpen ? controller.close() : controller.open(),
              ),
            ),
          ],
        ),
        if (files.isEmpty)
          Text(
            _isWindows ? l10n.filesEmptyDesktop : l10n.filesEmpty,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        if (images.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final f in images)
                  Thumbnail(attachment: f, onTap: () => open(f.id)),
              ],
            ),
          ),
        for (final f in others) FileRow(attachment: f, onTap: () => open(f.id)),
      ],
    );
  }
}

/// A square image preview.
class Thumbnail extends ConsumerWidget {
  const Thumbnail({
    super.key,
    required this.attachment,
    required this.onTap,
    this.size = 72,
  });

  final Attachment attachment;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blobs = ref.watch(blobStoreProvider).value;
    final file = blobs?.fileFor(attachment.contentHash);
    return Tooltip(
      message: attachment.filename,
      child: Semantics(
        label: attachment.filename,
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox.square(
              dimension: size,
              child: file == null || !file.existsSync()
                  ? const Icon(Icons.broken_image_outlined)
                  : Image.file(
                      file,
                      fit: BoxFit.cover,
                      cacheWidth: (size * 2).round(),
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A file as a row: icon, name, size.
class FileRow extends StatelessWidget {
  const FileRow({
    super.key,
    required this.attachment,
    required this.onTap,
    this.trailing,
    this.subtitle,
  });

  final Attachment attachment;
  final VoidCallback onTap;
  final Widget? trailing;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 6),
    child: ListTile(
      dense: true,
      leading: Icon(attachmentIcon(attachment.kind)),
      title: Text(
        attachment.filename,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle ?? Text(formatBytes(attachment.sizeBytes)),
      trailing: trailing,
      onTap: onTap,
    ),
  );
}

/// Hands a temporary copy of the file to the default app (§6.4).
Future<void> openInDefaultApp(
  BuildContext context,
  WidgetRef ref,
  Attachment a,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.maybeOf(context);
  final blobs = await ref.read(blobStoreProvider.future);
  final copy = blobs.tempCopy(a.contentHash, a.filename, Directory.systemTemp);
  final result = await openFileExternally(copy.path, a.mime);
  if (!result) {
    messenger?.showSnackBar(SnackBar(content: Text(l10n.fileNoApp)));
  }
}

/// Opens [path] in its default app; false if nothing could open it.
/// Replaceable in tests, which have no platform apps.
Future<bool> Function(String path, String mime) openFileExternally = (
  path,
  mime,
) async => (await OpenFilex.open(path, type: mime)).type == ResultType.done;

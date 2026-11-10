import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../data/blob_store.dart';
import '../data/database.dart';
import '../sync/change_writer.dart';
import 'ids.dart';

/// A file from above, linked into an item (§6.10). [attachment] is null if
/// the file was removed; [owner] is the item it belongs to.
class LinkedFile {
  const LinkedFile(this.attachmentId, this.attachment, this.owner);
  final String attachmentId;
  final Attachment? attachment;
  final Node? owner;
}

/// What [AttachmentRepository.kindOf] decides from a file name.
typedef FileType = ({AttachmentKind kind, String mime});

/// Attachments and their markup (DESIGN.md §6.4).
class AttachmentRepository {
  AttachmentRepository(this._db, this._writer, this.blobs);

  final AppDatabase _db;
  final ChangeWriter _writer;
  final BlobStore blobs;

  static const _maxDepth = 1000;

  /// Text files bigger than this are searchable by name only.
  static const _maxIndexedText = 1024 * 1024;

  static const _types = <String, FileType>{
    '.png': (kind: AttachmentKind.image, mime: 'image/png'),
    '.jpg': (kind: AttachmentKind.image, mime: 'image/jpeg'),
    '.jpeg': (kind: AttachmentKind.image, mime: 'image/jpeg'),
    '.gif': (kind: AttachmentKind.image, mime: 'image/gif'),
    '.webp': (kind: AttachmentKind.image, mime: 'image/webp'),
    '.bmp': (kind: AttachmentKind.image, mime: 'image/bmp'),
    '.txt': (kind: AttachmentKind.text, mime: 'text/plain'),
    '.md': (kind: AttachmentKind.text, mime: 'text/markdown'),
    '.markdown': (kind: AttachmentKind.text, mime: 'text/markdown'),
    '.log': (kind: AttachmentKind.text, mime: 'text/plain'),
    '.csv': (kind: AttachmentKind.text, mime: 'text/csv'),
    '.pdf': (kind: AttachmentKind.pdf, mime: 'application/pdf'),
  };

  /// The kind and MIME type of [filename], by its extension.
  static FileType kindOf(String filename) =>
      _types[p.extension(filename).toLowerCase()] ??
      (kind: AttachmentKind.other, mime: 'application/octet-stream');

  // ---------------------------------------------------------------- reads

  Future<Attachment?> get(String id) => (_db.select(
    _db.attachments,
  )..where((a) => a.id.equals(id))).getSingleOrNull();

  Stream<Attachment?> watch(String id) => (_db.select(
    _db.attachments,
  )..where((a) => a.id.equals(id))).watchSingleOrNull();

  SimpleSelectStatement<$AttachmentsTable, Attachment> _ofQuery(
    String nodeId,
  ) => _db.select(_db.attachments)
    ..where((a) => a.nodeId.equals(nodeId) & a.deleted.equals(false))
    ..orderBy([
      (a) => OrderingTerm(expression: a.createdAt),
      (a) => OrderingTerm(expression: a.id),
    ]);

  /// [nodeId]'s files, oldest first.
  Future<List<Attachment>> of(String nodeId) => _ofQuery(nodeId).get();
  Stream<List<Attachment>> watchOf(String nodeId) => _ofQuery(nodeId).watch();

  /// The text of a text file (invalid UTF-8 is replaced, not refused).
  Future<String> textOf(Attachment a) async =>
      utf8.decode(await blobs.read(a.contentHash), allowMalformed: true);

  Future<Uint8List> bytesOf(Attachment a) => blobs.read(a.contentHash);

  // --------------------------------------------------------------- writes

  /// Attaches a file to [nodeId]. [open] reads it (it is copied into the
  /// blob store). Pass [width] and [height] for images. Returns the id.
  Future<String> add(
    String nodeId, {
    required String filename,
    required Stream<List<int>> Function() open,
    int? width,
    int? height,
  }) async {
    final owner = await (_db.select(
      _db.nodes,
    )..where((n) => n.id.equals(nodeId))).getSingle();
    final (:hash, :size) = await blobs.ingest(open);
    final type = kindOf(filename);
    final id = newId();
    await _writer.insert(
      _db.attachments,
      AttachmentsCompanion(
        id: Value(id),
        spaceId: Value(owner.spaceId),
        nodeId: Value(nodeId),
        contentHash: Value(hash),
        filename: Value(filename),
        mime: Value(type.mime),
        sizeBytes: Value(size),
        kind: Value(type.kind),
        width: Value(width),
        height: Value(height),
        deleted: const Value(false),
      ),
    );
    await _index(id);
    return id;
  }

  /// Imports a new version of the file ("Replace file"). Markup stays.
  Future<void> replace(
    String id, {
    required String filename,
    required Stream<List<int>> Function() open,
    int? width,
    int? height,
  }) async {
    final (:hash, :size) = await blobs.ingest(open);
    final type = kindOf(filename);
    await _writer.update(
      _db.attachments,
      id,
      AttachmentsCompanion(
        contentHash: Value(hash),
        filename: Value(filename),
        mime: Value(type.mime),
        sizeBytes: Value(size),
        kind: Value(type.kind),
        width: Value(width),
        height: Value(height),
      ),
    );
    await _index(id);
  }

  Future<void> rename(String id, String filename) async {
    await _writer.update(
      _db.attachments,
      id,
      AttachmentsCompanion(filename: Value(filename)),
    );
    await _index(id);
  }

  /// Removes a file (Undo: [restore]). The stored file stays until
  /// [collectGarbage] finds nothing uses it.
  Future<void> remove(String id) async {
    await _writer.update(
      _db.attachments,
      id,
      const AttachmentsCompanion(deleted: Value(true)),
    );
    await _index(id);
  }

  Future<void> restore(String id) async {
    await _writer.update(
      _db.attachments,
      id,
      const AttachmentsCompanion(deleted: Value(false)),
    );
    await _index(id);
  }

  /// Frees stored files that no attachment of a non-deleted item uses
  /// (archived and trashed items keep theirs until purged).
  Future<int> collectGarbage() async {
    final rows = await _db
        .customSelect(
          'SELECT DISTINCT a.content_hash AS h FROM attachments a '
          'JOIN nodes n ON n.id = a.node_id '
          'WHERE a.deleted = 0 AND n.deleted = 0',
          readsFrom: {_db.attachments, _db.nodes},
        )
        .get();
    return blobs.collect({for (final r in rows) r.read<String>('h')});
  }

  /// Keeps the search index in step with attachment [id].
  Future<void> _index(String id) async {
    await _db.customStatement(
      'DELETE FROM attachment_search WHERE attachment_id = ?',
      [id],
    );
    final a = await get(id);
    if (a == null || a.deleted) return;
    var content = '';
    if (a.kind == AttachmentKind.text &&
        a.sizeBytes <= _maxIndexedText &&
        blobs.has(a.contentHash)) {
      content = await textOf(a);
    }
    await _db.customStatement(
      'INSERT INTO attachment_search (attachment_id, filename, content) '
      'VALUES (?, ?, ?)',
      [id, a.filename, content],
    );
  }

  // ----------------------------------------------------------- annotations

  SimpleSelectStatement<$AnnotationsTable, Annotation> _marksQuery(
    String attachmentId,
  ) => _db.select(_db.annotations)
    ..where(
      (r) => r.attachmentId.equals(attachmentId) & r.deleted.equals(false),
    )
    ..orderBy([
      (r) => OrderingTerm(expression: r.z),
      (r) => OrderingTerm(expression: r.id),
    ]);

  Future<List<Annotation>> annotations(String attachmentId) =>
      _marksQuery(attachmentId).get();
  Stream<List<Annotation>> watchAnnotations(String attachmentId) =>
      _marksQuery(attachmentId).watch();

  /// Adds a stroke, highlight or label on top. Returns its id.
  Future<String> annotate(
    String attachmentId,
    AnnotationKind kind,
    Map<String, Object?> data, {
    required int color,
  }) async {
    final att = (await get(attachmentId))!;
    final top = (await annotations(attachmentId)).lastOrNull?.z ?? 0;
    final id = newId();
    await _writer.insert(
      _db.annotations,
      AnnotationsCompanion(
        id: Value(id),
        spaceId: Value(att.spaceId),
        attachmentId: Value(attachmentId),
        kind: Value(kind),
        dataJson: Value(jsonEncode(data)),
        color: Value(color),
        z: Value(top + 1),
        deleted: const Value(false),
      ),
    );
    return id;
  }

  /// Erases (or, with [deleted] false, brings back) one mark.
  Future<void> setAnnotationDeleted(String id, bool deleted) => _writer.update(
    _db.annotations,
    id,
    AnnotationsCompanion(deleted: Value(deleted)),
  );

  // ----------------------------------------------------------------- links

  /// Links [attachmentId] (an ancestor's file) into [childId] (§6.10).
  Future<void> link(String childId, String attachmentId) async {
    if (await _link(childId, attachmentId) != null) return;
    final child = (await (_db.select(
      _db.nodes,
    )..where((n) => n.id.equals(childId))).getSingle());
    await _writer.insert(
      _db.links,
      LinksCompanion(
        id: Value(newId()),
        spaceId: Value(child.spaceId),
        fromNodeId: Value(childId),
        targetKind: const Value(LinkKind.attachment),
        targetId: Value(attachmentId),
        origin: const Value(LinkOrigin.attached),
        deleted: const Value(false),
      ),
    );
  }

  Future<void> unlink(String childId, String attachmentId) async {
    final l = await _link(childId, attachmentId);
    if (l != null) {
      await _writer.update(
        _db.links,
        l.id,
        const LinksCompanion(deleted: Value(true)),
      );
    }
  }

  Future<Link?> _link(String childId, String attachmentId) =>
      (_db.select(_db.links)..where(
            (l) =>
                l.fromNodeId.equals(childId) &
                l.targetKind.equals(LinkKind.attachment.name) &
                l.targetId.equals(attachmentId) &
                l.deleted.equals(false),
          ))
          .getSingleOrNull();

  /// Files linked into [childId], in the order they were linked.
  Stream<List<LinkedFile>> watchLinked(String childId) =>
      (_db.select(_db.links)
            ..where(
              (l) =>
                  l.fromNodeId.equals(childId) &
                  l.targetKind.equals(LinkKind.attachment.name) &
                  l.deleted.equals(false),
            )
            ..orderBy([
              (l) => OrderingTerm(expression: l.createdAt),
              (l) => OrderingTerm(expression: l.id),
            ]))
          .watch()
          .asyncMap((links) async {
            final out = <LinkedFile>[];
            for (final l in links) {
              final a = await get(l.targetId!);
              final owner = a == null
                  ? null
                  : await (_db.select(
                      _db.nodes,
                    )..where((n) => n.id.equals(a.nodeId))).getSingleOrNull();
              out.add(
                LinkedFile(
                  l.targetId!,
                  a == null || a.deleted || owner == null || owner.deleted
                      ? null
                      : a,
                  owner,
                ),
              );
            }
            return out;
          });

  /// The live items that link [attachmentId].
  Stream<List<Node>> watchLinkedInto(String attachmentId) {
    final q =
        _db.select(_db.nodes).join([
          innerJoin(_db.links, _db.links.fromNodeId.equalsExp(_db.nodes.id)),
        ])..where(
          _db.links.targetKind.equals(LinkKind.attachment.name) &
              _db.links.targetId.equals(attachmentId) &
              _db.links.deleted.equals(false) &
              _db.nodes.deleted.equals(false) &
              _db.nodes.lifecycle.equals(Lifecycle.live.name),
        );
    return q.watch().map(
      (rows) => [for (final r in rows) r.readTable(_db.nodes)],
    );
  }

  /// The files of the items above [childId], nearest first; ancestors with
  /// no files are left out.
  Future<List<(Node, List<Attachment>)>> ancestorFiles(String childId) async {
    final out = <(Node, List<Attachment>)>[];
    var node = await (_db.select(
      _db.nodes,
    )..where((n) => n.id.equals(childId))).getSingleOrNull();
    for (var i = 0; i < _maxDepth && node?.parentId != null; i++) {
      final parent = await (_db.select(
        _db.nodes,
      )..where((n) => n.id.equals(node!.parentId!))).getSingleOrNull();
      if (parent == null || parent.deleted) break;
      final files = await of(parent.id);
      if (files.isNotEmpty) out.add((parent, files));
      node = parent;
    }
    return out;
  }
}

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

/// Attachment files, named by content hash (DESIGN.md §6.4, D9):
/// `<root>/ab/cd/<sha256>`. The same file attached twice is stored once.
/// Originals are only read, never moved or changed.
class BlobStore {
  BlobStore(this.root);

  /// Usually `<app support>/blobs`.
  final Directory root;

  /// A soft cap: bigger files ask first (§6.4).
  static const softCapBytes = 20 * 1024 * 1024;

  File fileFor(String hash) =>
      File(p.join(root.path, hash.substring(0, 2), hash.substring(2, 4), hash));

  bool has(String hash) => fileFor(hash).existsSync();

  /// Copies the bytes from [open] into the store. Returns the SHA-256 (hex)
  /// and the size.
  Future<({String hash, int size})> ingest(
    Stream<List<int>> Function() open,
  ) async {
    final tmpDir = Directory(p.join(root.path, 'tmp'));
    await tmpDir.create(recursive: true);
    final tmp = File(
      p.join(tmpDir.path, '${DateTime.now().microsecondsSinceEpoch}.part'),
    );
    final digest = _DigestSink();
    final hasher = sha256.startChunkedConversion(digest);
    final out = tmp.openWrite();
    var size = 0;
    try {
      await for (final chunk in open()) {
        hasher.add(chunk);
        out.add(chunk);
        size += chunk.length;
      }
      hasher.close();
      await out.close();
    } catch (_) {
      await out.close();
      if (tmp.existsSync()) await tmp.delete();
      rethrow;
    }
    final hash = digest.value.toString();
    final dest = fileFor(hash);
    if (dest.existsSync()) {
      await tmp.delete();
    } else {
      await dest.parent.create(recursive: true);
      await tmp.rename(dest.path);
    }
    return (hash: hash, size: size);
  }

  Future<({String hash, int size})> ingestBytes(Uint8List bytes) =>
      ingest(() => Stream.value(bytes));

  Future<Uint8List> read(String hash) => fileFor(hash).readAsBytes();

  /// A copy named [filename] in [tempDir], to hand to another app ("Open
  /// in…"). Edits made there don't come back (§6.4). Synchronous: the copy
  /// is quick next to opening the other app.
  File tempCopy(String hash, String filename, Directory tempDir) {
    final dir = Directory(p.join(tempDir.path, 'open', hash.substring(0, 12)))
      ..createSync(recursive: true);
    final safe = filename.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    return fileFor(hash).copySync(p.join(dir.path, safe.isEmpty ? hash : safe));
  }

  /// Deletes stored files whose hash is not in [keep]. Returns how many.
  Future<int> collect(Set<String> keep) async {
    if (!root.existsSync()) return 0;
    var removed = 0;
    await for (final e in root.list(recursive: true)) {
      if (e is! File) continue;
      final name = p.basename(e.path);
      if (p.basename(e.parent.path) == 'tmp') {
        await e.delete();
        continue;
      }
      if (name.length == 64 && !keep.contains(name)) {
        await e.delete();
        removed++;
      }
    }
    return removed;
  }
}

class _DigestSink implements Sink<Digest> {
  late Digest value;

  @override
  void add(Digest data) => value = data;

  @override
  void close() {}
}

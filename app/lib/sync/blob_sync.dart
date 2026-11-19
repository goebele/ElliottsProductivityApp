import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:path/path.dart' as p;

import '../data/blob_store.dart';
import '../data/database.dart';

/// Attachment files between devices (§7.3 step 6, §7.6 step 4): each side
/// lists the files its attachments need but it doesn't have (and how much
/// of each already arrived), the other sends them in chunks. A transfer
/// that stops resumes where it left off; a file is only stored once its
/// hash checks out.
class BlobSync {
  BlobSync(this._db, this._store);

  final AppDatabase _db;
  final BlobStore _store;

  static const chunkBytes = 256 * 1024;

  Directory get _incoming => Directory(p.join(_store.root.path, 'incoming'));
  File _part(String hash) => File(p.join(_incoming.path, '$hash.part'));

  static bool _isHash(String h) => RegExp(r'^[0-9a-f]{64}$').hasMatch(h);

  /// Files this device's live attachments need and doesn't have, with the
  /// bytes already received.
  Future<List<Map<String, Object?>>> wants() async {
    final rows = await _db
        .customSelect(
          'SELECT DISTINCT content_hash AS h FROM attachments WHERE deleted = 0',
        )
        .get();
    return [
      for (final r in rows)
        if (r.read<String>('h') case final h when _isHash(h) && !_store.has(h))
          {'h': h, 'from': _part(h).existsSync() ? _part(h).lengthSync() : 0},
    ];
  }

  /// The chunks answering a peer's [wants], for files this device has.
  Stream<Map<String, Object?>> serve(List<dynamic> wants) async* {
    for (final w in wants) {
      final h = (w as Map)['h'] as String;
      if (!_isHash(h) || !_store.has(h)) continue;
      final file = _store.fileFor(h);
      final size = await file.length();
      var at = ((w['from'] as int?) ?? 0).clamp(0, size);
      final raf = await file.open();
      try {
        await raf.setPosition(at);
        do {
          final bytes = await raf.read(chunkBytes);
          final last = at + bytes.length >= size;
          yield {
            'type': 'blob',
            'h': h,
            'at': at,
            'data': base64Encode(bytes),
            'last': last,
          };
          at += bytes.length;
          if (last) break;
        } while (true);
      } finally {
        await raf.close();
      }
    }
  }

  /// Takes one chunk. Returns true when a whole file has been stored.
  Future<bool> receive(Map<String, dynamic> m) async {
    final h = m['h'] as String;
    if (!_isHash(h) || _store.has(h)) return false;
    // Only files an attachment here needs, and no bigger than it says:
    // a misbehaving peer can't fill the disk.
    final expected =
        (await _db
                .customSelect(
                  'SELECT MAX(size_bytes) AS s FROM attachments '
                  'WHERE content_hash = ? AND deleted = 0',
                  variables: [Variable.withString(h)],
                )
                .getSingle())
            .readNullable<int>('s');
    if (expected == null) return false;
    await _incoming.create(recursive: true);
    final part = _part(h);
    final have = part.existsSync() ? part.lengthSync() : 0;
    final at = m['at'] as int;
    final data = base64Decode(m['data'] as String);
    if (at + data.length > expected) {
      if (part.existsSync()) await part.delete();
      return false;
    }
    if (at != have) {
      // Out of step (an old partial copy): start this file over.
      if (at != 0) return false;
      if (part.existsSync()) await part.delete();
    }
    await part.writeAsBytes(
      data,
      mode: FileMode.append,
      flush: m['last'] == true,
    );
    if (m['last'] != true) return false;
    final digest = await sha256.bind(part.openRead()).first;
    if (digest.toString() != h) {
      await part.delete(); // corrupted: ask again next time
      return false;
    }
    final dest = _store.fileFor(h);
    await dest.parent.create(recursive: true);
    await part.rename(dest.path);
    return true;
  }
}

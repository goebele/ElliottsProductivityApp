import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// A new UUIDv7: generated on any device, sorts by creation time (§5).
String newId() => _uuid.v7();

/// The id of a row that stands for a pair (§7.6, L1): the same on every
/// device, so two devices adding the same pair write one row, which then
/// merges field by field. [table] is the SQL table name; [parts] identify
/// the pair (null parts, such as a top-level shortcut's parent, count too).
///
/// Shaped like a UUID (version nibble 8, "custom") so it fits the id
/// columns; unlike UUIDv7 it doesn't sort by time.
String pairId(String table, List<Object?> parts) {
  final input = [table, for (final p in parts) p?.toString() ?? '\u0000'];
  final bytes = sha256.convert(utf8.encode(input.join('\u001f'))).bytes;
  final b = List<int>.of(bytes.take(16));
  b[6] = (b[6] & 0x0f) | 0x80; // version 8
  b[8] = (b[8] & 0x3f) | 0x80; // RFC 4122 variant
  String hex(int from, int to) =>
      [for (final x in b.sublist(from, to)) x.toRadixString(16).padLeft(2, '0')]
          .join();
  return '${hex(0, 4)}-${hex(4, 6)}-${hex(6, 8)}-${hex(8, 10)}-${hex(10, 16)}';
}

/// `#name` tags written in a title or note (DESIGN.md §6.14).
///
/// A tag starts with a letter, so `#1` and markdown headings (`# Title`)
/// are not tags. Code spans and blocks are skipped, and so are `#`s that
/// follow a letter, digit, `/`, `(` or `&` (URL fragments, `[x](#anchor)`,
/// HTML entities).
library;

final _code = RegExp(r'```[\s\S]*?```|`[^`\n]*`');
final _tag = RegExp(
  r'(?<![\p{L}\p{N}_#&/(\[-])#(\p{L}[\p{L}\p{N}_-]*)',
  unicode: true,
);

/// The tag names in [text], each once (compared case-insensitively, kept as
/// first written), in the order they appear. Trailing `-` and `_` are not
/// part of a name.
List<String> inlineTagNames(String text) {
  final plain = text.replaceAll(_code, ' ');
  final seen = <String>{};
  final out = <String>[];
  for (final m in _tag.allMatches(plain)) {
    final name = m.group(1)!.replaceFirst(RegExp(r'[-_]+$'), '');
    if (name.isNotEmpty && seen.add(name.toLowerCase())) out.add(name);
  }
  return out;
}

/// [text] with every inline `#oldName` (any case) rewritten to `#newName`,
/// or to plain `oldName` when [newName] is null (the tag was deleted, so
/// the text should not bring it back). Code is left alone.
String replaceInlineTag(String text, String oldName, String? newName) {
  final code = [for (final m in _code.allMatches(text)) (m.start, m.end)];
  bool inCode(int i) => code.any((r) => i >= r.$1 && i < r.$2);
  final target = oldName.toLowerCase();
  final out = StringBuffer();
  var last = 0;
  for (final m in _tag.allMatches(text)) {
    if (inCode(m.start)) continue;
    final raw = m.group(1)!;
    final name = raw.replaceFirst(RegExp(r'[-_]+$'), '');
    if (name.toLowerCase() != target) continue;
    out
      ..write(text.substring(last, m.start))
      ..write(newName == null ? name : '#$newName')
      ..write(raw.substring(name.length));
    last = m.end;
  }
  if (last == 0) return text;
  out.write(text.substring(last));
  return out.toString();
}

final _validName = RegExp(r'^\p{L}[\p{L}\p{N}_-]*$', unicode: true);

/// [input] as a tag name: without a leading `#`, spaces as `-`. Null if it
/// can't be one (it must start with a letter and hold only letters, digits,
/// `_` and `-`), so every tag can also be written inline.
String? normalizeTagName(String input) {
  final name = input
      .trim()
      .replaceFirst(RegExp('^#+'), '')
      .replaceAll(RegExp(r'\s+'), '-')
      .replaceFirst(RegExp(r'[-_]+$'), '');
  return _validName.hasMatch(name) ? name : null;
}

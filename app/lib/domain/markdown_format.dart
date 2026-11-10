/// Text edits behind the Markdown toolbar (§6.3). Each takes the editor's
/// text and selection and returns the new ones, so they can be tested
/// without a UI.
library;

import 'package:markdown/markdown.dart' as md;

/// Text plus a selection ([start] ≤ [end]; equal means a cursor).
class TextEdit {
  const TextEdit(this.text, this.start, this.end);
  final String text;
  final int start;
  final int end;

  @override
  bool operator ==(Object other) =>
      other is TextEdit &&
      other.text == text &&
      other.start == start &&
      other.end == end;

  @override
  int get hashCode => Object.hash(text, start, end);

  @override
  String toString() =>
      'TextEdit(${text.replaceAll('\n', r'\n')}, $start, $end)';
}

/// Wraps the selection in [marker] (`**` bold, `_` italic, `` ` `` code), or
/// unwraps it if it already is. With no selection, inserts a pair and puts
/// the cursor between them.
TextEdit toggleWrap(TextEdit e, String marker) {
  final m = marker.length;
  final before = e.text.substring(0, e.start);
  final selected = e.text.substring(e.start, e.end);
  final after = e.text.substring(e.end);
  if (before.endsWith(marker) && after.startsWith(marker)) {
    return TextEdit(
      before.substring(0, before.length - m) + selected + after.substring(m),
      e.start - m,
      e.end - m,
    );
  }
  if (selected.length >= 2 * m &&
      selected.startsWith(marker) &&
      selected.endsWith(marker)) {
    final inner = selected.substring(m, selected.length - m);
    return TextEdit(before + inner + after, e.start, e.start + inner.length);
  }
  return TextEdit(
    '$before$marker$selected$marker$after',
    e.start + m,
    e.end + m,
  );
}

/// Code: inline for a selection within one line, a fenced block when the
/// selection spans lines.
TextEdit toggleCode(TextEdit e) {
  final selected = e.text.substring(e.start, e.end);
  if (!selected.contains('\n')) return toggleWrap(e, '`');
  final before = e.text.substring(0, e.start);
  final after = e.text.substring(e.end);
  final open = '${before.isEmpty || before.endsWith('\n') ? '' : '\n'}```\n';
  final close = '\n```${after.isEmpty || after.startsWith('\n') ? '' : '\n'}';
  return TextEdit(
    '$before$open$selected$close$after',
    e.start + open.length,
    e.end + open.length,
  );
}

/// Adds [prefix] (`# `, `- `, `1. `) to every line the selection touches,
/// or removes it if they all have it already.
TextEdit toggleLinePrefix(TextEdit e, String prefix) {
  final lineStart = e.text.lastIndexOf('\n', e.start == 0 ? 0 : e.start - 1);
  final from = e.start == 0 ? 0 : lineStart + 1;
  var to = e.text.indexOf('\n', e.end);
  if (to == -1) to = e.text.length;
  final lines = e.text.substring(from, to).split('\n');
  final remove = lines.every((l) => l.startsWith(prefix));
  var shiftStart = 0;
  var shiftEnd = 0;
  final changed = <String>[];
  for (final (i, line) in lines.indexed) {
    final delta = remove ? -prefix.length : prefix.length;
    if (i == 0) shiftStart = delta;
    shiftEnd += delta;
    changed.add(remove ? line.substring(prefix.length) : '$prefix$line');
  }
  final text = e.text.replaceRange(from, to, changed.join('\n'));
  final start = (e.start + shiftStart).clamp(from, text.length);
  return TextEdit(text, start, (e.end + shiftEnd).clamp(start, text.length));
}

/// Makes the selection a link and selects the URL part to type over; with
/// no selection, inserts `[text](url)` with "text" selected.
TextEdit insertLink(
  TextEdit e, {
  String textHint = 'text',
  String urlHint = 'https://',
}) {
  final selected = e.text.substring(e.start, e.end);
  final label = selected.isEmpty ? textHint : selected;
  final inserted = '[$label]($urlHint)';
  final text = e.text.replaceRange(e.start, e.end, inserted);
  if (selected.isEmpty) {
    return TextEdit(text, e.start + 1, e.start + 1 + label.length);
  }
  final urlStart = e.start + label.length + 3;
  return TextEdit(text, urlStart, urlStart + urlHint.length);
}

/// The words of a Markdown text without its markup, for one-line previews
/// on cards.
String markdownPlainText(String source) {
  if (source.trim().isEmpty) return '';
  final nodes = md.Document(extensionSet: md.ExtensionSet.gitHubFlavored)
      .parse(source);
  final out = StringBuffer();
  void visit(md.Node node) {
    if (node is md.Text) {
      out.write(node.text);
    } else if (node is md.Element) {
      if (node.tag == 'input') return; // task-list checkbox
      for (final child in node.children ?? const <md.Node>[]) {
        visit(child);
      }
      if (_blockTags.contains(node.tag)) out.write(' ');
    }
  }

  nodes.forEach(visit);
  return out.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
}

const _blockTags = {
  'p',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'li',
  'pre',
  'blockquote',
  'tr',
  'td',
  'th',
  'br',
  'hr',
};

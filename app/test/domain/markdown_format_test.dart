import 'package:elliotts_productivity_app/domain/markdown_format.dart';
import 'package:flutter_test/flutter_test.dart';

/// `|` marks a cursor, `[` and `]` a selection.
TextEdit parse(String s) {
  final cursor = s.indexOf('|');
  if (cursor >= 0) return TextEdit(s.replaceFirst('|', ''), cursor, cursor);
  final start = s.indexOf('[');
  final end = s.indexOf(']') - 1;
  return TextEdit(s.replaceFirst('[', '').replaceFirst(']', ''), start, end);
}

String show(TextEdit e) => e.start == e.end
    ? e.text.replaceRange(e.start, e.start, '|')
    : e.text
          .replaceRange(e.end, e.end, ']')
          .replaceRange(e.start, e.start, '[');

void main() {
  test('bold wraps a selection, and unwraps it again', () {
    final bold = toggleWrap(parse('Pack [boots] today'), '**');
    expect(show(bold), 'Pack **[boots]** today');
    expect(show(toggleWrap(bold, '**')), 'Pack [boots] today');
    expect(
      show(toggleWrap(parse('Pack [**boots**] today'), '**')),
      'Pack [boots] today',
    );
  });

  test('with no selection a pair is inserted around the cursor', () {
    expect(show(toggleWrap(parse('Hi |'), '_')), 'Hi _|_');
  });

  test('line prefixes toggle on every selected line', () {
    final listed = toggleLinePrefix(parse('[Milk\nEggs]\nBread'), '- ');
    expect(listed.text, '- Milk\n- Eggs\nBread');
    expect(toggleLinePrefix(listed, '- ').text, 'Milk\nEggs\nBread');
    expect(
      show(toggleLinePrefix(parse('Intro\nTi|tle'), '## ')),
      'Intro\n## Ti|tle',
    );
  });

  test('links select the part to type next', () {
    expect(show(insertLink(parse('See |'))), 'See [[text]](https://)');
    expect(show(insertLink(parse('See [docs]'))), 'See [docs]([https://])');
  });

  test('code is inline in a line and fenced across lines', () {
    expect(show(toggleCode(parse('run [ls] now'))), 'run `[ls]` now');
    expect(toggleCode(parse('[a\nb]')).text, '```\na\nb\n```');
  });

  test('plain-text previews drop the markup', () {
    expect(
      markdownPlainText(
        '## Plan\n\n- **Buy** posts\n- [ ] Dig\n\nSee [docs](https://x.y).',
      ),
      'Plan Buy posts Dig See docs.',
    );
    expect(markdownPlainText('  '), '');
  });
}

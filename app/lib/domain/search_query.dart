import '../data/tables.dart';

/// A tag named in a search, optionally with "include children" (`#tag/*`).
typedef TagTerm = ({String name, bool children});

/// What the search box says (DESIGN.md §6.6), split into words to find and
/// filters written as shortcuts:
///
/// `#tag`, `#tag/*` (include children), `value:Health`, `type:task`,
/// `status:done` (or `is:done`), `in:"Project"` (top-level item), and
/// `"exact phrase"`. Quotes work in any value. Unknown `key:value` pairs are
/// searched as words.
class SearchQuery {
  const SearchQuery({
    this.words = const [],
    this.phrases = const [],
    this.tags = const [],
    this.values = const [],
    this.types = const {},
    this.statuses = const {},
    this.inTopLevel = const [],
  });

  factory SearchQuery.parse(String input) {
    final words = <String>[];
    final phrases = <String>[];
    final tags = <TagTerm>[];
    final values = <String>[];
    final types = <NodeType>{};
    final statuses = <NodeStatus>{};
    final inTop = <String>[];

    for (final m in _token.allMatches(input)) {
      final key = m.group(1)?.toLowerCase();
      final raw = m.group(2)!;
      final quoted = raw.startsWith('"');
      final value = quoted
          ? raw.substring(1, raw.length - (raw.endsWith('"') ? 1 : 0))
          : raw;
      if (value.isEmpty) continue;

      switch (key) {
        case 'value' || 'v':
          values.add(value);
        case 'type' || 't':
          final t = _byName(NodeType.values, value);
          t == null ? words.add(m.group(0)!) : types.add(t);
        case 'status' || 'is':
          final s = _byName(NodeStatus.values, value);
          s == null ? words.add(m.group(0)!) : statuses.add(s);
        case 'in':
          inTop.add(value);
        case null when !quoted && value.startsWith('#') && value.length > 1:
          final children = value.endsWith('/*');
          final name = value.substring(
            1,
            children ? value.length - 2 : value.length,
          );
          if (name.isNotEmpty) tags.add((name: name, children: children));
        case null when quoted:
          phrases.add(value);
        case null:
          words.add(value);
        default:
          words.add('$key:$value');
      }
    }
    return SearchQuery(
      words: words,
      phrases: phrases,
      tags: tags,
      values: values,
      types: types,
      statuses: statuses,
      inTopLevel: inTop,
    );
  }

  // key:"quoted value" | key:value | "quoted" | word
  static final _token = RegExp(r'(?:([A-Za-z]+):)?("[^"]*"?|\S+)');

  final List<String> words;
  final List<String> phrases;
  final List<TagTerm> tags;
  final List<String> values;
  final Set<NodeType> types;
  final Set<NodeStatus> statuses;
  final List<String> inTopLevel;

  bool get hasText => words.isNotEmpty || phrases.isNotEmpty;

  bool get isEmpty =>
      !hasText &&
      tags.isEmpty &&
      values.isEmpty &&
      types.isEmpty &&
      statuses.isEmpty &&
      inTopLevel.isEmpty;

  /// An FTS5 MATCH expression: every word as a prefix, every phrase exact,
  /// all required.
  String get ftsMatch => [
    for (final w in words) '${_quote(w)}*',
    for (final p in phrases) _quote(p),
  ].join(' ');

  static String _quote(String s) => '"${s.replaceAll('"', '""')}"';

  static T? _byName<T extends Enum>(List<T> values, String name) {
    final lower = name.toLowerCase();
    for (final v in values) {
      if (v.name.toLowerCase() == lower) return v;
    }
    return null;
  }
}

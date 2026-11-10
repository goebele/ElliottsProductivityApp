import 'package:drift/drift.dart';

import '../data/database.dart';
import 'node_repository.dart';
import 'search_query.dart';

export 'search_query.dart';

/// Filters picked from the chips under the search box (DESIGN.md §6.6).
/// They combine with what is typed: an item must pass both.
class SearchFilters {
  const SearchFilters({
    this.valueIds = const {},
    this.tagIds = const {},
    this.tagChildren = false,
    this.types = const {},
    this.statuses = const {},
    this.topLevelId,
    this.dueFrom,
    this.dueTo,
    this.includeArchived = false,
    this.hasFiles = false,
  });

  /// Every one must be among the item's values (own or inherited).
  final Set<String> valueIds;

  /// Every one must be on the item (or, with [tagChildren], on it or an
  /// item above it).
  final Set<String> tagIds;
  final bool tagChildren;

  /// Any of them.
  final Set<NodeType> types;
  final Set<NodeStatus> statuses;

  /// Under this top-level item.
  final String? topLevelId;

  /// All-day due date within this range (inclusive).
  final DateTime? dueFrom;
  final DateTime? dueTo;

  final bool includeArchived;

  /// Only items with files attached.
  final bool hasFiles;

  bool get isEmpty =>
      valueIds.isEmpty &&
      tagIds.isEmpty &&
      types.isEmpty &&
      statuses.isEmpty &&
      topLevelId == null &&
      dueFrom == null &&
      dueTo == null &&
      !hasFiles;

  SearchFilters copyWith({
    Set<String>? valueIds,
    Set<String>? tagIds,
    bool? tagChildren,
    Set<NodeType>? types,
    Set<NodeStatus>? statuses,
    String? Function()? topLevelId,
    DateTime? Function()? dueFrom,
    DateTime? Function()? dueTo,
    bool? includeArchived,
    bool? hasFiles,
  }) => SearchFilters(
    valueIds: valueIds ?? this.valueIds,
    tagIds: tagIds ?? this.tagIds,
    tagChildren: tagChildren ?? this.tagChildren,
    types: types ?? this.types,
    statuses: statuses ?? this.statuses,
    topLevelId: topLevelId == null ? this.topLevelId : topLevelId(),
    dueFrom: dueFrom == null ? this.dueFrom : dueFrom(),
    dueTo: dueTo == null ? this.dueTo : dueTo(),
    includeArchived: includeArchived ?? this.includeArchived,
    hasFiles: hasFiles ?? this.hasFiles,
  );
}

/// One item found. Each item is listed once, however many places it shows
/// in (D19).
class SearchResult {
  const SearchResult(
    this.node,
    this.path, {
    this.linkedCount = 0,
    this.attachment,
  });

  /// The item found, or for a file, the item it belongs to.
  final Node node;

  /// Real ancestors, top-level first. For a note, the last is its owner;
  /// for a file, the last is [node].
  final List<Node> path;

  /// For a note or a file: how many items link it.
  final int linkedCount;

  /// Set when a file was found (by its name or text).
  final Attachment? attachment;
}

/// Finds items by text (FTS5 over titles and text) and filters
/// (DESIGN.md §6.6).
///
/// A note is judged by its owner and the items linking it (D19): it passes
/// the value, tag, status, top-level and date filters if any of those does.
/// Type filters apply to the item itself, so `type:note` finds notes.
class SearchService {
  SearchService(this._db);

  final AppDatabase _db;

  static const limit = 200;
  static const _maxDepth = 1000;

  Future<List<SearchResult>> search(
    SearchQuery query, {
    SearchFilters filters = const SearchFilters(),
  }) async {
    if (query.isEmpty && filters.isEmpty) return const [];

    final lifecycles = [
      Lifecycle.live.name,
      if (filters.includeArchived) Lifecycle.archived.name,
    ];
    final nodes = {
      for (final n
          in await (_db.select(_db.nodes)..where(
                (n) => n.deleted.equals(false) & n.lifecycle.isIn(lifecycles),
              ))
              .get())
        n.id: n,
    };

    // Text first: FTS rank order. Otherwise every item, by title.
    List<String> candidates;
    if (query.hasText) {
      final rows = await _db
          .customSelect(
            '''
            SELECT n.id AS id FROM node_search s
            JOIN nodes n ON n.rowid = s.rowid
            WHERE node_search MATCH ?1
            ORDER BY bm25(node_search, 5.0, 1.0)
            ''',
            variables: [Variable.withString(query.ftsMatch)],
            readsFrom: {_db.nodes},
          )
          .get();
      candidates = [
        for (final r in rows)
          if (nodes.containsKey(r.read<String>('id'))) r.read<String>('id'),
      ];
    } else {
      candidates = nodes.keys.toList()
        ..sort(
          (a, b) => nodes[a]!.title.toLowerCase().compareTo(
            nodes[b]!.title.toLowerCase(),
          ),
        );
    }

    final ctx = await _Context.load(_db, nodes);

    // Names typed in the box: an unknown name matches nothing.
    final valueIds = {...filters.valueIds};
    for (final name in query.values) {
      final id = ctx.valueIdByName(name);
      if (id == null) return const [];
      valueIds.add(id);
    }
    final tagTerms = [
      for (final id in filters.tagIds) (id: id, children: filters.tagChildren),
    ];
    for (final t in query.tags) {
      final id = ctx.tagIdByName(t.name);
      if (id == null) return const [];
      tagTerms.add((id: id, children: t.children));
    }
    final topIds = <String>{?filters.topLevelId};
    final topNames = [for (final n in query.inTopLevel) n.toLowerCase()];
    final types = {...filters.types, ...query.types};
    final statuses = {...filters.statuses, ...query.statuses};
    final from = filters.dueFrom == null ? null : dateKey(filters.dueFrom!);
    final to = filters.dueTo == null ? null : dateKey(filters.dueTo!);

    bool subjectPasses(Node s) {
      if (filters.hasFiles && !ctx.filesOn.contains(s.id)) return false;
      if (statuses.isNotEmpty && !statuses.contains(s.status)) return false;
      if (from != null || to != null) {
        final due = s.dueDate;
        if (due == null) return false;
        if (from != null && due.compareTo(from) < 0) return false;
        if (to != null && due.compareTo(to) > 0) return false;
      }
      if (valueIds.isNotEmpty &&
          !ctx.effectiveValues(s.id).containsAll(valueIds)) {
        return false;
      }
      for (final t in tagTerms) {
        final has = t.children
            ? ctx.tagsWithAbove(s.id).contains(t.id)
            : (ctx.tagsOn[s.id]?.contains(t.id) ?? false);
        if (!has) return false;
      }
      if (topIds.isNotEmpty || topNames.isNotEmpty) {
        final top = ctx.topLevel(s.id);
        if (top == null) return false;
        if (topIds.isNotEmpty && !topIds.contains(top.id)) return false;
        if (topNames.isNotEmpty &&
            !topNames.every((n) => top.title.toLowerCase() == n)) {
          return false;
        }
      }
      return true;
    }

    final out = <SearchResult>[];
    for (final id in candidates) {
      final node = nodes[id]!;
      if (types.isNotEmpty && !types.contains(node.type)) continue;
      final linking = node.type == NodeType.note
          ? ctx.linkingOf(id)
          : const <String>[];
      final subjects = node.type == NodeType.note
          ? [
              if (node.parentId != null && nodes[node.parentId] != null)
                nodes[node.parentId]!,
              for (final l in linking)
                if (nodes[l] != null) nodes[l]!,
            ]
          : [node];
      // A top-level note has no owner: judge it by itself.
      if (subjects.isEmpty) subjects.add(node);
      if (!subjects.any(subjectPasses)) continue;
      out.add(SearchResult(node, ctx.path(id), linkedCount: linking.length));
      if (out.length >= limit) break;
    }

    // Files, by name and the text of .txt/.md files. They have no type, so
    // a type filter leaves them out; other filters judge the owner and the
    // items linking the file (D19).
    if (query.hasText && types.isEmpty && out.length < limit) {
      final rows = await _db
          .customSelect(
            '''
            SELECT a.* FROM attachment_search s
            JOIN attachments a ON a.id = s.attachment_id
            WHERE attachment_search MATCH ?1 AND a.deleted = 0
            ORDER BY bm25(attachment_search, 0.0, 5.0, 1.0)
            ''',
            variables: [Variable.withString(query.ftsMatch)],
            readsFrom: {_db.attachments},
          )
          .get();
      for (final r in rows) {
        final a = _db.attachments.map(r.data);
        final owner = nodes[a.nodeId];
        if (owner == null) continue;
        final linking = ctx.fileLinksOf(a.id);
        final subjects = [
          owner,
          for (final l in linking)
            if (nodes[l] != null) nodes[l]!,
        ];
        if (!subjects.any(subjectPasses)) continue;
        out.add(
          SearchResult(
            owner,
            [...ctx.path(owner.id), owner],
            linkedCount: linking.length,
            attachment: a,
          ),
        );
        if (out.length >= limit) break;
      }
    }
    return out;
  }
}

/// Everything the filters need, read once per search.
class _Context {
  _Context(
    this.nodes,
    this.placedUnder,
    this.tagsOn,
    this.valuesOn,
    this.linksTo,
    this.tagNames,
    this.valueNames,
  );

  static Future<_Context> load(AppDatabase db, Map<String, Node> nodes) async {
    final placedUnder = <String, List<String>>{};
    for (final p in await (db.select(
      db.placements,
    )..where((p) => p.deleted.equals(false))).get()) {
      if (p.parentNodeId != null) {
        (placedUnder[p.nodeId] ??= []).add(p.parentNodeId!);
      }
    }
    final tagNames = <String, String>{};
    for (final t in await (db.select(
      db.tags,
    )..where((t) => t.deleted.equals(false))).get()) {
      tagNames[t.name.toLowerCase()] = t.id;
    }
    final tagsOn = <String, Set<String>>{};
    for (final r in await (db.select(
      db.nodeTags,
    )..where((r) => r.deleted.equals(false))).get()) {
      (tagsOn[r.nodeId] ??= {}).add(r.tagId);
    }
    final valueNames = <String, String>{};
    for (final v in await (db.select(
      db.coreValues,
    )..where((v) => v.deleted.equals(false))).get()) {
      valueNames[v.name.toLowerCase()] = v.id;
    }
    final valuesOn = <String, Set<String>>{};
    for (final r in await (db.select(
      db.nodeValues,
    )..where((r) => r.deleted.equals(false))).get()) {
      if (valueNames.containsValue(r.valueId)) {
        (valuesOn[r.nodeId] ??= {}).add(r.valueId);
      }
    }
    final filesOn = {
      for (final r
          in await db
              .customSelect(
                'SELECT DISTINCT node_id FROM attachments WHERE deleted = 0',
                readsFrom: {db.attachments},
              )
              .get())
        r.read<String>('node_id'),
    };
    final fileLinks = <String, List<String>>{};
    for (final l
        in await (db.select(db.links)..where(
              (l) =>
                  l.deleted.equals(false) &
                  l.targetKind.equals(LinkKind.attachment.name),
            ))
            .get()) {
      if (l.targetId != null) (fileLinks[l.targetId!] ??= []).add(l.fromNodeId);
    }
    final linksTo = <String, List<String>>{};
    for (final l
        in await (db.select(db.links)..where(
              (l) =>
                  l.deleted.equals(false) &
                  l.targetKind.equals(LinkKind.note.name),
            ))
            .get()) {
      if (l.targetId != null) (linksTo[l.targetId!] ??= []).add(l.fromNodeId);
    }
    return _Context(
        nodes,
        placedUnder,
        tagsOn,
        valuesOn,
        linksTo,
        tagNames,
        valueNames,
      )
      ..filesOn.addAll(filesOn)
      ..fileLinks.addAll(fileLinks);
  }

  final Map<String, Node> nodes;
  final Map<String, List<String>> placedUnder;
  final Map<String, Set<String>> tagsOn;
  final Map<String, Set<String>> valuesOn;
  final Map<String, List<String>> linksTo;
  final Map<String, String> tagNames;
  final Map<String, String> valueNames;

  /// Items with live files.
  final filesOn = <String>{};

  /// File id → items linking it.
  final fileLinks = <String, List<String>>{};

  List<String> fileLinksOf(String id) => [
    for (final from in fileLinks[id] ?? const <String>[])
      if (nodes.containsKey(from)) from,
  ];

  final _effective = <String, Set<String>>{};
  final _tagsAbove = <String, Set<String>>{};

  String? tagIdByName(String name) => tagNames[name.toLowerCase()];
  String? valueIdByName(String name) => valueNames[name.toLowerCase()];

  /// Live items linking note [id].
  List<String> linkingOf(String id) => [
    for (final from in linksTo[id] ?? const <String>[])
      if (nodes.containsKey(from)) from,
  ];

  Iterable<String> _above(String id) sync* {
    final parent = nodes[id]?.parentId;
    if (parent != null) yield parent;
    yield* placedUnder[id] ?? const [];
  }

  /// Own values plus those of every item above (real parents and shortcut
  /// parents).
  Set<String> effectiveValues(String id) =>
      _gather(id, _effective, (n) => valuesOn[n] ?? const {});

  /// Own tags plus those of every item above.
  Set<String> tagsWithAbove(String id) =>
      _gather(id, _tagsAbove, (n) => tagsOn[n] ?? const {});

  Set<String> _gather(
    String id,
    Map<String, Set<String>> memo,
    Set<String> Function(String) own,
  ) {
    final cached = memo[id];
    if (cached != null) return cached;
    final out = <String>{};
    final seen = <String>{id};
    final stack = [id];
    while (stack.isNotEmpty) {
      final n = stack.removeLast();
      out.addAll(own(n));
      for (final p in _above(n)) {
        if (seen.add(p) && seen.length < SearchService._maxDepth) stack.add(p);
      }
    }
    return memo[id] = out;
  }

  /// Real ancestors of [id], top-level first.
  List<Node> path(String id) {
    final out = <Node>[];
    var parent = nodes[id]?.parentId;
    while (parent != null && out.length < SearchService._maxDepth) {
      final p = nodes[parent];
      if (p == null) break;
      out.insert(0, p);
      parent = p.parentId;
    }
    return out;
  }

  /// The top-level item [id] is under (itself if it is top-level).
  Node? topLevel(String id) {
    final p = path(id);
    return p.isEmpty ? nodes[id] : p.first;
  }
}

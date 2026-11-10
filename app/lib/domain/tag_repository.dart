import 'package:drift/drift.dart';

import '../data/database.dart';
import '../sync/change_writer.dart';
import 'ids.dart';
import 'inline_tags.dart';

/// A tag on a node, and whether it came from the node's text.
class NodeTagEntry {
  const NodeTagEntry(this.tag, this.origin);
  final Tag tag;
  final LinkOrigin origin;

  /// From `#name` in the title or text: removed by editing the text.
  bool get inline => origin == LinkOrigin.inline;
}

/// A tag and how many items use it.
class TagUsage {
  const TagUsage(this.tag, this.count);
  final Tag tag;

  /// Items (not deleted, archived ones included) that have the tag.
  final int count;
}

/// Tags and the nodes they are on (DESIGN.md §6.14). In v1 every tag is
/// private, in your personal space.
class TagRepository {
  TagRepository(this._db, this._writer, {required this.spaceId});

  final AppDatabase _db;
  final ChangeWriter _writer;
  final String spaceId;

  /// Live tags, by name.
  Stream<List<Tag>> watchAll() =>
      (_db.select(_db.tags)
            ..where((t) => t.deleted.equals(false))
            ..orderBy([
              (t) => OrderingTerm(expression: t.name.collate(Collate.noCase)),
            ]))
          .watch();

  Future<List<Tag>> all() =>
      (_db.select(_db.tags)
            ..where((t) => t.deleted.equals(false))
            ..orderBy([
              (t) => OrderingTerm(expression: t.name.collate(Collate.noCase)),
            ]))
          .get();

  /// Live tags with how many items use each: favourites first, then by name.
  Stream<List<TagUsage>> watchUsage() => _db
      .customSelect(
        '''
        SELECT t.id AS id, COUNT(DISTINCT n.id) AS uses FROM tags t
        LEFT JOIN node_tags r ON r.tag_id = t.id AND r.deleted = 0
        LEFT JOIN nodes n ON n.id = r.node_id AND n.deleted = 0
        WHERE t.deleted = 0
        GROUP BY t.id
        ''',
        readsFrom: {_db.tags, _db.nodeTags, _db.nodes},
      )
      .watch()
      .asyncMap((rows) async {
        final counts = {
          for (final r in rows) r.read<String>('id'): r.read<int>('uses'),
        };
        final tags = await all();
        return [
          for (final t in tags.where((t) => t.favorite))
            TagUsage(t, counts[t.id] ?? 0),
          for (final t in tags.where((t) => !t.favorite))
            TagUsage(t, counts[t.id] ?? 0),
        ];
      });

  /// Creates a tag on the Tags page (kept even while unused). An existing
  /// name is kept instead. Returns its id.
  Future<String> create(String name) => _db.transaction(() async {
    final id = await ensure(_clean(name));
    await _writer.update(_db.tags, id, const TagsCompanion(kept: Value(true)));
    return id;
  });

  Future<void> setFavorite(String tagId, bool favorite) => _writer.update(
    _db.tags,
    tagId,
    TagsCompanion(favorite: Value(favorite), kept: const Value(true)),
  );

  Future<void> setColor(String tagId, int? color) => _writer.update(
    _db.tags,
    tagId,
    TagsCompanion(color: Value(color), kept: const Value(true)),
  );

  /// Renames [tagId], rewriting `#old` in every title and text that has it.
  /// If another tag already has the name, the two are merged into that one.
  /// Returns the id of the tag that remains.
  Future<String> rename(String tagId, String newName) => _db.transaction(
    () async {
      final name = _clean(newName);
      final tag = await _tag(tagId);
      if (tag == null) return tagId;
      final other = (await _named(name))
          .where((t) => !t.deleted && t.id != tagId)
          .firstOrNull;
      final inlineNodes = await _inlineNodes(tagId);

      if (other == null) {
        await _writer.update(
          _db.tags,
          tagId,
          TagsCompanion(name: Value(name), kept: const Value(true)),
        );
        await _rewrite(inlineNodes, tag.name, name);
        return tagId;
      }

      // Merge into [other]: move each use across, once per item.
      for (final r in await (_db.select(
        _db.nodeTags,
      )..where((r) => r.tagId.equals(tagId) & r.deleted.equals(false))).get()) {
        if ((await _rows(r.nodeId, other.id)).isNotEmpty) {
          await _tombstone(r.id);
        } else {
          await _writer.update(
            _db.nodeTags,
            r.id,
            NodeTagsCompanion(tagId: Value(other.id)),
          );
        }
      }
      await _writer.update(
        _db.tags,
        other.id,
        TagsCompanion(
          kept: const Value(true),
          favorite: Value(other.favorite || tag.favorite),
          color: Value(other.color ?? tag.color),
        ),
      );
      await _writer.update(
        _db.tags,
        tagId,
        const TagsCompanion(deleted: Value(true)),
      );
      await _rewrite(inlineNodes, tag.name, other.name);
      return other.id;
    },
  );

  /// Removes [tagId] from every item and deletes it. `#name` in titles and
  /// text becomes plain `name`, so it doesn't come back.
  Future<void> delete(String tagId) => _db.transaction(() async {
    final tag = await _tag(tagId);
    if (tag == null) return;
    final inlineNodes = await _inlineNodes(tagId);
    for (final r in await (_db.select(
      _db.nodeTags,
    )..where((r) => r.tagId.equals(tagId) & r.deleted.equals(false))).get()) {
      await _tombstone(r.id);
    }
    await _writer.update(
      _db.tags,
      tagId,
      const TagsCompanion(
        deleted: Value(true),
        favorite: Value(false),
        kept: Value(false),
      ),
    );
    await _rewrite(inlineNodes, tag.name, null);
  });

  Future<Tag?> _tag(String id) =>
      (_db.select(_db.tags)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// A valid tag name, or [ArgumentError] (see [normalizeTagName]).
  static String _clean(String name) =>
      normalizeTagName(name) ??
      (throw ArgumentError.value(name, 'name', 'Not a valid tag name'));

  Future<List<String>> _inlineNodes(String tagId) async => [
    for (final r
        in await (_db.select(_db.nodeTags)..where(
              (r) =>
                  r.tagId.equals(tagId) &
                  r.deleted.equals(false) &
                  r.origin.equals(LinkOrigin.inline.name),
            ))
            .get())
      r.nodeId,
  ];

  /// Rewrites `#from` in each node's title and text, then re-reads its
  /// inline tags.
  Future<void> _rewrite(List<String> nodeIds, String from, String? to) async {
    for (final id in {...nodeIds}) {
      final node = await (_db.select(
        _db.nodes,
      )..where((n) => n.id.equals(id))).getSingleOrNull();
      if (node == null) continue;
      final title = replaceInlineTag(node.title, from, to);
      final body = replaceInlineTag(node.bodyMd, from, to);
      if (title != node.title || body != node.bodyMd) {
        await _writer.update(
          _db.nodes,
          id,
          NodesCompanion(
            title: title == node.title ? const Value.absent() : Value(title),
            bodyMd: body == node.bodyMd ? const Value.absent() : Value(body),
          ),
        );
      }
      await syncInline(id, title, body);
    }
  }

  /// The live tag called [name] (any case), if there is one.
  Future<Tag?> byName(String name) async =>
      (await _named(name)).where((t) => !t.deleted).firstOrNull;

  Future<List<Tag>> _named(String name) =>
      (_db.select(_db.tags)
            ..where((t) => t.name.lower().equals(name.toLowerCase()))
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
          .get();

  /// The tags on [nodeId], by name, each once.
  Future<List<NodeTagEntry>> of(String nodeId) => _ofQuery(nodeId).get();

  Stream<List<NodeTagEntry>> watchOf(String nodeId) => _ofQuery(nodeId).watch();

  Selectable<NodeTagEntry> _ofQuery(String nodeId) {
    final q =
        _db.select(_db.nodeTags).join([
            innerJoin(_db.tags, _db.tags.id.equalsExp(_db.nodeTags.tagId)),
          ])
          ..where(
            _db.nodeTags.nodeId.equals(nodeId) &
                _db.nodeTags.deleted.equals(false) &
                _db.tags.deleted.equals(false),
          )
          ..orderBy([
            OrderingTerm(expression: _db.tags.name.collate(Collate.noCase)),
          ]);
    return q.map(
      (r) =>
          NodeTagEntry(r.readTable(_db.tags), r.readTable(_db.nodeTags).origin),
    );
  }

  /// The id of the tag called [name], bringing back a removed one of that
  /// name or creating it.
  Future<String> ensure(String name) async {
    final rows = await _named(name);
    final live = rows.where((t) => !t.deleted).firstOrNull;
    if (live != null) return live.id;
    if (rows.isNotEmpty) {
      await _writer.update(
        _db.tags,
        rows.first.id,
        const TagsCompanion(deleted: Value(false)),
      );
      return rows.first.id;
    }
    final id = newId();
    await _writer.insert(
      _db.tags,
      TagsCompanion(
        id: Value(id),
        spaceId: Value(spaceId),
        name: Value(name),
        kind: const Value(TagKind.normal),
        deleted: const Value(false),
      ),
    );
    return id;
  }

  /// Tags [nodeId] with [name] from the picker. Already tagged: no change.
  Future<void> add(String nodeId, String name) async {
    final trimmed = normalizeTagName(name);
    if (trimmed == null) return;
    await _db.transaction(() async {
      final tagId = await ensure(trimmed);
      if ((await _rows(nodeId, tagId)).isNotEmpty) return;
      await _insert(nodeId, tagId, LinkOrigin.attached);
    });
  }

  /// Removes the picker tag [tagId] from [nodeId]. A tag from the node's
  /// text stays until the text changes.
  Future<void> remove(String nodeId, String tagId) => _db.transaction(() async {
    for (final r in await _rows(nodeId, tagId)) {
      if (r.origin == LinkOrigin.attached) await _tombstone(r.id);
    }
    await _dropIfUnused(tagId);
  });

  /// Keeps [nodeId]'s inline tags in step with its title and text.
  Future<void> syncInline(String nodeId, String title, String bodyMd) =>
      _db.transaction(() async {
        final names = inlineTagNames('$title\n$bodyMd');
        final wanted = {for (final n in names) n.toLowerCase(): n};
        final current =
            await (_db.select(_db.nodeTags).join([
                  innerJoin(
                    _db.tags,
                    _db.tags.id.equalsExp(_db.nodeTags.tagId),
                  ),
                ])..where(
                  _db.nodeTags.nodeId.equals(nodeId) &
                      _db.nodeTags.deleted.equals(false),
                ))
                .get();
        final have = <String>{};
        for (final r in current) {
          final row = r.readTable(_db.nodeTags);
          final tag = r.readTable(_db.tags);
          final key = tag.name.toLowerCase();
          if (!tag.deleted) have.add(key);
          if (row.origin == LinkOrigin.inline && !wanted.containsKey(key)) {
            await _tombstone(row.id);
            await _dropIfUnused(tag.id);
          }
        }
        for (final MapEntry(:key, :value) in wanted.entries) {
          if (have.contains(key)) continue;
          await _insert(nodeId, await ensure(value), LinkOrigin.inline);
        }
      });

  Future<List<NodeTag>> _rows(String nodeId, String tagId) =>
      (_db.select(_db.nodeTags)..where(
            (r) =>
                r.nodeId.equals(nodeId) &
                r.tagId.equals(tagId) &
                r.deleted.equals(false),
          ))
          .get();

  Future<void> _insert(String nodeId, String tagId, LinkOrigin origin) =>
      _writer.insert(
        _db.nodeTags,
        NodeTagsCompanion(
          id: Value(newId()),
          spaceId: Value(spaceId),
          nodeId: Value(nodeId),
          tagId: Value(tagId),
          origin: Value(origin),
          deleted: const Value(false),
        ),
      );

  Future<void> _tombstone(String nodeTagId) => _writer.update(
    _db.nodeTags,
    nodeTagId,
    const NodeTagsCompanion(deleted: Value(true)),
  );

  /// A tag lasts while something uses it, unless it is kept or a favourite.
  Future<void> _dropIfUnused(String tagId) async {
    final tag = await _tag(tagId);
    if (tag == null || tag.kept || tag.favorite) return;
    final used =
        await (_db.select(_db.nodeTags)
              ..where((r) => r.tagId.equals(tagId) & r.deleted.equals(false))
              ..limit(1))
            .getSingleOrNull();
    if (used == null) {
      await _writer.update(
        _db.tags,
        tagId,
        const TagsCompanion(deleted: Value(true)),
      );
    }
  }
}

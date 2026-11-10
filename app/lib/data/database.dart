import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../sync/change_writer.dart';
import 'tables.dart';

export 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Spaces,
    SpaceMembers,
    Nodes,
    OccurrenceCompletions,
    Placements,
    Links,
    CoreValues,
    NodeValues,
    Tags,
    NodeTags,
    Attachments,
    Annotations,
    ChangeLog,
    Devices,
  ],
  include: {'search.drift'},
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens the on-device database in the app support folder
  /// (`%APPDATA%\...` on Windows, app-internal storage on Android).
  factory AppDatabase.open() => AppDatabase(
    driftDatabase(
      name: 'epa',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    ),
  );

  /// Bump on every schema change, add an `onUpgrade` step, then run
  /// `dart run drift_dev schema dump lib/data/database.dart drift_schemas/`
  /// and `dart run drift_dev schema generate drift_schemas/ test/generated_migrations/`.
  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // The search index's triggers need `nodes`, so it comes last.
    onCreate: (m) async {
      final search = <DatabaseSchemaEntity>[
        nodeSearch,
        nodesSearchInsert,
        nodesSearchDelete,
        nodesSearchUpdate,
      ];
      for (final e in allSchemaEntities) {
        if (!search.contains(e)) await m.create(e);
      }
      for (final e in search) {
        await m.create(e);
      }
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Creates `nodes` with today's columns, so v3's are included.
        await m.createTable(nodes);
        await m.createIndex(nodesParentSort);
        await m.createTable(changeLog);
        await m.createIndex(changeLogHlc);
        await m.createIndex(changeLogField);
        await _backfillChangeLogV2();
      }
      if (from == 2) {
        await m.addColumn(nodes, nodes.dueDate);
      }
      if (from < 3) {
        await _retireNodeTypesV3();
      }
      if (from == 2 || from == 3) {
        await m.addColumn(nodes, nodes.repeatStart);
        await m.addColumn(nodes, nodes.exclusiveChildren);
      }
      if (from < 4) {
        await m.createTable(occurrenceCompletions);
        await m.createIndex(occurrenceCompletionsNode);
      }
      if (from < 5) {
        await m.createTable(placements);
        await m.createIndex(placementsParent);
        await m.createIndex(placementsNode);
      }
      if (from < 6) {
        await m.createTable(links);
        await m.createIndex(linksUnique);
        await m.createIndex(linksTarget);
      }
      // Before v2 the nodes table is created whole, with this column.
      if (from >= 2 && from < 7) {
        await m.addColumn(nodes, nodes.sharedWithChildren);
      }
      if (from < 8) {
        await m.createTable(coreValues);
        await m.createTable(nodeValues);
        await m.createIndex(nodeValuesNode);
        await m.createIndex(nodeValuesValue);
        await m.createTable(tags);
        await m.createTable(nodeTags);
        await m.createIndex(nodeTagsNode);
        await m.createIndex(nodeTagsTag);
        await m.createTable(nodeSearch);
        await m.createTrigger(nodesSearchInsert);
        await m.createTrigger(nodesSearchDelete);
        await m.createTrigger(nodesSearchUpdate);
        await customStatement(
          "INSERT INTO node_search(node_search) VALUES ('rebuild')",
        );
      }
      // v8 creates `tags` whole, with these columns.
      if (from == 8) {
        await m.addColumn(tags, tags.favorite);
        await m.addColumn(tags, tags.kept);
      }
      if (from < 10) {
        await m.createTable(attachments);
        await m.createIndex(attachmentsNode);
        await m.createTable(annotations);
        await m.createIndex(annotationsAttachment);
        await m.createTable(attachmentSearch);
      }
    },
  );

  Future<ChangeWriter?> _thisDeviceWriter() async {
    final device = await (select(
      devices,
    )..where((d) => d.isThisDevice.equals(true))).getSingleOrNull();
    if (device == null) return null;
    return ChangeWriter.open(
      this,
      userId: device.userId,
      deviceId: device.deviceId,
    );
  }

  /// v0.4 made list, routine, event and inbox item features of a task rather
  /// than types. Former lists keep their layout as "show as list". (Notes
  /// stay notes: v0.5 kept them as the one non-task type.)
  Future<void> _retireNodeTypesV3() async {
    final rows = await customSelect(
      "SELECT id, type, child_view FROM nodes "
      "WHERE type IN ('list', 'routine', 'event', 'inboxItem')",
    ).get();
    if (rows.isEmpty) return;
    final writer = await _thisDeviceWriter();
    if (writer == null) return;
    for (final row in rows) {
      final wasList =
          row.read<String>('type') == 'list' &&
          row.readNullable<String>('child_view') == null;
      await writer.update(
        nodes,
        row.read<String>('id'),
        NodesCompanion(
          type: const Value(NodeType.task),
          childView: wasList
              ? const Value(ChildView.checklist)
              : const Value.absent(),
        ),
      );
    }
  }

  /// v1 wrote synced rows without a change log. Record ops for them now so
  /// they will sync like every later write.
  Future<void> _backfillChangeLogV2() async {
    final writer = await _thisDeviceWriter();
    if (writer == null) return;
    for (final row in await select(spaces).get()) {
      await writer.recordExisting(spaces, row);
    }
    for (final row in await select(users).get()) {
      await writer.recordExisting(users, row);
    }
    for (final row in await select(spaceMembers).get()) {
      await writer.recordExisting(spaceMembers, row);
    }
  }
}

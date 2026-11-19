import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/ids.dart';
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
    Reminders,
    NodeUserPrefs,
    TimeEntries,
    Activity,
    TodayEntries,
    UserSettings,
    CounterTicks,
    ChangeLog,
    Devices,
    PendingUnknownOps,
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
  int get schemaVersion => 16;

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
      if (from < 11) {
        await m.createTable(reminders);
        await m.createIndex(remindersNode);
        await m.createTable(nodeUserPrefs);
        await m.createIndex(nodeUserPrefsNode);
      }
      if (from < 12) {
        await m.createTable(timeEntries);
        await m.createIndex(timeEntriesNode);
        await m.createIndex(timeEntriesStarted);
        await m.createTable(activity);
        await m.createIndex(activityAt);
        await m.createIndex(activityNode);
      }
      if (from < 13) {
        await m.createTable(todayEntries);
        await m.createIndex(todayEntriesDate);
        await m.createTable(userSettings);
      }
      // Before v2 the nodes table is created whole, with this column.
      if (from >= 2 && from < 12) {
        await m.addColumn(nodes, nodes.progressOverride);
      }
      if (from < 14) {
        await m.createTable(counterTicks);
        await m.createIndex(counterTicksNode);
      }
      if (from >= 2 && from < 14) {
        await m.addColumn(nodes, nodes.completion);
        await m.addColumn(nodes, nodes.target);
      }
      if (from >= 2 && from < 15) {
        await m.addColumn(nodes, nodes.counterTarget);
        await m.addColumn(nodes, nodes.timerMinutes);
      }
      if (from < 16) {
        // v0.23 (M7): paired rows get derived ids instead of a unique
        // index; the change log is rebuilt from the rows as they are.
        await customStatement('DROP INDEX IF EXISTS links_unique');
        await m.createIndex(linksFrom);
        await m.createTable(pendingUnknownOps);
        await m.addColumn(devices, devices.lastSyncAt);
      }
      if (from == 14) {
        // v0.21: requirements instead of one condition. A counter or timer
        // keeps its target; "mark done" is gone (one checkbox does it).
        await customStatement(
          "UPDATE nodes SET counter_target = target WHERE completion = 'counter'",
        );
        await customStatement(
          "UPDATE nodes SET timer_minutes = target WHERE completion = 'timer'",
        );
        await customStatement(
          "UPDATE nodes SET completion = NULL "
          "WHERE completion IN ('counter', 'timer', 'markDone')",
        );
      }
      if (from >= 2 && from < 16) {
        await _rekeyPairsV16();
        await _rebuildChangeLogV16();
      }
    },
  );

  /// Rows that stand for a pair, and the columns that make up the pair
  /// (§7.6, L1). Their ids are `pairId(table, [those columns])`.
  static const pairColumns = {
    'node_tags': ['node_id', 'tag_id'],
    'node_values': ['node_id', 'value_id'],
    'links': ['from_node_id', 'target_kind', 'target_id'],
    'placements': ['node_id', 'parent_node_id'],
    'reminders': ['node_id', 'minutes_before'],
    'today_entries': ['date', 'node_id'],
    'node_user_prefs': ['node_id'],
    'user_settings': ['key'],
    'occurrence_completions': ['node_id', 'occurrence_date'],
  };

  /// v16: gives every paired row its derived id. Where one pair has several
  /// rows (made before ids were derived), the live one with the newest
  /// change is kept and the others are removed: nothing has synced yet.
  Future<void> _rekeyPairsV16() async {
    for (final MapEntry(key: table, value: cols) in pairColumns.entries) {
      final rows = await customSelect(
        'SELECT id, deleted, hlc, ${cols.join(', ')} FROM $table',
      ).get();
      final groups = <String, List<QueryRow>>{};
      for (final r in rows) {
        final id = pairId(table, [for (final c in cols) r.data[c]]);
        (groups[id] ??= []).add(r);
      }
      for (final MapEntry(key: id, value: group) in groups.entries) {
        group.sort((a, b) {
          final live = a.read<bool>('deleted') == b.read<bool>('deleted')
              ? 0
              : (a.read<bool>('deleted') ? 1 : -1);
          if (live != 0) return live;
          return b.read<String>('hlc').compareTo(a.read<String>('hlc'));
        });
        final keep = group.first.read<String>('id');
        for (final r in group.skip(1)) {
          await customStatement('DELETE FROM $table WHERE id = ?', [
            r.read<String>('id'),
          ]);
        }
        if (keep != id) {
          await customStatement('UPDATE $table SET id = ? WHERE id = ?', [
            id,
            keep,
          ]);
        }
      }
    }
  }

  /// v16: nothing has synced yet, and some earlier migrations changed rows
  /// without recording ops; so the change log is rebuilt from the rows: one
  /// op per field, stamped with the row's own HLC and author.
  Future<void> _rebuildChangeLogV16() async {
    final device = await (select(
      devices,
    )..where((d) => d.isThisDevice.equals(true))).getSingleOrNull();
    if (device == null) return;
    await customStatement('DELETE FROM change_log');
    for (final t in syncedTables) {
      for (final r in await customSelect(
        'SELECT * FROM ${t.actualTableName}',
      ).get()) {
        await ChangeWriter.recordRaw(
          this,
          table: t.actualTableName,
          values: r.data,
          deviceId: device.deviceId,
        );
      }
    }
  }

  /// Every table that syncs: the ones with the sync columns (§5; not the
  /// change log, which has an `hlc` too).
  Iterable<TableInfo<Table, dynamic>> get syncedTables => allTables.where((t) {
    final cols = {for (final c in t.$columns) c.name};
    return cols.containsAll(const ['hlc', 'deleted', 'space_id', 'id']);
  });

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

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/domain/ids.dart';
import 'package:flutter_test/flutter_test.dart';

import '../generated_migrations/schema.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  for (final from in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]) {
    test(
      'upgrading v$from to the current version gives exactly its schema',
      () async {
        final schema = await verifier.schemaAt(from);
        final db = AppDatabase(schema.newConnection());
        await verifier.migrateAndValidate(db, db.schemaVersion);
        await db.close();
      },
    );
  }

  test('v2 nodes with retired types become tasks (lists keep their layout, notes stay notes)', () async {
    final schema = await verifier.schemaAt(2);
    const now = '2026-11-06T23:05:52.332Z';
    String node(String id, String type, {String childView = 'NULL'}) =>
        '''
      INSERT INTO nodes (id, space_id, created_at, created_by, updated_by, hlc,
        deleted, parent_id, sort_key, type, title, body_md, body_format,
        child_view, status, lifecycle)
      VALUES ('$id', 'space-1', '$now', 'user-1', 'user-1',
        '001794006352333-0000-device-1', 0, NULL, 'a0', '$type', '$id', '',
        'md_lww', $childView, 'open', 'live');''';
    schema.rawDatabase.execute('''
      INSERT INTO devices (device_id, user_id, device_public_key,
        signed_by_user_key, label, is_this_device)
      VALUES ('device-1', 'user-1', 'ZGV2aWNl', 'c2ln', NULL, 1);
      ${node('shopping', 'list')}
      ${node('packing', 'list', childView: "'steps'")}
      ${node('gym', 'routine')}
      ${node('dentist', 'event')}
      ${node('jot', 'note')}
      ${node('capture', 'inboxItem')}
      ${node('someday', 'idea')}
      ${node('garden', 'project')}
    ''');

    final db = AppDatabase(schema.newConnection());
    final rows = await db
        .customSelect('SELECT id, type, child_view FROM nodes ORDER BY id')
        .get();
    final byId = {
      for (final r in rows)
        r.read<String>('id'): (
          r.read<String>('type'),
          r.readNullable<String>('child_view'),
        ),
    };
    expect(byId, {
      'capture': ('task', null),
      'dentist': ('task', null),
      'garden': ('project', null),
      'gym': ('task', null),
      'jot': ('note', null),
      'packing': ('task', 'steps'),
      'shopping': ('task', 'checklist'),
      'someday': ('idea', null),
    });

    // v16 rebuilt the change log from the rows: every row's current
    // fields, so the conversions sync like everything else.
    final ops = await (db.select(
      db.changeLog,
    )..where((o) => o.columnName.equals('type'))).get();
    expect(
      {for (final o in ops) o.rowId: jsonDecode(o.value)},
      {for (final MapEntry(:key, :value) in byId.entries) key: value.$1},
    );
    await db.close();
  });

  test('v1 identity rows get change-log ops when upgrading to v2', () async {
    final schema = await verifier.schemaAt(1);

    // A v1 install: written straight to the tables, with no change log.
    const created = '2026-11-06T23:05:52.332Z';
    const hlc = '001794006352333-0000-device-1';
    schema.rawDatabase.execute('''
      INSERT INTO spaces (id, space_id, created_at, created_by, updated_by,
        hlc, deleted, kind)
      VALUES ('space-1', 'space-1', '$created', 'user-1', 'user-1', '$hlc', 0,
        'personal');
      INSERT INTO users (id, space_id, created_at, created_by, updated_by, hlc,
        deleted, identity_public_key)
      VALUES ('user-1', 'space-1', '$created', 'user-1', 'user-1', '$hlc', 0,
        'cHVibGlj');
      INSERT INTO space_members (id, space_id, created_at, created_by,
        updated_by, hlc, deleted, user_id, role, joined_at)
      VALUES ('member-1', 'space-1', '$created', 'user-1', 'user-1', '$hlc', 0,
        'user-1', 'owner', '$created');
      INSERT INTO devices (device_id, user_id, device_public_key,
        signed_by_user_key, label, is_this_device)
      VALUES ('device-1', 'user-1', 'ZGV2aWNl', 'c2ln', NULL, 1);
    ''');

    final db = AppDatabase(schema.newConnection());
    final ops = await db.select(db.changeLog).get();

    expect(ops.map((o) => o.rowId).toSet(), {'space-1', 'user-1', 'member-1'});
    expect(ops.map((o) => o.hlc).toSet(), {hlc});
    expect(ops.map((o) => o.originDeviceId).toSet(), {'device-1'});
    final kind = ops.singleWhere(
      (o) => o.rowId == 'space-1' && o.columnName == 'kind',
    );
    expect(jsonDecode(kind.value), 'personal');
    final role = ops.singleWhere(
      (o) => o.rowId == 'member-1' && o.columnName == 'role',
    );
    expect(jsonDecode(role.value), 'owner');

    // The rows themselves are untouched.
    final user = await db.select(db.users).getSingle();
    expect(user.hlc, hlc);
    expect(user.createdAt, DateTime.parse(created));
    await db.close();
  });

  test('v15 → v16: paired rows get derived ids, duplicates merge', () async {
    final schema = await verifier.schemaAt(15);
    const now = '2026-11-06T23:05:52.332Z';
    String row(String id, String deleted, String hlc) =>
        "'$id', 'space-1', '$now', 'user-1', 'user-1', '$hlc', $deleted";
    schema.rawDatabase.execute("""
      INSERT INTO devices (device_id, user_id, device_public_key,
        signed_by_user_key, label, is_this_device)
      VALUES ('device-1', 'user-1', 'ZGV2aWNl', 'c2ln', NULL, 1);
      INSERT INTO node_tags (id, space_id, created_at, created_by, updated_by,
        hlc, deleted, node_id, tag_id, origin)
      VALUES (${row('old-dead', '1', '001794006352333-0000-device-1')},
          'n1', 't1', 'attached'),
        (${row('old-live', '0', '001794006352300-0000-device-1')},
          'n1', 't1', 'attached'),
        (${row('other', '0', '001794006352333-0000-device-1')},
          'n2', 't1', 'inline');
      INSERT INTO links (id, space_id, created_at, created_by, updated_by,
        hlc, deleted, from_node_id, target_kind, target_id, origin)
      VALUES (${row('link-1', '0', '001794006352333-0000-device-1')},
        'n1', 'node', 'n2', 'inline');
    """);

    final db = AppDatabase(schema.newConnection());
    final tags = await db.select(db.nodeTags).get();
    expect(tags.map((t) => t.id).toSet(), {
      pairId('node_tags', ['n1', 't1']),
      pairId('node_tags', ['n2', 't1']),
    });
    // The live row was kept for n1.
    expect(tags.singleWhere((t) => t.nodeId == 'n1').deleted, isFalse);
    final link = await db.select(db.links).getSingle();
    expect(link.id, pairId('links', ['n1', 'node', 'n2']));

    // The unique index is gone; the log holds the new ids only.
    final indexes = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
        .get();
    final names = indexes.map((r) => r.read<String>('name')).toSet();
    expect(names, contains('links_from'));
    expect(names, isNot(contains('links_unique')));
    final opRows = (await db.select(db.changeLog).get())
        .where((o) => o.rowTable == 'node_tags')
        .map((o) => o.rowId)
        .toSet();
    expect(opRows, tags.map((t) => t.id).toSet());
    await db.close();
  });
}

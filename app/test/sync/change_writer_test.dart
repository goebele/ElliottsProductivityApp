import 'dart:convert';

import 'package:drift/drift.dart' hide isNull;
import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/sync/change_writer.dart';
import 'package:elliotts_productivity_app/sync/hlc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_support.dart';

void main() {
  late TestEnv env;
  setUp(() async => env = await TestEnv.create());
  tearDown(() => env.close());

  test('an insert records one op per field, all with the row HLC', () async {
    final id = await env.nodes.create(title: 'Write report');
    final node = (await env.nodes.get(id))!;
    final ops = await env.opsFor(id);
    final byColumn = {for (final op in ops) op.columnName: op};

    expect(byColumn.keys, isNot(contains('id')));
    expect(byColumn.keys, isNot(contains('hlc')));
    expect(byColumn.keys, isNot(contains('updated_by')));
    expect(byColumn.keys,
        containsAll(['title', 'space_id', 'parent_id', 'sort_key', 'created_at']));
    expect(jsonDecode(byColumn['title']!.value), 'Write report');
    expect(jsonDecode(byColumn['type']!.value), 'task');
    expect(jsonDecode(byColumn['parent_id']!.value), isNull);
    expect(ops.map((o) => o.hlc).toSet(), {node.hlc});
    expect(ops.map((o) => o.rowTable).toSet(), {'nodes'});
    expect(ops.map((o) => o.spaceId).toSet(), {env.identity.personalSpaceId});
    expect(ops.map((o) => o.authorUserId).toSet(), {env.identity.userId});
    expect(ops.map((o) => o.originDeviceId).toSet(), {env.identity.deviceId});
  });

  test('an update records only the changed fields with a newer HLC', () async {
    final id = await env.nodes.create(title: 'Old');
    final before = (await env.nodes.get(id))!;
    await env.nodes.rename(id, 'New');
    final after = (await env.nodes.get(id))!;

    expect(after.title, 'New');
    expect(Hlc.parse(after.hlc).compareTo(Hlc.parse(before.hlc)),
        greaterThan(0));
    final updateOps =
        (await env.opsFor(id)).where((o) => o.hlc == after.hlc).toList();
    expect(updateOps.map((o) => o.columnName), ['title']);
    expect(jsonDecode(updateOps.single.value), 'New');
  });

  test('dates are logged exactly as stored', () async {
    final id = await env.nodes.create(title: 'Task');
    await env.nodes.setStatus(id, NodeStatus.done,
        now: DateTime.utc(2026, 11, 6, 12, 30, 15, 250));
    final op = (await env.opsFor(id))
        .lastWhere((o) => o.columnName == 'completed_at');
    final stored = await env.db
        .customSelect('SELECT completed_at FROM nodes WHERE id = ?',
            variables: [Variable.withString(id)])
        .getSingle();
    expect(jsonDecode(op.value), stored.read<String>('completed_at'));
  });

  test('updating a missing row fails and logs nothing', () async {
    final before = await env.db.select(env.db.changeLog).get();
    await expectLater(
      env.nodes.rename('no-such-node', 'x'),
      throwsStateError,
    );
    expect(await env.db.select(env.db.changeLog).get(), hasLength(before.length));
  });

  test('a reopened writer issues stamps after the ones already logged',
      () async {
    final id = await env.nodes.create(title: 'A');
    final last = (await env.nodes.get(id))!.hlc;

    final reopened = await ChangeWriter.open(
      env.db,
      userId: env.identity.userId,
      deviceId: env.identity.deviceId,
    );
    await reopened.update(
        env.db.nodes, id, const NodesCompanion(title: Value('B')));
    final next = (await env.nodes.get(id))!.hlc;
    expect(next.compareTo(last), greaterThan(0));
  });
}

import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/domain/node_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_support.dart';

void main() {
  late TestEnv env;
  late NodeRepository nodes;
  setUp(() async {
    env = await TestEnv.create();
    nodes = env.nodes;
  });
  tearDown(() => env.close());

  Future<List<String>> titles(String? parentId) async =>
      [for (final n in await nodes.children(parentId)) n.title];

  test('creates top-level nodes in the personal space, in order', () async {
    await nodes.create(title: 'A');
    await nodes.create(title: 'B');
    await nodes.create(title: 'Start', index: 0);
    await nodes.create(title: 'Middle', index: 2);

    expect(await titles(null), ['Start', 'A', 'Middle', 'B']);
    final a = (await nodes.children(null))[1];
    expect(a.spaceId, env.identity.personalSpaceId);
    expect(a.parentId, isNull);
    expect(a.status, NodeStatus.open);
    expect(a.lifecycle, Lifecycle.live);
    expect(a.createdBy, env.identity.userId);
  });

  test('nests as deep as you like and children take the parent space',
      () async {
    String? parent;
    final ids = <String>[];
    for (var depth = 0; depth < 25; depth++) {
      parent = await nodes.create(title: 'Level $depth', parentId: parent);
      ids.add(parent);
    }
    final deepest = (await nodes.get(ids.last))!;
    expect(deepest.spaceId, env.identity.personalSpaceId);

    final ancestors = await nodes.ancestors(ids.last);
    expect(ancestors.map((n) => n.id), ids.sublist(0, 24));
    expect(ancestors.first.title, 'Level 0');
  });

  test('reorders within a parent', () async {
    final project = await nodes.create(title: 'Project');
    final a = await nodes.create(title: 'A', parentId: project);
    await nodes.create(title: 'B', parentId: project);
    await nodes.create(title: 'C', parentId: project);

    await nodes.move(a, newParentId: project); // to the end
    expect(await titles(project), ['B', 'C', 'A']);

    await nodes.move(a, newParentId: project, index: 1);
    expect(await titles(project), ['B', 'A', 'C']);

    await nodes.move(a, newParentId: project, index: 0);
    expect(await titles(project), ['A', 'B', 'C']);
  });

  test('moves to another parent or to the top level', () async {
    final p1 = await nodes.create(title: 'P1');
    final p2 = await nodes.create(title: 'P2');
    final task = await nodes.create(title: 'Task', parentId: p1);
    await nodes.create(title: 'Sub', parentId: task);

    await nodes.move(task, newParentId: p2);
    expect(await titles(p1), isEmpty);
    expect(await titles(p2), ['Task']);
    expect(await titles(task), ['Sub'], reason: 'children move with it');

    await nodes.move(task, index: 0);
    expect(await titles(null), ['Task', 'P1', 'P2']);
  });

  test('rejects moves that would create a cycle', () async {
    final a = await nodes.create(title: 'A');
    final b = await nodes.create(title: 'B', parentId: a);
    final c = await nodes.create(title: 'C', parentId: b);

    expect(() => nodes.move(a, newParentId: a),
        throwsA(isA<MoveWouldCreateCycleException>()));
    expect(() => nodes.move(a, newParentId: c),
        throwsA(isA<MoveWouldCreateCycleException>()));
    expect((await nodes.get(a))!.parentId, isNull);
  });

  test('a move changes only parent_id and sort_key', () async {
    final p = await nodes.create(title: 'P');
    final t = await nodes.create(title: 'T');
    await nodes.move(t, newParentId: p);
    final node = (await nodes.get(t))!;
    final moveOps =
        (await env.opsFor(t)).where((o) => o.hlc == node.hlc).toList();
    expect(moveOps.map((o) => o.columnName).toSet(), {'parent_id', 'sort_key'});
  });

  test('completing sets and clears the completion fields', () async {
    final t = await nodes.create(title: 'T');
    await nodes.setStatus(t, NodeStatus.done);
    var node = (await nodes.get(t))!;
    expect(node.status, NodeStatus.done);
    expect(node.completedAt, isNotNull);
    expect(node.completedBy, env.identity.userId);

    await nodes.setStatus(t, NodeStatus.open);
    node = (await nodes.get(t))!;
    expect(node.completedAt, isNull);
    expect(node.completedBy, isNull);
  });

  test('a type change keeps everything else (promote a task to a project)',
      () async {
    final t = await nodes.create(title: 'Idea', type: NodeType.idea);
    await nodes.setBody(t, '# Notes');
    await nodes.setType(t, NodeType.project);
    final node = (await nodes.get(t))!;
    expect(node.type, NodeType.project);
    expect(node.bodyMd, '# Notes');
  });

  test('watchChildren emits after writes', () async {
    final p = await nodes.create(title: 'P');
    final stream = nodes.watchChildren(p).map((l) => [for (final n in l) n.title]);
    final expectation = expectLater(
      stream,
      emitsInOrder([<String>[], ['X'], ['X', 'Y']]),
    );
    await pumpEventQueue();
    await nodes.create(title: 'X', parentId: p);
    await pumpEventQueue();
    await nodes.create(title: 'Y', parentId: p);
    await expectation;
  });

  test('add-ons: deadline, time slot, repeat and list layout', () async {
    final t = await nodes.create(title: 'Gym');

    await nodes.setDueDate(t, DateTime(2026, 11, 14, 18, 45));
    expect((await nodes.get(t))!.dueDate, '2026-11-14');
    expect(parseDateKey('2026-11-14'), DateTime(2026, 11, 14));

    final start = DateTime(2026, 11, 13, 7);
    await nodes.setSchedule(t,
        start: start, end: start.add(const Duration(hours: 1)));
    var node = (await nodes.get(t))!;
    expect(node.startAt, start.toUtc());
    expect(node.endAt!.difference(node.startAt!), const Duration(hours: 1));

    await nodes.setRepeat(t, 'FREQ=WEEKLY;BYDAY=MO,WE,FR');
    await nodes.setShowAsList(t, true);
    node = (await nodes.get(t))!;
    expect(node.rrule, 'FREQ=WEEKLY;BYDAY=MO,WE,FR');
    expect(node.childView, ChildView.checklist);
    expect(node.type, NodeType.task, reason: 'add-ons never change the type');

    await nodes.setDueDate(t, null);
    await nodes.setSchedule(t);
    await nodes.setRepeat(t, null);
    await nodes.setShowAsList(t, false);
    node = (await nodes.get(t))!;
    expect([node.dueDate, node.startAt, node.endAt, node.rrule, node.childView],
        everyElement(isNull));
  });

  test('notes under an item are kept apart from its items', () async {
    final trip = await nodes.create(title: 'Trip');
    await nodes.create(title: 'Book hotel', parentId: trip);
    await nodes.create(title: 'Ideas', type: NodeType.note, parentId: trip);
    final topNote = await nodes.create(title: 'Loose', type: NodeType.note);

    expect((await nodes.children(trip)).map((n) => n.title), ['Book hotel']);
    expect((await nodes.notes(trip)).map((n) => n.title), ['Ideas']);
    // No notes column at the top level, so top-level notes stay visible.
    expect((await nodes.children(null)).map((n) => n.id), contains(topNote));

    final counts = await nodes.watchChildrenWithCounts(null).first;
    final tripRow = counts.singleWhere((c) => c.node.id == trip);
    expect(tripRow.childCount, 1);
    expect(tripRow.noteCount, 1);
  });

  test('setDates saves all date fields in one change', () async {
    final t = await nodes.create(title: 'Standup');
    final start = DateTime(2026, 11, 9, 9);
    await nodes.setDates(
      t,
      NodeDates(
        dueDate: DateTime(2026, 11, 30),
        start: start,
        end: start.add(const Duration(minutes: 15)),
        rrule: 'FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR',
      ),
    );
    final node = (await nodes.get(t))!;
    expect(node.dueDate, '2026-11-30');
    expect(node.startAt, start.toUtc());
    expect(node.rrule, 'FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR');
    final ops = (await env.opsFor(t)).where((o) => o.hlc == node.hlc);
    expect(ops.map((o) => o.columnName).toSet(),
        {'due_date', 'start_at', 'end_at', 'rrule', 'repeat_start',
          'exclusive_children'});

    await nodes.setDates(t, const NodeDates());
    final cleared = (await nodes.get(t))!;
    expect([cleared.dueDate, cleared.startAt, cleared.endAt, cleared.rrule],
        everyElement(isNull));
  });

  test('the workout: children take turns and completions drive the pick',
      () async {
    final workout = await nodes.create(title: 'Workout', type: NodeType.goal);
    final arms = await nodes.create(title: 'Arms', parentId: workout);
    final core = await nodes.create(title: 'Core', parentId: workout);
    await nodes.create(title: 'Legs', parentId: workout);
    await nodes.setRepeat(arms, 'FREQ=DAILY;INTERVAL=3');
    await nodes.setDates(
      workout,
      NodeDates(
        rrule: 'FREQ=DAILY',
        repeatStart: DateTime(2026, 11, 1),
        exclusiveChildren: true,
      ),
    );

    var status = (await nodes.exclusiveStatus(workout, today: DateTime(2026, 11, 1)))!;
    expect((status.state as ExclusiveDue).childId, arms);

    await nodes.completeOccurrence(arms, DateTime(2026, 11, 1));
    await nodes.completeOccurrence(arms, DateTime(2026, 11, 1)); // no-op
    status = (await nodes.exclusiveStatus(workout, today: DateTime(2026, 11, 1)))!;
    expect(status.state, isA<ExclusiveDone>());
    expect(status.lastDone[arms], DateTime(2026, 11, 1));

    status = (await nodes.exclusiveStatus(workout, today: DateTime(2026, 11, 2)))!;
    expect((status.state as ExclusiveDue).childId, core);

    // Undo is a tombstone, so it syncs; the pick goes back to Arms.
    await nodes.uncompleteOccurrence(arms, DateTime(2026, 11, 1));
    status = (await nodes.exclusiveStatus(workout, today: DateTime(2026, 11, 1)))!;
    expect((status.state as ExclusiveDue).childId, arms);
    final rows = await env.db.select(env.db.occurrenceCompletions).get();
    expect(rows.single.deleted, isTrue);
  });

  test('removing a repeat also clears its start and one-at-a-time', () async {
    final t = await nodes.create(title: 'Workout');
    await nodes.setDates(
      t,
      NodeDates(
          rrule: 'FREQ=DAILY',
          repeatStart: DateTime(2026, 11, 1),
          exclusiveChildren: true),
    );
    var node = (await nodes.get(t))!;
    expect([node.repeatStart, node.exclusiveChildren], ['2026-11-01', true]);
    expect(await nodes.exclusiveStatus(t, today: DateTime(2026, 11, 2)),
        isNotNull);

    await nodes.setRepeat(t, null);
    node = (await nodes.get(t))!;
    expect([node.rrule, node.repeatStart, node.exclusiveChildren],
        [null, null, false]);
    expect(await nodes.exclusiveStatus(t, today: DateTime(2026, 11, 2)),
        isNull);
  });

  test('a routine reports its current occurrence and whether it was done',
      () async {
    final t = await nodes.create(title: 'Stretch');
    await nodes.setDates(t,
        NodeDates(rrule: 'FREQ=WEEKLY;BYDAY=MO,TH', repeatStart: DateTime(2026, 11, 2)));

    // Sat Nov 7 belongs to Thursday Nov 5's occurrence.
    final sat = DateTime(2026, 11, 7);
    var occ = (await nodes.occurrenceStatus(t, today: sat))!;
    expect([occ.period, occ.done], [DateTime(2026, 11, 5), false]);

    await nodes.completeOccurrence(t, occ.period!);
    occ = (await nodes.occurrenceStatus(t, today: sat))!;
    expect(occ.done, isTrue);
    expect((await nodes.get(t))!.status, NodeStatus.open,
        reason: 'the routine keeps going');

    // Monday is a new occurrence, not done yet.
    occ = (await nodes.occurrenceStatus(t, today: DateTime(2026, 11, 9)))!;
    expect([occ.period, occ.done], [DateTime(2026, 11, 9), false]);
  });

  test('before a routine starts there is no current occurrence', () async {
    final t = await nodes.create(title: 'Swim');
    await nodes.setDates(
        t, NodeDates(rrule: 'FREQ=DAILY', repeatStart: DateTime(2026, 12, 1)));
    final today = DateTime(2026, 11, 8);
    final occ = (await nodes.occurrenceStatus(t, today: today))!;
    expect(occ.period, isNull);
    expect(occ.seriesStart, DateTime(2026, 12, 1));
    expect(await nodes.occurrenceStatus(
        await nodes.create(title: 'Plain'), today: today), isNull);
  });

  test('archive hides a whole subtree; restore brings back that group',
      () async {
    final project = await nodes.create(title: 'Project');
    final task = await nodes.create(title: 'Task', parentId: project);
    final sub = await nodes.create(title: 'Sub', parentId: task);
    await nodes.create(title: 'Ideas', type: NodeType.note, parentId: project);
    final early = await nodes.create(title: 'Early', parentId: project);
    await nodes.archive(early); // archived on its own first

    expect(await nodes.subtreeSize(project), 3, reason: 'task, sub, note');
    await nodes.archive(project);
    expect(await titles(null), isEmpty);
    final s = (await nodes.get(sub))!;
    expect([s.lifecycle, s.lifecycleRootId], [Lifecycle.archived, project]);

    final groups = await nodes.removedGroups(Lifecycle.archived);
    expect({for (final g in groups) g.root.title: g.others},
        {'Project': 3, 'Early': 0});
    expect(groups.firstWhere((g) => g.root.id == early).parentTitle,
        'Project');

    expect(await nodes.restore(project), isFalse);
    expect(await titles(null), ['Project']);
    expect(await titles(project), ['Task']);
    expect(await titles(task), ['Sub']);
    expect((await nodes.get(early))!.lifecycle, Lifecycle.archived,
        reason: 'archived separately, so it stays archived');
  });

  test('trash, purge, and restoring an item whose parent is gone', () async {
    final p = await nodes.create(title: 'P');
    final child = await nodes.create(title: 'Child', parentId: p);
    await nodes.archive(child);
    await nodes.trash(p);
    expect(await nodes.removedGroups(Lifecycle.trashed),
        [isA<RemovedGroup>().having((g) => g.root.id, 'root', p)]);

    // Its old parent is in Trash, so it comes back at the top level.
    expect(await nodes.restore(child), isTrue);
    expect(await titles(null), ['Child']);

    await nodes.emptyTrash();
    expect((await nodes.get(p))!.deleted, isTrue);
    expect(await nodes.removedGroups(Lifecycle.trashed), isEmpty);
  });

  test('an archived group moves to Trash whole; old Trash is purged',
      () async {
    final p = await nodes.create(title: 'P');
    final c = await nodes.create(title: 'C', parentId: p);
    await nodes.archive(p);
    await nodes.trash(p, now: DateTime(2026, 10, 1));
    expect((await nodes.get(c))!.lifecycle, Lifecycle.trashed);
    final fresh = await nodes.create(title: 'Fresh');
    await nodes.trash(fresh, now: DateTime(2026, 11, 7));

    await nodes.purgeExpiredTrash(now: DateTime(2026, 11, 8));
    expect((await nodes.get(p))!.deleted, isTrue);
    expect((await nodes.get(c))!.deleted, isTrue);
    expect((await nodes.get(fresh))!.deleted, isFalse);
  });

  test('a type this version does not know reads as a task and is kept',
      () async {
    final t = await nodes.create(title: 'From the future');
    await env.db.customStatement(
        "UPDATE nodes SET type = 'quest', status = 'snoozed' WHERE id = '$t'");
    final node = (await nodes.get(t))!;
    expect(node.type, NodeType.task);
    expect(node.status, NodeStatus.open);

    await nodes.rename(t, 'Renamed');
    final raw = await env.db
        .customSelect("SELECT type FROM nodes WHERE id = '$t'")
        .getSingle();
    expect(raw.read<String>('type'), 'quest',
        reason: 'unknown values survive edits to other fields');
  });
}

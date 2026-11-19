import 'package:elliotts_productivity_app/domain/ids.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_support.dart';

/// Paired rows have ids derived from the pair (§7.6, L1), and the paused
/// timer is a synced setting (L10).
void main() {
  late TestEnv env;

  setUp(() async => env = await TestEnv.create());
  tearDown(() => env.close());

  test('pair ids are stable, distinct, and UUID-shaped', () {
    final a = pairId('node_tags', ['n1', 't1']);
    expect(pairId('node_tags', ['n1', 't1']), a);
    expect(pairId('node_tags', ['t1', 'n1']), isNot(a));
    expect(pairId('node_values', ['n1', 't1']), isNot(a));
    expect(
      pairId('placements', ['n1', null]),
      isNot(pairId('placements', ['n1', ''])),
    );
    expect(
      RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-8[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      ).hasMatch(a),
      isTrue,
    );
  });

  test('removing and re-adding a tag brings the same row back', () async {
    final n = await env.nodes.create(title: 'Report');
    await env.nodes.tags.add(n, 'work');
    final first = (await env.db.select(env.db.nodeTags).get()).single;
    expect(first.id, pairId('node_tags', [n, first.tagId]));
    await env.nodes.tags.remove(n, first.tagId);
    await env.nodes.tags.add(n, 'work');
    final rows = await env.db.select(env.db.nodeTags).get();
    expect(rows, hasLength(1));
    expect(rows.single.id, first.id);
    expect(rows.single.deleted, isFalse);
  });

  test('a shortcut, a value tie and a completion use derived ids', () async {
    final a = await env.nodes.create(title: 'A');
    final b = await env.nodes.create(title: 'B');
    final placement = await env.nodes.addPlacement(a, b);
    expect(placement, pairId('placements', [a, b]));

    final v = await env.nodes.values.create('Health');
    await env.nodes.values.tie(a, v);
    await env.nodes.values.untie(a, v);
    await env.nodes.values.tie(a, v);
    final ties = await env.db.select(env.db.nodeValues).get();
    expect(ties.single.id, pairId('node_values', [a, v]));

    final day = DateTime(2026, 11, 16);
    await env.nodes.completeOccurrence(a, day);
    await env.nodes.uncompleteOccurrence(a, day);
    await env.nodes.completeOccurrence(a, day);
    final done = await env.db.select(env.db.occurrenceCompletions).get();
    expect(done.single.id, pairId('occurrence_completions', [a, '2026-11-16']));
    expect(done.single.deleted, isFalse);
  });

  test(
    'pausing a timer is a synced setting; resume and stop clear it',
    () async {
      final n = await env.nodes.create(title: 'Write');
      final time = env.nodes.time;
      await time.start(n);
      await time.pause();
      expect(await time.pausedNodeId(), n);
      expect(await time.running(), isNull);
      final row = (await env.db.select(env.db.userSettings).get()).single;
      expect(row.id, pairId('user_settings', ['timer.paused']));
      expect(await env.opsFor(row.id), isNotEmpty, reason: 'it syncs');

      await time.resume();
      expect((await time.running())?.nodeId, n);
      expect(await time.pausedNodeId(), isNull);
    },
  );
}

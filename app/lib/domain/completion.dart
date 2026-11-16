import 'package:drift/drift.dart';

import '../data/database.dart';
import '../sync/change_writer.dart';
import 'ids.dart';
import 'node_repository.dart';
import 'time_tracking.dart';

/// A count against a target: ticked boxes, a counter, or minutes tracked.
typedef Tally = ({int value, int target});

/// Where a task stands against its requirements (§6.7.1): its checkboxes,
/// its counter and its timer, each only if it has one.
class RequirementsState {
  const RequirementsState({
    this.boxes,
    this.counter,
    this.timer,
    required this.done,
    this.occurrence,
  });

  /// Ticked checkboxes of all of them; null if it has none.
  final Tally? boxes;

  /// The counter, if it has one.
  final Tally? counter;

  /// Minutes tracked against the timer's minutes, if it has one.
  final Tally? timer;

  final bool done;

  /// For a repeating task: the occurrence (`YYYY-MM-DD`) this is for.
  final String? occurrence;

  /// No requirements yet: the task is to define it.
  bool get undefined => boxes == null && counter == null && timer == null;

  /// Every requirement it has is met (and it has at least one).
  bool get met =>
      !undefined &&
      (boxes == null || (boxes!.target > 0 && boxes!.value >= boxes!.target)) &&
      (counter == null || counter!.value >= counter!.target) &&
      (timer == null || timer!.value >= timer!.target);
}

/// Requirements (§6.7.1): what has to happen for a task to be done —
/// checkboxes (its items), a counter, a timer — and finishing it when they
/// are all met.
///
/// A **concrete** task is one Today can show: an item with no items under
/// it, or one whose items are its checkboxes (it has requirements). Items
/// of such a task are checkboxes, not tasks of their own.
class CompletionService {
  CompletionService(this._db, this._writer, this._nodes);

  final AppDatabase _db;
  final ChangeWriter _writer;
  final NodeRepository _nodes;

  /// Whether [node]'s items are its checkboxes: it has requirements.
  static bool hasRequirements(Node node) =>
      node.completion == CompletionKind.checklist ||
      node.counterTarget != null ||
      node.timerMinutes != null;

  /// Adds a checkbox to [nodeId] (a child item) and makes its items count
  /// as checkboxes. Returns the new item's id.
  Future<String> addCheckbox(String nodeId, String title) async {
    await _checkNoTasks(nodeId);
    final id = await _nodes.create(title: title, parentId: nodeId);
    final node = await _nodes.get(nodeId);
    if (node != null && node.completion != CompletionKind.checklist) {
      await _nodes.update(
        nodeId,
        const NodesCompanion(completion: Value(CompletionKind.checklist)),
      );
      await _nodes.setChildView(nodeId, ChildView.checklist);
    }
    await evaluate(nodeId);
    return id;
  }

  /// Gives [nodeId] a counter to [target], or removes it (null).
  Future<void> setCounter(String nodeId, int? target) async {
    if (target != null) await _checkNoTasks(nodeId);
    await _nodes.update(nodeId, NodesCompanion(counterTarget: Value(target)));
    await _markBoxes(nodeId);
    await evaluate(nodeId);
  }

  /// Gives [nodeId] a timer of [minutes], or removes it (null).
  Future<void> setTimer(String nodeId, int? minutes) async {
    if (minutes != null) await _checkNoTasks(nodeId);
    await _nodes.update(nodeId, NodesCompanion(timerMinutes: Value(minutes)));
    await _markBoxes(nodeId);
    await evaluate(nodeId);
  }

  /// A completion condition and tasks under it are exclusive (§6.7.1); a
  /// checkbox line can't have one either.
  Future<void> _checkNoTasks(String nodeId) async {
    final node = await _nodes.get(nodeId);
    if (node == null || hasRequirements(node)) return;
    if (await isCheckbox(node) ||
        (await _nodes.children(nodeId)).any((c) => c.type.isItem)) {
      throw const PlacementNotAllowedException(
        'A task with tasks under it is done through them.',
      );
    }
  }

  /// A task with any requirement shows its items as checkboxes; with none
  /// left, it's back to undecided.
  Future<void> _markBoxes(String nodeId) async {
    final node = await _nodes.get(nodeId);
    if (node == null) return;
    final boxes = (await _nodes.children(nodeId)).any((c) => c.type.isItem);
    final wants =
        node.counterTarget != null || node.timerMinutes != null || boxes;
    final kind = wants ? CompletionKind.checklist : null;
    if (node.completion != kind) {
      await _nodes.update(nodeId, NodesCompanion(completion: Value(kind)));
      if (wants) await _nodes.setChildView(nodeId, ChildView.checklist);
    }
  }

  /// Counts [delta] on [nodeId]'s counter (for today's occurrence if it
  /// repeats). Never below zero.
  Future<void> tick(String nodeId, {int delta = 1, DateTime? today}) async {
    final node = await _nodes.get(nodeId);
    if (node == null) return;
    final occ = await _nodes.occurrenceStatus(
      nodeId,
      today: today ?? DateTime.now(),
    );
    final key = occ?.period == null ? null : dateKey(occ!.period!);
    if (delta < 0 && await _count(nodeId, key) <= 0) return;
    await _writer.insert(
      _db.counterTicks,
      CounterTicksCompanion(
        id: Value(newId()),
        spaceId: Value(node.spaceId),
        nodeId: Value(nodeId),
        occurrenceDate: Value(key),
        delta: Value(delta),
        deleted: const Value(false),
      ),
    );
    await evaluate(nodeId, today: today);
  }

  Future<int> _count(String nodeId, String? occurrence) async {
    final rows =
        await (_db.select(_db.counterTicks)..where(
              (t) =>
                  t.nodeId.equals(nodeId) &
                  t.deleted.equals(false) &
                  (occurrence == null
                      ? t.occurrenceDate.isNull()
                      : t.occurrenceDate.equals(occurrence)),
            ))
            .get();
    return rows.fold<int>(0, (a, t) => a + t.delta);
  }

  /// Where [nodeId] stands today.
  Future<RequirementsState> state(String nodeId, {DateTime? today}) async {
    final day = today ?? DateTime.now();
    final node = await _nodes.get(nodeId);
    if (node == null) return const RequirementsState(done: false);
    final occ = await _nodes.occurrenceStatus(nodeId, today: day);
    final period = occ?.period;
    final key = period == null ? null : dateKey(period);
    final explicit = occ != null ? occ.done : isFinished(node.status);

    Tally? boxes;
    if (node.completion == CompletionKind.checklist) {
      final items = [
        for (final c in await _nodes.children(nodeId))
          if (c.type.isItem) c,
      ];
      if (items.isNotEmpty ||
          (node.counterTarget == null && node.timerMinutes == null)) {
        var ticked = 0;
        for (final b in items) {
          final o = await _nodes.occurrenceStatus(b.id, today: day);
          if (o != null ? o.done : isFinished(b.status)) ticked++;
        }
        boxes = (value: ticked, target: items.length);
      }
    }
    final counter = node.counterTarget == null
        ? null
        : (value: await _count(nodeId, key), target: node.counterTarget!);
    Tally? timer;
    if (node.timerMinutes case final minutes?) {
      // A repeat counts time since its occurrence began.
      final since = period == null
          ? DateTime.utc(2000)
          : DateTime(period.year, period.month, period.day).toUtc();
      final until = DateTime.now().toUtc().add(const Duration(days: 1));
      var tracked = 0;
      for (final e in await _nodes.time.of(nodeId)) {
        tracked += overlapSeconds(e, since, until) ~/ 60;
      }
      timer = (value: tracked, target: minutes);
    }
    final partial = RequirementsState(
      boxes: boxes,
      counter: counter,
      timer: timer,
      done: false,
      occurrence: key,
    );
    return RequirementsState(
      boxes: boxes,
      counter: counter,
      timer: timer,
      done: explicit || partial.met,
      occurrence: key,
    );
  }

  /// Finishes (or reopens) [nodeId] when all its requirements are (or no
  /// longer are) met, for today's occurrence if it repeats.
  Future<void> evaluate(String nodeId, {DateTime? today}) async {
    final node = await _nodes.get(nodeId);
    if (node == null ||
        !hasRequirements(node) ||
        node.status == NodeStatus.dropped) {
      return;
    }
    final day = today ?? DateTime.now();
    final met = (await state(nodeId, today: day)).met;
    final occ = await _nodes.occurrenceStatus(nodeId, today: day);
    if (occ != null) {
      final period = occ.period;
      if (period == null) return;
      final completed = await _nodes.hasCompletion(nodeId, period);
      if (met && !completed) await _nodes.completeOccurrence(nodeId, period);
      if (!met && completed) await _nodes.uncompleteOccurrence(nodeId, period);
      return;
    }
    final done = node.status == NodeStatus.done;
    if (met && !done) await _nodes.setStatus(nodeId, NodeStatus.done);
    if (!met && done) await _nodes.setStatus(nodeId, NodeStatus.open);
  }

  // ---------------------------------------------------------- concreteness

  /// A checkbox: an item of a task with requirements.
  Future<bool> isCheckbox(Node node) async {
    if (!node.type.isItem || node.parentId == null) return false;
    final parent = await _nodes.get(node.parentId!);
    return parent != null && hasRequirements(parent);
  }

  /// Whether Today can show [node] as a task of its own.
  Future<bool> isConcrete(Node node) async {
    if (!node.type.isItem || await isCheckbox(node)) return false;
    if (hasRequirements(node)) return true;
    return (await _nodes.children(node.id)).every((c) => !c.type.isItem);
  }

  /// [node] itself if concrete, else the concrete tasks under it at every
  /// level, in tree order (checkboxes excluded).
  Future<List<Node>> concreteTasks(Node node) async {
    if (await isConcrete(node)) return [node];
    if (!node.type.isItem || hasRequirements(node)) return const [];
    final out = <Node>[];
    for (final c in await _nodes.children(node.id)) {
      if (c.type.isItem) out.addAll(await concreteTasks(c));
    }
    return out;
  }
}

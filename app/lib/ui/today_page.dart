import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/database.dart';
import '../domain/search.dart';
import '../domain/today.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'labels.dart';
import 'peek.dart';
import 'tags.dart';
import 'tree_pane.dart';
import 'tree_providers.dart';
import 'values.dart';

/// Today (DESIGN.md §6.7): the home screen. It fills itself with what's due
/// (which kinds is up to you), plus what you add; anything can be removed
/// for the day, and the list can be dragged into order.

final todayProvider = StreamProvider<TodayList>((ref) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.today.watch();
});

final todaySettingsProvider = FutureProvider<TodaySettings>((ref) async {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  ref.watch(todayProvider); // re-read when Today changes
  return repo.today.settings();
});

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key, required this.onOpen});

  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final list = ref.watch(todayProvider).value;
    final items = list?.items ?? const <TodayItem>[];

    Future<void> reorder(int from, int to) async {
      final ids = [for (final i in items) i.node.id];
      final moved = ids.removeAt(from);
      ids.insert(to.clamp(0, ids.length), moved);
      await (await ref.read(nodeRepositoryProvider.future)).today.reorder(ids);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.todayView, style: theme.textTheme.headlineSmall),
                  Text(
                    DateFormat.MMMMEEEEd(locale).format(DateTime.now()),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  l10n.todayDoneCount(list!.doneCount, items.length),
                  style: theme.textTheme.labelLarge,
                ),
              ),
            IconButton(
              tooltip: l10n.todayPickOne,
              icon: const Icon(Icons.casino_outlined),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => const _PickOneDialog(),
              ),
            ),
            const _SettingsMenu(),
          ],
        ),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: list!.doneCount / items.length,
              minHeight: 6,
            ),
          ),
        ],
        if (list != null && list.leftOver.isNotEmpty)
          _LeftOverCard(nodes: list.leftOver),
        const SizedBox(height: 12),
        if (list != null && items.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.todayEmpty, textAlign: TextAlign.center),
          ),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          onReorderItem: reorder,
          children: [
            for (final (i, item) in items.indexed)
              _TodayRow(
                key: ValueKey(item.node.id),
                item: item,
                index: i,
                onOpen: onOpen,
              ),
          ],
        ),
      ],
    );
  }
}

class _TodayRow extends ConsumerWidget {
  const _TodayRow({
    super.key,
    required this.item,
    required this.index,
    required this.onOpen,
  });

  final TodayItem item;
  final int index;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final n = item.node;
    final why = switch (item.source) {
      TodaySource.overdue => l10n.todayOverdue(item.overdueDays),
      TodaySource.dueToday => l10n.todayDue,
      TodaySource.event =>
        item.start == null
            ? l10n.calendarEvent
            : l10n.todayAt(TimeOfDay.fromDateTime(item.start!).format(context)),
      TodaySource.routine => l10n.calendarRepeat,
      TodaySource.active => l10n.statusActive,
      TodaySource.picked => l10n.todayPicked,
    };
    final icon = switch (item.source) {
      TodaySource.overdue => Icons.flag,
      TodaySource.dueToday => Icons.flag_outlined,
      TodaySource.event => Icons.event,
      TodaySource.routine => Icons.repeat,
      TodaySource.active => Icons.play_circle_outline,
      TodaySource.picked => Icons.wb_sunny_outlined,
    };
    final ancestors = ref.watch(ancestorsProvider(n.id)).value ?? const [];

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: PeekTarget(
        nodeId: n.id,
        onOpen: onOpen,
        child: ListTile(
          leading: Icon(
            item.done ? Icons.check_circle : icon,
            color: item.done
                ? theme.colorScheme.primary
                : item.source == TodaySource.overdue
                ? theme.colorScheme.error
                : null,
          ),
          title: Text(
            l10n.titleOrUntitled(n.title),
            style: item.done
                ? TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: theme.colorScheme.onSurfaceVariant,
                  )
                : null,
          ),
          subtitle: Text(
            [
              why,
              if (ancestors.isNotEmpty)
                ancestors.map((a) => l10n.titleOrUntitled(a.title)).join(' › '),
            ].join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: l10n.todayRemove,
                icon: const Icon(Icons.close),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.maybeOf(context);
                  final today = (await ref.read(nodeRepositoryProvider.future))
                      .today;
                  await today.remove(n.id);
                  messenger
                    ?..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.todayRemoved(l10n.titleOrUntitled(n.title)),
                        ),
                        action: SnackBarAction(
                          label: l10n.undo,
                          onPressed: () => today.add(n.id),
                        ),
                      ),
                    );
                },
              ),
              ReorderableDragStartListener(
                index: index,
                child: Tooltip(
                  message: l10n.reorderHandle,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.drag_indicator),
                  ),
                ),
              ),
            ],
          ),
          onTap: () => onOpen(n.id),
        ),
      ),
    );
  }
}

/// "2 picks from earlier days aren't done" with Keep on today / Drop.
class _LeftOverCard extends ConsumerWidget {
  const _LeftOverCard({required this.nodes});

  final List<Node> nodes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Future<void> answer(bool keep) async =>
        (await ref.read(nodeRepositoryProvider.future)).today
            .resolveLeftOver([for (final n in nodes) n.id], keep: keep);

    return Card(
      margin: const EdgeInsets.only(top: 12),
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.todayLeftOver(nodes.length),
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              nodes.map((n) => l10n.titleOrUntitled(n.title)).join(', '),
              style: theme.textTheme.bodyMedium,
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Wrap(
                spacing: 8,
                children: [
                  TextButton(
                    onPressed: () => answer(false),
                    child: Text(l10n.todayDrop),
                  ),
                  FilledButton(
                    onPressed: () => answer(true),
                    child: Text(l10n.todayKeep),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ⚙: which kinds Today adds by itself.
class _SettingsMenu extends ConsumerWidget {
  const _SettingsMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final s = ref.watch(todaySettingsProvider).value ?? const TodaySettings();
    Future<void> set(TodaySettings next) async {
      await (await ref.read(nodeRepositoryProvider.future)).today
          .setSettings(next);
      ref.invalidate(todaySettingsProvider);
    }

    Widget option(
      String label,
      bool value,
      TodaySettings Function(bool) next,
    ) => CheckboxMenuButton(
      value: value,
      closeOnActivate: false,
      onChanged: (on) => set(next(on ?? false)),
      child: Text(label),
    );

    return MenuAnchor(
      menuChildren: [
        MenuItemButton(onPressed: null, child: Text(l10n.todayAutoTitle)),
        option(
          l10n.todayAutoRoutines,
          s.routines,
          (v) => s.copyWith(routines: v),
        ),
        option(l10n.todayAutoDue, s.dueToday, (v) => s.copyWith(dueToday: v)),
        option(l10n.todayAutoOverdue, s.overdue, (v) => s.copyWith(overdue: v)),
        option(l10n.todayAutoEvents, s.events, (v) => s.copyWith(events: v)),
        option(l10n.todayAutoActive, s.active, (v) => s.copyWith(active: v)),
      ],
      builder: (context, controller, _) => IconButton(
        tooltip: l10n.todaySettings,
        icon: const Icon(Icons.tune),
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}

/// "Pick one for me": a random open item, optionally by tag or value, to
/// add to Today or skip for another.
class _PickOneDialog extends ConsumerStatefulWidget {
  const _PickOneDialog();

  @override
  ConsumerState<_PickOneDialog> createState() => _PickOneDialogState();
}

class _PickOneDialogState extends ConsumerState<_PickOneDialog> {
  final _tagIds = <String>{};
  final _valueIds = <String>{};
  final _skipped = <String>{};
  Node? _pick;
  bool _none = false;

  Future<void> _next() async {
    final today = (await ref.read(nodeRepositoryProvider.future)).today;
    final n = await today.pickOne(
      filters: SearchFilters(tagIds: _tagIds, valueIds: _valueIds),
      exclude: _skipped,
    );
    if (!mounted) return;
    setState(() {
      _pick = n;
      _none = n == null;
      if (n != null) _skipped.add(n.id);
    });
  }

  @override
  void initState() {
    super.initState();
    _next();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tags = ref.watch(allTagsProvider).value ?? const [];
    final values = ref.watch(valuesProvider).value ?? const [];
    final pick = _pick;
    final path = pick == null
        ? const <Node>[]
        : ref.watch(ancestorsProvider(pick.id)).value ?? const [];

    void refilter(VoidCallback change) {
      setState(change);
      _skipped.clear();
      _next();
    }

    return AlertDialog(
      title: Text(l10n.todayPickOne),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final v in values)
                  FilterChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(v.name),
                    selected: _valueIds.contains(v.id),
                    onSelected: (on) => refilter(
                      () => on ? _valueIds.add(v.id) : _valueIds.remove(v.id),
                    ),
                  ),
                for (final t in [
                  ...tags.where((t) => t.favorite),
                  ...tags.where((t) => !t.favorite),
                ])
                  FilterChip(
                    visualDensity: VisualDensity.compact,
                    label: Text('#${t.name}'),
                    selected: _tagIds.contains(t.id),
                    onSelected: (on) => refilter(
                      () => on ? _tagIds.add(t.id) : _tagIds.remove(t.id),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_none)
              Text(l10n.todayPickNone)
            else if (pick != null)
              Card(
                child: ListTile(
                  leading: Icon(nodeTypeIcon(pick.type)),
                  title: Text(
                    l10n.titleOrUntitled(pick.title),
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: path.isEmpty
                      ? null
                      : Text(
                          path
                              .map((a) => l10n.titleOrUntitled(a.title))
                              .join(' › '),
                        ),
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: _none ? null : _next,
          child: Text(l10n.todayPickAnother),
        ),
        FilledButton(
          onPressed: pick == null
              ? null
              : () async {
                  await (await ref.read(nodeRepositoryProvider.future)).today
                      .add(pick.id);
                  if (context.mounted) Navigator.pop(context);
                },
          child: Text(l10n.todayAdd),
        ),
      ],
    );
  }
}

/// ⋮ "Add to Today" / "Remove from Today" for an item.
class TodayMenuItem extends ConsumerWidget {
  const TodayMenuItem({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final container = ProviderScope.containerOf(context, listen: false);
    final on =
        ref
            .watch(todayProvider)
            .value
            ?.items
            .any((i) => i.node.id == node.id) ??
        false;
    return MenuItemButton(
      leadingIcon: Icon(on ? Icons.wb_sunny : Icons.wb_sunny_outlined),
      // The menu (and this item) is gone by the time this runs: use the
      // container, not this widget's ref.
      onPressed: () async {
        final today = (await container.read(
          nodeRepositoryProvider.future,
        )).today;
        on ? await today.remove(node.id) : await today.add(node.id);
      },
      child: Text(on ? l10n.todayRemoveItem : l10n.todayAddItem),
    );
  }
}

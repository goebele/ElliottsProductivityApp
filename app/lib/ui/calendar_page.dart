import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/database.dart';
import '../domain/calendar.dart';
import '../domain/ics.dart';
import '../domain/node_repository.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'labels.dart';
import 'markup.dart' show saveBytesAs;
import 'peek.dart';
import 'tags.dart';
import 'tree_pane.dart';
import 'tree_providers.dart';
import 'values.dart';

/// The calendar (DESIGN.md §6.5): day, week and month views of events,
/// deadlines and repeats, with filters. Clicking a day lists everything on
/// it; right-clicking (long-pressing on phones) empty space offers to add
/// an item there.

typedef _Range = ({DateTime from, DateTime to});

/// What the calendar shows; kept while the app is open.
final calendarFilterProvider =
    NotifierProvider<CalendarFilterState, CalendarFilter>(
      CalendarFilterState.new,
    );

class CalendarFilterState extends Notifier<CalendarFilter> {
  @override
  CalendarFilter build() => const CalendarFilter();

  void set(CalendarFilter f) => state = f;
}

/// A day for the calendar to show next (set by "Show in calendar").
final calendarFocusProvider = NotifierProvider<CalendarFocus, DateTime?>(
  CalendarFocus.new,
);

class CalendarFocus extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

  void focus(DateTime? day) => state = day;
}

/// Opens the calendar page (the wide layout shows it in the detail pane;
/// phones push it).
class CalendarOpener extends InheritedWidget {
  const CalendarOpener({super.key, required this.open, required super.child});

  final VoidCallback open;

  static VoidCallback? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CalendarOpener>()?.open;

  @override
  bool updateShouldNotify(CalendarOpener old) => old.open != open;
}

/// "Show in calendar" (§6.5): the calendar filtered to [node] and
/// everything under it, at its next date (today if it has none ahead).
Future<void> showInCalendar(
  BuildContext context,
  WidgetRef ref,
  Node node,
) async {
  final open = CalendarOpener.of(context);
  final repo = await ref.read(nodeRepositoryProvider.future);
  final today = _d(DateTime.now());
  final upcoming = await repo.calendar.entries(
    today,
    _add(today, 366),
    filter: CalendarFilter(underId: node.id),
  );
  ref
      .read(calendarFilterProvider.notifier)
      .set(CalendarFilter(underId: node.id));
  ref
      .read(calendarFocusProvider.notifier)
      .focus(upcoming.isEmpty ? today : upcoming.first.day);
  open?.call();
}

final calendarEntriesProvider =
    StreamProvider.family<List<CalendarEntry>, _Range>((ref, range) async* {
      final repo = await ref.watch(nodeRepositoryProvider.future);
      final filter = ref.watch(calendarFilterProvider);
      yield* repo.calendar.watch(range.from, range.to, filter: filter);
    });

enum CalendarView { day, week, month }

DateTime _d(DateTime t) => DateTime(t.year, t.month, t.day);
DateTime _add(DateTime d, int days) => DateTime(d.year, d.month, d.day + days);
DateTime _monday(DateTime d) => _add(_d(d), -(d.weekday - 1));

/// How many entries a month cell, or the all-day row of a week, shows
/// before "+n more".
const _cellLimit = 3;

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key, required this.onOpen});

  final OpenNode onOpen;

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  CalendarView _view = CalendarView.week;
  DateTime _anchor = _d(DateTime.now());

  /// The day listed beside the calendar (wide screens).
  DateTime? _listed;

  /// From this width the day list sits beside the calendar; narrower, it's
  /// a bottom sheet.
  static const _sideListWidth = 860.0;

  @override
  void initState() {
    super.initState();
    final focus = ref.read(calendarFocusProvider);
    if (focus != null) {
      _anchor = focus;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(calendarFocusProvider.notifier).focus(null),
      );
    }
  }

  _Range get _range => switch (_view) {
    CalendarView.day => (from: _anchor, to: _add(_anchor, 1)),
    CalendarView.week => (
      from: _monday(_anchor),
      to: _add(_monday(_anchor), 7),
    ),
    CalendarView.month => (
      from: _monday(DateTime(_anchor.year, _anchor.month)),
      to: _add(_monday(DateTime(_anchor.year, _anchor.month)), 42),
    ),
  };

  void _step(int dir) => setState(
    () => _anchor = switch (_view) {
      CalendarView.day => _add(_anchor, dir),
      CalendarView.week => _add(_anchor, 7 * dir),
      CalendarView.month => DateTime(_anchor.year, _anchor.month + dir),
    },
  );

  String _title(String locale) {
    final r = _range;
    return switch (_view) {
      CalendarView.day => DateFormat.yMMMMEEEEd(locale).format(_anchor),
      CalendarView.week =>
        '${DateFormat.MMMd(locale).format(r.from)} – '
            '${DateFormat.yMMMd(locale).format(_add(r.to, -1))}',
      CalendarView.month => DateFormat.yMMMM(locale).format(_anchor),
    };
  }

  /// Asks for a title, then adds an item with a one-hour slot at [at] or,
  /// with [allDay], due that day. Nothing is created if cancelled.
  Future<void> _quickAdd(DateTime at, {bool allDay = false}) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    final title = await showDialog<String>(
      context: context,
      builder: (context) => _QuickAddDialog(at: at, allDay: allDay),
    );
    if (title == null) return;
    final repo = await ref.read(nodeRepositoryProvider.future);
    final id = await repo.create(title: title);
    await repo.setDates(
      id,
      allDay
          ? NodeDates(dueDate: at)
          : NodeDates(start: at, end: at.add(const Duration(hours: 1))),
    );
    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.calendarAdded(l10n.titleOrUntitled(title))),
          action: SnackBarAction(
            label: l10n.peekOpen,
            onPressed: () => widget.onOpen(id),
          ),
        ),
      );
  }

  /// Lists everything on [day]: beside the calendar, or as a sheet.
  void _openDay(DateTime day, {required bool side}) {
    if (side) {
      setState(() => _listed = day);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scroll) => _DayList(
          day: day,
          scrollController: scroll,
          onOpen: (id) {
            Navigator.pop(context);
            widget.onOpen(id);
          },
          onAdd: () {
            Navigator.pop(context);
            _quickAdd(day, allDay: true);
          },
        ),
      ),
    );
  }

  Future<void> _export() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    final repo = await ref.read(nodeRepositoryProvider.future);
    final nodes = await repo.prefs.icsExportNodes();
    if (!mounted) return;
    if (nodes.isEmpty) {
      messenger?.showSnackBar(SnackBar(content: Text(l10n.icsNoneChosen)));
      return;
    }
    await saveBytesAs(
      context,
      'calendar.ics',
      utf8.encode(buildIcs(nodes)),
      'text/calendar',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Jumped here again from another item while open.
    ref.listen(calendarFocusProvider, (_, day) {
      if (day == null) return;
      setState(() => _anchor = day);
      ref.read(calendarFocusProvider.notifier).focus(null);
    });
    return _layout();
  }

  Widget _layout() => LayoutBuilder(
    builder: (context, constraints) {
      final side = constraints.maxWidth >= _sideListWidth;
      final calendar = _calendar(context, side: side);
      final listed = _listed;
      if (!side || listed == null) return calendar;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: calendar),
          const VerticalDivider(width: 1),
          SizedBox(
            width: 300,
            child: _DayList(
              day: listed,
              onOpen: widget.onOpen,
              onAdd: () => _quickAdd(listed, allDay: true),
              onClose: () => setState(() => _listed = null),
            ),
          ),
        ],
      );
    },
  );

  Widget _calendar(BuildContext context, {required bool side}) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final range = _range;
    final entries = ref.watch(calendarEntriesProvider(range)).value ?? const [];
    void openDay(DateTime d) => _openDay(d, side: side);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text(l10n.calendarView, style: theme.textTheme.headlineSmall),
              SegmentedButton<CalendarView>(
                showSelectedIcon: false,
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                segments: [
                  ButtonSegment(
                    value: CalendarView.day,
                    label: Text(l10n.calendarDay),
                  ),
                  ButtonSegment(
                    value: CalendarView.week,
                    label: Text(l10n.calendarWeek),
                  ),
                  ButtonSegment(
                    value: CalendarView.month,
                    label: Text(l10n.calendarMonth),
                  ),
                ],
                selected: {_view},
                onSelectionChanged: (s) => setState(() => _view = s.single),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: l10n.calendarPrevious,
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _step(-1),
                  ),
                  TextButton(
                    onPressed: () =>
                        setState(() => _anchor = _d(DateTime.now())),
                    child: Text(l10n.calendarToday),
                  ),
                  IconButton(
                    tooltip: l10n.calendarNext,
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => _step(1),
                  ),
                  IconButton(
                    tooltip: l10n.icsExport,
                    icon: const Icon(Icons.ios_share),
                    onPressed: _export,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          const _FilterBar(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(_title(locale), style: theme.textTheme.titleMedium),
          ),
          Expanded(
            child: switch (_view) {
              CalendarView.month => _MonthGrid(
                month: DateTime(_anchor.year, _anchor.month),
                from: range.from,
                entries: entries,
                onOpen: widget.onOpen,
                onDay: openDay,
                onAdd: (d) => _quickAdd(d, allDay: true),
              ),
              _ => _TimeGrid(
                days: [
                  for (var d = range.from; d.isBefore(range.to); d = _add(d, 1))
                    d,
                ],
                entries: entries,
                onOpen: widget.onOpen,
                onDay: openDay,
                onAddAt: _quickAdd,
                onAddDay: (d) => _quickAdd(d, allDay: true),
              ),
            },
          ),
        ],
      ),
    );
  }
}

/// Kind, done, tag, value and "under an item" filters.
class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final f = ref.watch(calendarFilterProvider);
    void set(CalendarFilter next) =>
        ref.read(calendarFilterProvider.notifier).set(next);
    final tags = ref.watch(allTagsProvider).value ?? const [];
    final values = ref.watch(valuesProvider).value ?? const [];
    final under = f.underId == null
        ? null
        : ref.watch(nodeProvider(f.underId!)).value;

    bool kindShown(CalendarEntryKind k) =>
        f.kinds.isEmpty || f.kinds.contains(k);
    void toggleKind(CalendarEntryKind k, bool on) {
      final shown = {
        for (final x in CalendarEntryKind.values)
          if (kindShown(x)) x,
      };
      on ? shown.add(k) : shown.remove(k);
      // All shown (or none, which would show nothing) means "any".
      set(
        f.copyWith(
          kinds:
              shown.length == CalendarEntryKind.values.length || shown.isEmpty
              ? {}
              : shown,
        ),
      );
    }

    Set<T> toggled<T>(Set<T> s, T x, bool? on) =>
        on == true ? {...s, x} : ({...s}..remove(x));

    Widget menu(String label, bool active, List<Widget> items) => MenuAnchor(
      menuChildren: items,
      builder: (context, controller, _) => FilterChip(
        visualDensity: VisualDensity.compact,
        label: Text(label),
        selected: active,
        showCheckmark: false,
        avatar: const Icon(Icons.arrow_drop_down, size: 18),
        onSelected: (_) =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );

    String summary(String label, List<String> picked) => picked.isEmpty
        ? label
        : picked.length == 1
        ? picked.single
        : '$label (${picked.length})';

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final (k, label) in [
          (CalendarEntryKind.event, l10n.calendarEvents),
          (CalendarEntryKind.deadline, l10n.calendarDeadlines),
          (CalendarEntryKind.routine, l10n.calendarRepeats),
        ])
          FilterChip(
            visualDensity: VisualDensity.compact,
            label: Text(label),
            selected: kindShown(k),
            onSelected: (on) => toggleKind(k, on),
          ),
        FilterChip(
          visualDensity: VisualDensity.compact,
          label: Text(l10n.calendarHideDone),
          selected: f.hideDone,
          onSelected: (on) => set(f.copyWith(hideDone: on)),
        ),
        menu(
          summary(l10n.filterTag, [
            for (final t in tags)
              if (f.tagIds.contains(t.id)) '#${t.name}',
          ]),
          f.tagIds.isNotEmpty,
          [
            if (tags.isEmpty)
              MenuItemButton(onPressed: null, child: Text(l10n.tagsEmpty)),
            for (final t in [
              ...tags.where((t) => t.favorite),
              ...tags.where((t) => !t.favorite),
            ])
              CheckboxMenuButton(
                value: f.tagIds.contains(t.id),
                closeOnActivate: false,
                onChanged: (on) =>
                    set(f.copyWith(tagIds: toggled(f.tagIds, t.id, on))),
                child: Text('#${t.name}'),
              ),
          ],
        ),
        menu(
          summary(l10n.filterValue, [
            for (final v in values)
              if (f.valueIds.contains(v.id)) v.name,
          ]),
          f.valueIds.isNotEmpty,
          [
            if (values.isEmpty)
              MenuItemButton(onPressed: null, child: Text(l10n.valuesEmpty)),
            for (final v in values)
              CheckboxMenuButton(
                value: f.valueIds.contains(v.id),
                closeOnActivate: false,
                onChanged: (on) =>
                    set(f.copyWith(valueIds: toggled(f.valueIds, v.id, on))),
                child: Text(v.name),
              ),
          ],
        ),
        if (under != null)
          InputChip(
            visualDensity: VisualDensity.compact,
            avatar: const Icon(Icons.account_tree_outlined, size: 18),
            label: Text(
              l10n.calendarUnderItem(l10n.titleOrUntitled(under.title)),
            ),
            selected: true,
            showCheckmark: false,
            onDeleted: () => set(f.copyWith(underId: () => null)),
          ),
        if (!f.isEmpty)
          TextButton(
            onPressed: () => set(const CalendarFilter()),
            child: Text(l10n.calendarClearFilters),
          ),
      ],
    );
  }
}

/// "New event · Tue 10 · 09:00–10:00" (or "New item · due Tue 10") with a
/// title field. Returns the title, or null if cancelled.
class _QuickAddDialog extends StatefulWidget {
  const _QuickAddDialog({required this.at, required this.allDay});

  final DateTime at;
  final bool allDay;

  @override
  State<_QuickAddDialog> createState() => _QuickAddDialogState();
}

class _QuickAddDialogState extends State<_QuickAddDialog> {
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final day = DateFormat.MMMEd(locale).format(widget.at);
    String time(DateTime t) => TimeOfDay.fromDateTime(t).format(context);
    final when = widget.allDay
        ? l10n.calendarQuickAddDue(day)
        : l10n.calendarQuickAddAt(
            day,
            time(widget.at),
            time(widget.at.add(const Duration(hours: 1))),
          );
    void add() => Navigator.pop(context, _title.text.trim());
    return AlertDialog(
      title: Text(when),
      content: SizedBox(
        width: 360,
        child: TextField(
          controller: _title,
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.titleHint),
          onSubmitted: (_) => add(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(onPressed: add, child: Text(l10n.calendarQuickAdd)),
      ],
    );
  }
}

/// Everything on one day: all-day entries, then by time.
class _DayList extends ConsumerWidget {
  const _DayList({
    required this.day,
    required this.onOpen,
    required this.onAdd,
    this.onClose,
    this.scrollController,
  });

  final DateTime day;
  final OpenNode onOpen;
  final VoidCallback onAdd;
  final VoidCallback? onClose;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final entries =
        ref
            .watch(calendarEntriesProvider((from: day, to: _add(day, 1))))
            .value ??
        const [];
    String time(DateTime t) => TimeOfDay.fromDateTime(t).format(context);

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                DateFormat.MMMMEEEEd(locale).format(day),
                style: theme.textTheme.titleMedium,
              ),
            ),
            if (onClose != null)
              IconButton(
                tooltip: l10n.calendarCloseDay,
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
          ],
        ),
        Text(
          l10n.calendarDayCount(entries.length),
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        for (final e in entries)
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(right: 8),
            leading: Icon(_kindIcon(e), size: 20),
            title: Text(
              l10n.titleOrUntitled(e.node.title),
              style: e.done
                  ? TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: theme.colorScheme.onSurfaceVariant,
                    )
                  : null,
            ),
            subtitle: Text(
              [
                if (e.start != null)
                  e.end == null || e.end == e.start
                      ? time(e.start!)
                      : '${time(e.start!)}–${time(e.end!)}'
                else
                  l10n.calendarAllDay,
                switch (e.kind) {
                  CalendarEntryKind.deadline => l10n.calendarDeadline,
                  CalendarEntryKind.routine => l10n.calendarRepeat,
                  CalendarEntryKind.event =>
                    e.occurrence == null
                        ? l10n.calendarEvent
                        : l10n.calendarRepeat,
                },
                if (e.done) l10n.statusDone,
              ].join(' · '),
            ),
            onTap: () => onOpen(e.node.id),
          ),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l10n.calendarAddOnDay),
            onPressed: onAdd,
          ),
        ),
      ],
    );
  }
}

IconData _kindIcon(CalendarEntry e) => switch (e.kind) {
  CalendarEntryKind.deadline => Icons.flag_outlined,
  CalendarEntryKind.routine => Icons.repeat,
  CalendarEntryKind.event =>
    e.occurrence == null ? Icons.event : Icons.event_repeat,
};

/// A title chip for an entry: icon by kind, struck through when done.
class _EntryChip extends StatelessWidget {
  const _EntryChip({
    required this.entry,
    required this.onOpen,
    this.showTime = false,
  });

  final CalendarEntry entry;
  final OpenNode onOpen;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final e = entry;
    final (bg, fg) = switch (e.kind) {
      CalendarEntryKind.deadline => (
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
      CalendarEntryKind.routine => (
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      CalendarEntryKind.event => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
    };
    final time = showTime && e.start != null
        ? '${TimeOfDay.fromDateTime(e.start!).format(context)} '
        : '';
    return PeekTarget(
      nodeId: e.node.id,
      onOpen: onOpen,
      child: Material(
        color: bg.withValues(alpha: e.done ? 0.5 : 1),
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => onOpen(e.node.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                Icon(_kindIcon(e), size: 12, color: fg),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    '$time${l10n.titleOrUntitled(e.node.title)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: fg,
                      decoration: e.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "+3 more": opens the day's list.
class _MoreChip extends StatelessWidget {
  const _MoreChip({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(4),
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      child: Text(
        AppLocalizations.of(context).calendarMore(count),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

/// Day and week: a day header (click to list the day), an all-day row of
/// at most three entries, then hours. Click empty time to list the day;
/// right-click or long-press it to add an item there.
class _TimeGrid extends StatefulWidget {
  const _TimeGrid({
    required this.days,
    required this.entries,
    required this.onOpen,
    required this.onDay,
    required this.onAddAt,
    required this.onAddDay,
  });

  final List<DateTime> days;
  final List<CalendarEntry> entries;
  final OpenNode onOpen;
  final void Function(DateTime day) onDay;
  final void Function(DateTime start) onAddAt;
  final void Function(DateTime day) onAddDay;

  static const hourHeight = 48.0;
  static const gutter = 48.0;

  @override
  State<_TimeGrid> createState() => _TimeGridState();
}

class _TimeGridState extends State<_TimeGrid> {
  // Opens on the working day.
  final _scroll = ScrollController(
    initialScrollOffset: 7 * _TimeGrid.hourHeight,
  );

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final today = _d(DateTime.now());
    const hh = _TimeGrid.hourHeight;

    List<CalendarEntry> on(DateTime d, {required bool allDay}) => [
      for (final e in widget.entries)
        if (e.day == d && e.allDay == allDay) e,
    ];

    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: _TimeGrid.gutter),
        for (final d in widget.days)
          Expanded(
            child: Builder(
              builder: (context) {
                final allDay = on(d, allDay: true);
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => widget.onDay(d),
                  onSecondaryTap: () => widget.onAddDay(d),
                  onLongPress: () => widget.onAddDay(d),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Tooltip(
                          message: l10n.calendarListDay,
                          child: Text(
                            DateFormat.MEd(locale).format(d),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: d == today
                                  ? theme.colorScheme.primary
                                  : null,
                              fontWeight: d == today ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                        for (final e in allDay.take(
                          allDay.length > _cellLimit
                              ? _cellLimit - 1
                              : _cellLimit,
                        ))
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: _EntryChip(entry: e, onOpen: widget.onOpen),
                          ),
                        if (allDay.length > _cellLimit)
                          _MoreChip(
                            count: allDay.length - (_cellLimit - 1),
                            onTap: () => widget.onDay(d),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        const Divider(height: 8),
        Expanded(
          child: SingleChildScrollView(
            controller: _scroll,
            child: SizedBox(
              height: 24 * hh,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: _TimeGrid.gutter,
                    child: Stack(
                      children: [
                        for (var h = 1; h < 24; h++)
                          Positioned(
                            top: h * hh - 7,
                            right: 6,
                            child: Text(
                              TimeOfDay(hour: h, minute: 0).format(context),
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                  for (final d in widget.days)
                    Expanded(
                      child: _DayColumn(
                        day: d,
                        entries: on(d, allDay: false),
                        today: d == today,
                        onOpen: widget.onOpen,
                        onDay: widget.onDay,
                        onAddAt: widget.onAddAt,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.day,
    required this.entries,
    required this.today,
    required this.onOpen,
    required this.onDay,
    required this.onAddAt,
  });

  final DateTime day;
  final List<CalendarEntry> entries;
  final bool today;
  final OpenNode onOpen;
  final void Function(DateTime day) onDay;
  final void Function(DateTime start) onAddAt;

  /// Narrower than this, a lane shows nothing but a "+n" for the rest.
  static const _minLaneWidth = 44.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const hh = _TimeGrid.hourHeight;

    // Overlapping entries share the width: each takes the first free lane.
    final lanes = <List<CalendarEntry>>[];
    final laneOf = <CalendarEntry, int>{};
    for (final e in entries) {
      var placed = false;
      for (var i = 0; i < lanes.length; i++) {
        if (!_endOf(lanes[i].last).isAfter(e.start!)) {
          lanes[i].add(e);
          laneOf[e] = i;
          placed = true;
          break;
        }
      }
      if (!placed) {
        lanes.add([e]);
        laneOf[e] = lanes.length - 1;
      }
    }

    DateTime at(Offset local) {
      final halfHours = (local.dy / (hh / 2)).floor().clamp(0, 47);
      return DateTime(
        day.year,
        day.month,
        day.day,
      ).add(Duration(minutes: halfHours * 30));
    }

    return LayoutBuilder(
      builder: (context, c) {
        // As many lanes as fit; the rest are summed up as "+n".
        final fit = math.max(1, (c.maxWidth / _minLaneWidth).floor());
        final shownLanes = math.min(lanes.length, fit);
        final hidden = [
          for (final e in entries)
            if (laneOf[e]! >= shownLanes) e,
        ];
        final laneCount = math.max(1, shownLanes);
        final laneWidth = c.maxWidth / laneCount;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onDay(day),
          onSecondaryTapUp: (t) => onAddAt(at(t.localPosition)),
          onLongPressStart: (t) => onAddAt(at(t.localPosition)),
          child: Container(
            decoration: BoxDecoration(
              color: today
                  ? theme.colorScheme.primary.withValues(alpha: 0.04)
                  : null,
              border: Border(left: BorderSide(color: theme.dividerColor)),
            ),
            child: Stack(
              children: [
                for (var h = 1; h < 24; h++)
                  Positioned(
                    top: h * hh,
                    left: 0,
                    right: 0,
                    child: Divider(height: 1, color: theme.dividerColor),
                  ),
                for (final e in entries)
                  if (laneOf[e]! < shownLanes)
                    Positioned(
                      top: _minutes(e.start!) / 60 * hh,
                      height: math.max(
                        18,
                        _endOf(e).difference(e.start!).inMinutes / 60 * hh,
                      ),
                      left: laneWidth * laneOf[e]! + 1,
                      width: laneWidth - 2,
                      child: _EntryChip(
                        entry: e,
                        onOpen: onOpen,
                        showTime: true,
                      ),
                    ),
                // Entries that don't fit: a "+n" at the first one's time.
                if (hidden.isNotEmpty)
                  Positioned(
                    top: _minutes(hidden.first.start!) / 60 * hh,
                    right: 2,
                    child: Material(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                      child: _MoreChip(
                        count: hidden.length,
                        onTap: () => onDay(day),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// End, cut off at midnight so a late event stays on its day.
  DateTime _endOf(CalendarEntry e) {
    final end = e.end ?? e.start!;
    final midnight = DateTime(day.year, day.month, day.day + 1);
    return end.isAfter(midnight) ? midnight : end;
  }

  static int _minutes(DateTime t) => t.hour * 60 + t.minute;
}

/// Six weeks from the Monday on or before the 1st. Each day shows up to
/// three entries, then "+n more". Click a day to list it; right-click or
/// long-press to add an item due that day.
class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.from,
    required this.entries,
    required this.onOpen,
    required this.onDay,
    required this.onAdd,
  });

  final DateTime month;
  final DateTime from;
  final List<CalendarEntry> entries;
  final OpenNode onOpen;
  final void Function(DateTime day) onDay;
  final void Function(DateTime day) onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final today = _d(DateTime.now());
    final byDay = <DateTime, List<CalendarEntry>>{};
    for (final e in entries) {
      (byDay[e.day] ??= []).add(e);
    }

    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < 7; i++)
              Expanded(
                child: Text(
                  weekdayShort(i + 1, locale),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium,
                ),
              ),
          ],
        ),
        for (var w = 0; w < 6; w++)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < 7; i++)
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final d = _add(from, w * 7 + i);
                        final list = byDay[d] ?? const [];
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onDay(d),
                          onSecondaryTap: () => onAdd(d),
                          onLongPress: () => onAdd(d),
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.dividerColor),
                              borderRadius: BorderRadius.circular(4),
                              color: d.month != month.month
                                  ? theme.colorScheme.surfaceContainerLow
                                  : null,
                            ),
                            // Only what fits; the rest goes into "+n more".
                            child: LayoutBuilder(
                              builder: (context, c) {
                                const row = 19.0;
                                final room = math.max(
                                  0,
                                  ((c.maxHeight - 16) / row).floor(),
                                );
                                final limit = math.min(_cellLimit, room);
                                final shown = list.length > limit
                                    ? math.max(0, limit - 1)
                                    : list.length;
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      '${d.day}',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: d == today
                                                ? theme.colorScheme.primary
                                                : null,
                                            fontWeight: d == today
                                                ? FontWeight.bold
                                                : null,
                                          ),
                                    ),
                                    for (final e in list.take(shown))
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1),
                                        child: _EntryChip(
                                          entry: e,
                                          onOpen: onOpen,
                                          showTime: true,
                                        ),
                                      ),
                                    if (list.length > shown)
                                      _MoreChip(
                                        count: list.length - shown,
                                        onTap: () => onDay(d),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

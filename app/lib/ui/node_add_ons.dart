import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/node_repository.dart';
import '../domain/repeat_rule.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'labels.dart';

/// The optional things an item can have (DESIGN.md D5, rev. v0.5): a
/// description, dates (deadline, time slot, repeat) and a list layout.
///
/// Dates the item has show as chips; tapping any of them opens the one
/// date & time dialog, and their ✕ removes just that part. With no dates
/// yet, a single "+ Date & time" chip opens the dialog.
class NodeAddOns extends ConsumerWidget {
  const NodeAddOns({
    super.key,
    required this.node,
    required this.descriptionShown,
    required this.onAddDescription,
  });

  final Node node;
  final bool descriptionShown;
  final VoidCallback onAddDescription;

  Future<NodeRepository> _repo(WidgetRef ref) =>
      ref.read(nodeRepositoryProvider.future);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final material = MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();

    final dueDate = node.dueDate;
    final start = node.startAt?.toLocal();
    final end = node.endAt?.toLocal();
    final rrule = node.rrule;
    final hasDates = dueDate != null || start != null || rrule != null;
    void openDates() => _editDates(context, ref);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (dueDate != null)
          InputChip(
            avatar: const Icon(Icons.flag_outlined),
            label: Text(
              l10n.dueOn(material.formatMediumDate(parseDateKey(dueDate))),
            ),
            deleteButtonTooltipMessage: l10n.remove,
            onPressed: openDates,
            onDeleted: () async => (await _repo(ref)).setDueDate(node.id, null),
          ),
        if (start != null && end != null)
          InputChip(
            avatar: const Icon(Icons.event_outlined),
            label: Text(
              l10n.scheduleSummary(
                material.formatMediumDate(start),
                material.formatTimeOfDay(TimeOfDay.fromDateTime(start)),
                material.formatTimeOfDay(TimeOfDay.fromDateTime(end)),
              ),
            ),
            deleteButtonTooltipMessage: l10n.remove,
            onPressed: openDates,
            onDeleted: () async => (await _repo(ref)).setSchedule(node.id),
          ),
        if (rrule != null)
          InputChip(
            avatar: const Icon(Icons.repeat),
            label: Text(
              node.exclusiveChildren
                  ? l10n.exclusiveChip(l10n.repeatSummary(rrule, locale))
                  : l10n.repeatSummary(rrule, locale),
            ),
            deleteButtonTooltipMessage: l10n.remove,
            onPressed: openDates,
            onDeleted: () async => (await _repo(ref)).setRepeat(node.id, null),
          ),
        if (!descriptionShown)
          ActionChip(
            avatar: const Icon(Icons.subject),
            label: Text(l10n.addDescription),
            onPressed: onAddDescription,
          ),
        if (!hasDates)
          ActionChip(
            avatar: const Icon(Icons.event_outlined),
            label: Text(l10n.addDateTime),
            onPressed: openDates,
          ),
      ],
    );
  }

  Future<void> _editDates(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<NodeDates>(
      context: context,
      builder: (_) => DatesDialog(node: node),
    );
    if (result != null) await (await _repo(ref)).setDates(node.id, result);
  }
}

/// One dialog for everything date-related: a deadline, a time slot (making
/// the item an event) and a repeat (making it a routine). Each part has its
/// own switch. Returns null if cancelled.
class DatesDialog extends StatefulWidget {
  const DatesDialog({super.key, required this.node});

  final Node node;

  @override
  State<DatesDialog> createState() => _DatesDialogState();
}

enum _RepeatChoice { daily, weekdays, weekly, monthly }

class _DatesDialogState extends State<DatesDialog> {
  late bool _deadlineOn;
  late DateTime _deadline;

  late bool _slotOn;
  late DateTime _slotDate;
  late TimeOfDay _start;
  late TimeOfDay _end;

  late bool _repeatOn;
  late _RepeatChoice _choice;
  late int _interval;
  late Set<int> _weekdays;
  late int _monthDay;
  late DateTime _repeatStart;
  late bool _exclusive;

  @override
  void initState() {
    super.initState();
    final node = widget.node;
    final now = DateTime.now();

    _deadlineOn = node.dueDate != null;
    _deadline = node.dueDate == null ? now : parseDateKey(node.dueDate!);

    _slotOn = node.startAt != null && node.endAt != null;
    final start =
        node.startAt?.toLocal() ??
        DateTime(now.year, now.month, now.day, now.hour + 1);
    final end = node.endAt?.toLocal() ?? start.add(const Duration(hours: 1));
    _slotDate = DateTime(start.year, start.month, start.day);
    _start = TimeOfDay.fromDateTime(start);
    _end = TimeOfDay.fromDateTime(end);

    final rule = node.rrule == null ? null : RepeatRule.parse(node.rrule!);
    // A rule this version can't show stays off here unless changed, so
    // saving never rewrites it by accident.
    _repeatOn = node.rrule != null;
    _repeatStart = node.rrule == null
        ? DateTime(now.year, now.month, now.day)
        : seriesStart(node);
    _exclusive = node.exclusiveChildren;
    _interval = rule?.interval ?? 1;
    _weekdays = {start.weekday};
    _monthDay = start.day;
    _choice = _RepeatChoice.daily;
    if (rule != null) {
      if (rule.isEveryWeekday) {
        _choice = _RepeatChoice.weekdays;
      } else {
        switch (rule.frequency) {
          case RepeatFrequency.daily:
            _choice = _RepeatChoice.daily;
          case RepeatFrequency.weekly:
            _choice = _RepeatChoice.weekly;
            _weekdays = {...rule.weekdays};
          case RepeatFrequency.monthly:
            _choice = _RepeatChoice.monthly;
            _monthDay = rule.monthDay!;
        }
      }
    }
    _repeatEdited = rule != null;
  }

  /// False while an unrecognized rule is untouched: it is then kept as is.
  bool _repeatEdited = false;

  String? get _rrule {
    if (!_repeatOn) return null;
    if (!_repeatEdited) return widget.node.rrule;
    return switch (_choice) {
      _RepeatChoice.daily => RepeatRule.daily(interval: _interval),
      _RepeatChoice.weekdays => RepeatRule.weekdaysOnly,
      _RepeatChoice.weekly =>
        _weekdays.isEmpty
            ? null
            : RepeatRule.weekly(_weekdays, interval: _interval),
      _RepeatChoice.monthly => RepeatRule.monthly(
        _monthDay,
        interval: _interval,
      ),
    }?.toRrule();
  }

  bool get _valid => !_repeatOn || _rrule != null;

  NodeDates _result() {
    DateTime? start;
    DateTime? end;
    if (_slotOn) {
      DateTime at(TimeOfDay t) => DateTime(
        _slotDate.year,
        _slotDate.month,
        _slotDate.day,
        t.hour,
        t.minute,
      );
      start = at(_start);
      end = at(_end);
      if (end.isBefore(start)) end = end.add(const Duration(days: 1));
    }
    return NodeDates(
      dueDate: _deadlineOn ? _deadline : null,
      start: start,
      end: end,
      rrule: _rrule,
      repeatStart: _repeatOn ? _repeatStart : null,
      exclusiveChildren: _repeatOn && _exclusive,
    );
  }

  Future<DateTime?> _pickDate(DateTime initial) => showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  void _editRepeat(VoidCallback change) => setState(() {
    _repeatEdited = true;
    change();
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final material = MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final unknownRule = _repeatOn && !_repeatEdited;

    Widget section({
      required IconData icon,
      required String label,
      required bool on,
      required ValueChanged<bool> onChanged,
      required Widget child,
    }) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: Icon(icon),
          title: Text(label),
          value: on,
          onChanged: onChanged,
        ),
        if (on)
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 8),
            child: child,
          ),
      ],
    );

    Widget repeatChoice(_RepeatChoice c, String label) => ChoiceChip(
      label: Text(label),
      selected: !unknownRule && _choice == c,
      onSelected: (_) => _editRepeat(() => _choice = c),
    );

    return AlertDialog(
      title: Text(l10n.addDateTime),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              section(
                icon: Icons.flag_outlined,
                label: l10n.addDeadline,
                on: _deadlineOn,
                onChanged: (on) => setState(() => _deadlineOn = on),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(material.formatMediumDate(_deadline)),
                  onPressed: () async {
                    final d = await _pickDate(_deadline);
                    if (d != null) setState(() => _deadline = d);
                  },
                ),
              ),
              section(
                icon: Icons.event_outlined,
                label: l10n.sectionTimeSlot,
                on: _slotOn,
                onChanged: (on) => setState(() => _slotOn = on),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(material.formatMediumDate(_slotDate)),
                      onPressed: () async {
                        final d = await _pickDate(_slotDate);
                        if (d != null) setState(() => _slotDate = d);
                      },
                    ),
                    OutlinedButton(
                      child: Text(material.formatTimeOfDay(_start)),
                      onPressed: () async {
                        final t = await showTimePicker(
                          context: context,
                          initialTime: _start,
                          helpText: l10n.pickStartTime,
                        );
                        if (t == null) return;
                        // Keep the slot's length when the start moves.
                        final length =
                            (_end.hour * 60 + _end.minute) -
                            (_start.hour * 60 + _start.minute);
                        final endMinutes =
                            (t.hour * 60 + t.minute + length) % (24 * 60);
                        setState(() {
                          _start = t;
                          _end = TimeOfDay(
                            hour: endMinutes ~/ 60,
                            minute: endMinutes % 60,
                          );
                        });
                      },
                    ),
                    const Text('–'),
                    OutlinedButton(
                      child: Text(material.formatTimeOfDay(_end)),
                      onPressed: () async {
                        final t = await showTimePicker(
                          context: context,
                          initialTime: _end,
                          helpText: l10n.pickEndTime,
                        );
                        if (t != null) setState(() => _end = t);
                      },
                    ),
                  ],
                ),
              ),
              section(
                icon: Icons.repeat,
                label: l10n.addRepeat,
                on: _repeatOn,
                onChanged: (on) => setState(() {
                  _repeatOn = on;
                  if (on && widget.node.rrule == null) _repeatEdited = true;
                }),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (unknownRule)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          l10n.repeatSummary(widget.node.rrule!, locale),
                        ),
                      ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        repeatChoice(
                          _RepeatChoice.daily,
                          l10n.repeatDailyOption,
                        ),
                        repeatChoice(
                          _RepeatChoice.weekdays,
                          l10n.repeatWeekdays,
                        ),
                        repeatChoice(
                          _RepeatChoice.weekly,
                          l10n.repeatWeeklyOption,
                        ),
                        repeatChoice(
                          _RepeatChoice.monthly,
                          l10n.repeatMonthlyOption,
                        ),
                      ],
                    ),
                    if (!unknownRule && _choice != _RepeatChoice.weekdays) ...[
                      const SizedBox(height: 8),
                      _IntervalStepper(
                        value: _interval,
                        unit: switch (_choice) {
                          _RepeatChoice.daily => l10n.repeatUnitDays(_interval),
                          _RepeatChoice.monthly => l10n.repeatUnitMonths(
                            _interval,
                          ),
                          _ => l10n.repeatUnitWeeks(_interval),
                        },
                        onChanged: (n) => _editRepeat(() => _interval = n),
                      ),
                    ],
                    if (!unknownRule && _choice == _RepeatChoice.weekly) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          for (
                            var d = DateTime.monday;
                            d <= DateTime.sunday;
                            d++
                          )
                            FilterChip(
                              label: Text(weekdayShort(d, locale)),
                              selected: _weekdays.contains(d),
                              onSelected: (on) => _editRepeat(
                                () =>
                                    on ? _weekdays.add(d) : _weekdays.remove(d),
                              ),
                            ),
                        ],
                      ),
                    ],
                    if (!unknownRule && _choice == _RepeatChoice.monthly) ...[
                      const SizedBox(height: 12),
                      DropdownMenu<int>(
                        label: Text(l10n.repeatMonthDay),
                        initialSelection: _monthDay,
                        dropdownMenuEntries: [
                          for (var d = 1; d <= 31; d++)
                            DropdownMenuEntry(value: d, label: '$d'),
                        ],
                        onSelected: (d) =>
                            _editRepeat(() => _monthDay = d ?? _monthDay),
                      ),
                    ],
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(
                        l10n.repeatStarting(
                          material.formatMediumDate(_repeatStart),
                        ),
                      ),
                      onPressed: () async {
                        final d = await _pickDate(_repeatStart);
                        if (d != null) setState(() => _repeatStart = d);
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.exclusiveSwitch),
                      subtitle: Text(l10n.exclusiveSwitchHelp),
                      value: _exclusive,
                      onChanged: (on) => setState(() => _exclusive = on),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(material.cancelButtonLabel),
        ),
        FilledButton(
          onPressed: _valid ? () => Navigator.pop(context, _result()) : null,
          child: Text(material.okButtonLabel),
        ),
      ],
    );
  }
}

/// "Every [–] 3 [+] days".
class _IntervalStepper extends StatelessWidget {
  const _IntervalStepper({
    required this.value,
    required this.unit,
    required this.onChanged,
  });

  final int value;
  final String unit;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.repeatEvery),
        IconButton(
          tooltip: l10n.fewer,
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 28,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          tooltip: l10n.more,
          icon: const Icon(Icons.add_circle_outline),
          onPressed: value < 99 ? () => onChanged(value + 1) : null,
        ),
        Text(unit),
      ],
    );
  }
}

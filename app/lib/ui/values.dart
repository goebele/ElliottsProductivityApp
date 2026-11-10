import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/value_repository.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'labels.dart';
import 'markdown.dart';
import 'peek.dart';
import 'tree_pane.dart';

/// Core values (DESIGN.md §6.2): the Values page, and the value chips on an
/// item.

final valuesProvider = StreamProvider<List<CoreValue>>((ref) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.values.watchAll();
});

final effectiveValuesProvider =
    StreamProvider.family<List<EffectiveValue>, String>((ref, nodeId) async* {
      final repo = await ref.watch(nodeRepositoryProvider.future);
      yield* repo.values.watchEffective(nodeId);
    });

final tiedToProvider = StreamProvider.family<List<Node>, String>((
  ref,
  valueId,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.values.watchTiedTo(valueId);
});

/// The icons a value can have, by stored name.
const valueIcons = <String, IconData>{
  'favorite': Icons.favorite,
  'family': Icons.family_restroom,
  'health': Icons.spa,
  'fitness': Icons.fitness_center,
  'growth': Icons.self_improvement,
  'learning': Icons.school,
  'work': Icons.work,
  'money': Icons.savings,
  'creativity': Icons.palette,
  'nature': Icons.park,
  'community': Icons.volunteer_activism,
  'fun': Icons.celebration,
  'home': Icons.home,
  'star': Icons.star,
};

/// The colors a value can have (ARGB).
const valueColors = <int>[
  0xFFE53935,
  0xFFFB8C00,
  0xFFFDD835,
  0xFF43A047,
  0xFF00897B,
  0xFF1E88E5,
  0xFF3949AB,
  0xFF8E24AA,
  0xFFD81B60,
  0xFF6D4C41,
];

IconData valueIcon(CoreValue v) => valueIcons[v.icon] ?? Icons.favorite;

Color valueColor(CoreValue v, ThemeData theme) =>
    v.color == null ? theme.colorScheme.primary : Color(v.color!);

/// The item's values: its own (removable), then inherited ones, faded, with
/// where they come from, then "+ Value".
class ValueChips extends ConsumerWidget {
  const ValueChips({super.key, required this.node, required this.onOpen});

  final Node node;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final effective =
        ref.watch(effectiveValuesProvider(node.id)).value ?? const [];
    final all = ref.watch(valuesProvider).value ?? const [];
    final own = {
      for (final e in effective)
        if (!e.inherited) e.value.id,
    };

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final e in effective)
          if (e.inherited)
            PeekTarget(
              nodeId: e.from!.id,
              onOpen: onOpen,
              child: Opacity(
                opacity: 0.65,
                child: ActionChip(
                  visualDensity: VisualDensity.compact,
                  avatar: Icon(
                    valueIcon(e.value),
                    size: 16,
                    color: valueColor(e.value, theme),
                  ),
                  label: Text(
                    l10n.valueFrom(
                      e.value.name,
                      l10n.titleOrUntitled(e.from!.title),
                    ),
                  ),
                  tooltip: l10n.valueInherited,
                  onPressed: () => onOpen(e.from!.id),
                ),
              ),
            )
          else
            InputChip(
              visualDensity: VisualDensity.compact,
              avatar: Icon(
                valueIcon(e.value),
                size: 16,
                color: valueColor(e.value, theme),
              ),
              label: Text(e.value.name),
              deleteButtonTooltipMessage: l10n.valueRemove,
              onDeleted: () async =>
                  (await ref.read(nodeRepositoryProvider.future)).values
                      .untie(node.id, e.value.id),
            ),
        MenuAnchor(
          menuChildren: [
            for (final v in all)
              CheckboxMenuButton(
                value: own.contains(v.id),
                onChanged: (on) async {
                  final repo = await ref.read(nodeRepositoryProvider.future);
                  on == true
                      ? await repo.values.tie(node.id, v.id)
                      : await repo.values.untie(node.id, v.id);
                },
                child: Text(v.name),
              ),
            if (all.isNotEmpty) const Divider(height: 1),
            MenuItemButton(
              leadingIcon: const Icon(Icons.add),
              onPressed: () async {
                final id = await editValue(context, ref, null);
                if (id != null) {
                  await (await ref.read(nodeRepositoryProvider.future)).values
                      .tie(node.id, id);
                }
              },
              child: Text(l10n.valueNew),
            ),
          ],
          builder: (context, controller, _) => ActionChip(
            visualDensity: VisualDensity.compact,
            avatar: const Icon(Icons.add, size: 16),
            label: Text(l10n.valueAdd),
            onPressed: () =>
                controller.isOpen ? controller.close() : controller.open(),
          ),
        ),
      ],
    );
  }
}

/// Creates a value ([value] null) or edits one. Returns the value's id, or
/// null if cancelled.
Future<String?> editValue(
  BuildContext context,
  WidgetRef ref,
  CoreValue? value,
) => showDialog<String>(
  context: context,
  builder: (context) => _ValueDialog(value: value),
);

class _ValueDialog extends ConsumerStatefulWidget {
  const _ValueDialog({this.value});

  final CoreValue? value;

  @override
  ConsumerState<_ValueDialog> createState() => _ValueDialogState();
}

class _ValueDialogState extends ConsumerState<_ValueDialog> {
  late final _name = TextEditingController(text: widget.value?.name);
  late final _statement = TextEditingController(text: widget.value?.statement);
  late String? _icon = widget.value?.icon;
  late int? _color = widget.value?.color;

  @override
  void dispose() {
    _name.dispose();
    _statement.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final repo = (await ref.read(nodeRepositoryProvider.future)).values;
    final existing = widget.value;
    String id;
    if (existing == null) {
      id = await repo.create(
        name,
        statement: _statement.text.trim(),
        icon: _icon,
        color: _color,
      );
    } else {
      id = existing.id;
      await repo.update(
        id,
        CoreValuesCompanion(
          name: Value(name),
          statement: Value(_statement.text.trim()),
          icon: Value(_icon),
          color: Value(_color),
        ),
      );
    }
    if (mounted) Navigator.pop(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final color = _color == null ? theme.colorScheme.primary : Color(_color!);
    return AlertDialog(
      title: Text(widget.value == null ? l10n.valueNew : l10n.valueEdit),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _name,
                autofocus: true,
                decoration: InputDecoration(labelText: l10n.valueName),
                onSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _statement,
                minLines: 2,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: l10n.valueStatement,
                  hintText: l10n.valueStatementHint,
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.valueIcon, style: theme.textTheme.labelLarge),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: [
                  for (final MapEntry(:key, :value) in valueIcons.entries)
                    IconButton(
                      tooltip: key,
                      isSelected: (_icon ?? 'favorite') == key,
                      color: color,
                      icon: Icon(value),
                      onPressed: () => setState(() => _icon = key),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(l10n.valueColor, style: theme.textTheme.labelLarge),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in [null, ...valueColors])
                    Semantics(
                      selected: _color == c,
                      button: true,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => setState(() => _color = c),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: c == null
                              ? theme.colorScheme.primary
                              : Color(c),
                          child: _color == c
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.save)),
      ],
    );
  }
}

/// Every value with its statement and the items tied to it. Values can be
/// added, edited, reordered and deleted.
class ValuesPage extends ConsumerWidget {
  const ValuesPage({super.key, required this.onOpen});

  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final values = ref.watch(valuesProvider).value ?? const [];

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.valuesView,
                style: theme.textTheme.headlineSmall,
              ),
            ),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.add),
              label: Text(l10n.valueNew),
              onPressed: () => editValue(context, ref, null),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(l10n.valuesIntro, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 16),
        if (values.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.valuesEmpty, textAlign: TextAlign.center),
          ),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          onReorderItem: (from, to) async =>
              (await ref.read(nodeRepositoryProvider.future)).values
                  .move(values[from].id, to),
          children: [
            for (final (i, v) in values.indexed)
              _ValueCard(
                key: ValueKey(v.id),
                value: v,
                index: i,
                onOpen: onOpen,
              ),
          ],
        ),
      ],
    );
  }
}

class _ValueCard extends ConsumerWidget {
  const _ValueCard({
    super.key,
    required this.value,
    required this.index,
    required this.onOpen,
  });

  final CoreValue value;
  final int index;
  final OpenNode onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tied = ref.watch(tiedToProvider(value.id)).value ?? const [];
    final color = valueColor(value, theme);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(valueIcon(value), color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(value.name, style: theme.textTheme.titleMedium),
                ),
                IconButton(
                  tooltip: l10n.valueEdit,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => editValue(context, ref, value),
                ),
                IconButton(
                  tooltip: l10n.valueDelete,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.valueDeleteTitle(value.name)),
                        content: Text(l10n.valueDeleteBody(tied.length)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              MaterialLocalizations.of(context)
                                  .cancelButtonLabel,
                            ),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                              foregroundColor: theme.colorScheme.onError,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(l10n.valueDelete),
                          ),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await (await ref.read(nodeRepositoryProvider.future))
                          .values
                          .delete(value.id);
                    }
                  },
                ),
                ReorderableDragStartListener(
                  index: index,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.drag_handle),
                  ),
                ),
              ],
            ),
            if (value.statement.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 36, right: 8, top: 4),
                child: MarkdownView(value.statement),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 36, top: 8),
              child: tied.isEmpty
                  ? Text(
                      l10n.valueNothingTied,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  : Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final n in tied)
                          PeekTarget(
                            nodeId: n.id,
                            onOpen: onOpen,
                            child: ActionChip(
                              visualDensity: VisualDensity.compact,
                              avatar: Icon(nodeTypeIcon(n.type), size: 16),
                              label: Text(l10n.titleOrUntitled(n.title)),
                              onPressed: () => onOpen(n.id),
                            ),
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

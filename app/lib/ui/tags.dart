import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/inline_tags.dart';
import '../domain/tag_repository.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'search_pane.dart';
import 'values.dart' show valueColors;

/// Tags (DESIGN.md §6.14): the chips on an item and the tag picker.

final allTagsProvider = StreamProvider<List<Tag>>((ref) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.tags.watchAll();
});

final tagUsageProvider = StreamProvider<List<TagUsage>>((ref) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.tags.watchUsage();
});

/// A small dot in the tag's colour, or nothing.
Widget? tagDot(Tag tag, {double size = 10}) => tag.color == null
    ? null
    : Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Color(tag.color!),
          shape: BoxShape.circle,
        ),
      );

final nodeTagsProvider = StreamProvider.family<List<NodeTagEntry>, String>((
  ref,
  nodeId,
) async* {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  yield* repo.tags.watchOf(nodeId);
});

/// "#travel #weekend [+ Tag]". Clicking a tag searches for it. Tags from
/// the item's text have no ✕: edit the text to remove them.
class TagChips extends ConsumerWidget {
  const TagChips({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tags = ref.watch(nodeTagsProvider(node.id)).value ?? const [];
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final t in tags)
          InputChip(
            visualDensity: VisualDensity.compact,
            avatar: tagDot(t.tag),
            label: Text('#${t.tag.name}'),
            tooltip: t.inline ? l10n.tagFromText : l10n.tagSearch,
            onPressed: () =>
                ref.read(searchTextProvider.notifier).set('#${t.tag.name}'),
            deleteButtonTooltipMessage: l10n.tagRemove,
            onDeleted: t.inline
                ? null
                : () async =>
                      (await ref.read(nodeRepositoryProvider.future)).tags
                          .remove(node.id, t.tag.id),
          ),
        ActionChip(
          visualDensity: VisualDensity.compact,
          avatar: const Icon(Icons.add, size: 16),
          label: Text(l10n.tagAdd),
          onPressed: () => showDialog<void>(
            context: context,
            builder: (context) => _TagPicker(node: node),
          ),
        ),
      ],
    );
  }
}

/// Favourites as one-tap chips on top; below, type a tag (existing ones are
/// suggested) and press Enter. Tags already on the item are listed and can
/// be removed.
class _TagPicker extends ConsumerStatefulWidget {
  const _TagPicker({required this.node});

  final Node node;

  @override
  ConsumerState<_TagPicker> createState() => _TagPickerState();
}

class _TagPickerState extends ConsumerState<_TagPicker> {
  String? _error;

  Future<bool> _add(String name) async {
    if (name.trim().isEmpty) return false;
    final clean = normalizeTagName(name);
    if (clean == null) {
      setState(() => _error = AppLocalizations.of(context).tagNameInvalid);
      return false;
    }
    setState(() => _error = null);
    await (await ref.read(nodeRepositoryProvider.future)).tags
        .add(widget.node.id, clean);
    return true;
  }

  Future<void> _remove(String tagId) async =>
      (await ref.read(nodeRepositoryProvider.future)).tags
          .remove(widget.node.id, tagId);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final all = ref.watch(allTagsProvider).value ?? const [];
    final on = ref.watch(nodeTagsProvider(widget.node.id)).value ?? const [];
    final onById = {for (final t in on) t.tag.id: t};
    final favorites = [
      for (final t in all)
        if (t.favorite) t,
    ];
    final others = [
      for (final t in on)
        if (!t.tag.favorite) t,
    ];

    return AlertDialog(
      title: Text(l10n.tagPickerTitle),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (favorites.isNotEmpty) ...[
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final t in favorites)
                    FilterChip(
                      avatar: tagDot(t),
                      label: Text('#${t.name}'),
                      selected: onById.containsKey(t.id),
                      tooltip: onById[t.id]?.inline ?? false
                          ? l10n.tagFromText
                          : null,
                      // A tag from the text can't be unticked here.
                      onSelected: onById[t.id]?.inline ?? false
                          ? null
                          : (selected) =>
                                selected ? _add(t.name) : _remove(t.id),
                    ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            Autocomplete<String>(
              optionsBuilder: (value) {
                final q = value.text
                    .replaceFirst(RegExp('^#+'), '')
                    .toLowerCase();
                return [
                  for (final t in all)
                    if (!onById.containsKey(t.id) &&
                        !t.favorite &&
                        t.name.toLowerCase().contains(q))
                      t.name,
                ];
              },
              onSelected: _add,
              fieldViewBuilder: (context, controller, focus, onSubmit) =>
                  TextField(
                    controller: controller,
                    focusNode: focus,
                    autofocus: favorites.isEmpty,
                    decoration: InputDecoration(
                      prefixText: '#',
                      hintText: l10n.tagPickerHint,
                      errorText: _error,
                    ),
                    onSubmitted: (text) async {
                      if (await _add(text)) controller.clear();
                      focus.requestFocus();
                    },
                  ),
            ),
            if (others.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(l10n.tagPickerOnItem, style: theme.textTheme.labelMedium),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final t in others)
                    InputChip(
                      visualDensity: VisualDensity.compact,
                      avatar: tagDot(t.tag),
                      label: Text('#${t.tag.name}'),
                      tooltip: t.inline ? l10n.tagFromText : null,
                      onDeleted: t.inline ? null : () => _remove(t.tag.id),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.done),
        ),
      ],
    );
  }
}

/// Every tag: favourites first, each with its colour, how many items use it
/// (click to search), rename (to an existing name merges) and delete.
class TagsPage extends ConsumerStatefulWidget {
  const TagsPage({super.key, this.onSearched});

  /// Called after a count is clicked and the search is set (phones go back
  /// to the tree, where the results are).
  final VoidCallback? onSearched;

  @override
  ConsumerState<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends ConsumerState<TagsPage> {
  final _newTag = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _newTag.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (_newTag.text.trim().isEmpty) return;
    final name = normalizeTagName(_newTag.text);
    if (name == null) {
      setState(() => _error = AppLocalizations.of(context).tagNameInvalid);
      return;
    }
    setState(() => _error = null);
    await (await ref.read(nodeRepositoryProvider.future)).tags.create(name);
    _newTag.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final usage = ref.watch(tagUsageProvider).value ?? const [];
    final favorites = [
      for (final u in usage)
        if (u.tag.favorite) u,
    ];
    final others = [
      for (final u in usage)
        if (!u.tag.favorite) u,
    ];

    Widget heading(String text) => Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Text(text, style: theme.textTheme.titleSmall),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        Text(l10n.tagsView, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(l10n.tagsIntro, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        TextField(
          controller: _newTag,
          decoration: InputDecoration(
            prefixText: '#',
            hintText: l10n.tagNewHint,
            errorText: _error,
            suffixIcon: IconButton(
              tooltip: l10n.tagNew,
              icon: const Icon(Icons.add),
              onPressed: _create,
            ),
          ),
          onSubmitted: (_) => _create(),
        ),
        if (usage.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.tagsEmpty, textAlign: TextAlign.center),
          ),
        if (favorites.isNotEmpty) heading(l10n.tagsFavorites),
        for (final u in favorites)
          _TagRow(usage: u, onSearched: widget.onSearched),
        if (others.isNotEmpty)
          heading(favorites.isEmpty ? l10n.tagsAll : l10n.tagsOthers),
        for (final u in others)
          _TagRow(usage: u, onSearched: widget.onSearched),
      ],
    );
  }
}

class _TagRow extends ConsumerWidget {
  const _TagRow({required this.usage, this.onSearched});

  final TagUsage usage;
  final VoidCallback? onSearched;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tag = usage.tag;
    Future<TagRepository> repo() async =>
        (await ref.read(nodeRepositoryProvider.future)).tags;

    return ListTile(
      key: ValueKey(tag.id),
      contentPadding: EdgeInsets.zero,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: tag.favorite ? l10n.tagUnfavorite : l10n.tagFavorite,
            isSelected: tag.favorite,
            icon: const Icon(Icons.star_border),
            selectedIcon: Icon(Icons.star, color: theme.colorScheme.primary),
            onPressed: () async =>
                (await repo()).setFavorite(tag.id, !tag.favorite),
          ),
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () async => (await repo()).setColor(tag.id, null),
                child: Text(l10n.tagNoColor),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final c in valueColors)
                      InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () async => (await repo()).setColor(tag.id, c),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Color(c),
                          child: tag.color == c
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                  ],
                ),
              ),
            ],
            builder: (context, controller, _) => IconButton(
              tooltip: l10n.tagColor,
              icon:
                  tagDot(tag, size: 16) ??
                  Icon(Icons.circle_outlined, size: 18, color: theme.hintColor),
              onPressed: () =>
                  controller.isOpen ? controller.close() : controller.open(),
            ),
          ),
        ],
      ),
      title: Text('#${tag.name}'),
      subtitle: InkWell(
        onTap: usage.count == 0
            ? null
            : () {
                ref.read(searchTextProvider.notifier).set('#${tag.name}');
                onSearched?.call();
              },
        child: Text(
          l10n.tagUses(usage.count),
          style: usage.count == 0
              ? null
              : TextStyle(color: theme.colorScheme.primary),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: l10n.tagRename,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => _RenameDialog(tag: tag),
            ),
          ),
          IconButton(
            tooltip: l10n.tagDelete,
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.tagDeleteTitle(tag.name)),
                  content: Text(l10n.tagDeleteBody(usage.count)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        MaterialLocalizations.of(context).cancelButtonLabel,
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(l10n.tagDelete),
                    ),
                  ],
                ),
              );
              if (ok == true) await (await repo()).delete(tag.id);
            },
          ),
        ],
      ),
    );
  }
}

/// Renames a tag; a name that's already taken offers to merge.
class _RenameDialog extends ConsumerStatefulWidget {
  const _RenameDialog({required this.tag});

  final Tag tag;

  @override
  ConsumerState<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends ConsumerState<_RenameDialog> {
  late final _name = TextEditingController(text: widget.tag.name);
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final all = ref.watch(allTagsProvider).value ?? const [];
    final clean = normalizeTagName(_name.text);
    final other = clean == null
        ? null
        : all
              .where(
                (t) =>
                    t.id != widget.tag.id &&
                    t.name.toLowerCase() == clean.toLowerCase(),
              )
              .firstOrNull;

    Future<void> save() async {
      if (clean == null) {
        setState(() => _error = l10n.tagNameInvalid);
        return;
      }
      await (await ref.read(nodeRepositoryProvider.future)).tags
          .rename(widget.tag.id, clean);
      if (context.mounted) Navigator.pop(context);
    }

    return AlertDialog(
      title: Text(l10n.tagRenameTitle(widget.tag.name)),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _name,
              autofocus: true,
              decoration: InputDecoration(prefixText: '#', errorText: _error),
              onChanged: (_) => setState(() => _error = null),
              onSubmitted: (_) => save(),
            ),
            const SizedBox(height: 12),
            Text(
              other == null
                  ? l10n.tagRenameNote
                  : l10n.tagMergeNote(widget.tag.name, other.name),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: save,
          child: Text(other == null ? l10n.tagRename : l10n.tagMerge),
        ),
      ],
    );
  }
}

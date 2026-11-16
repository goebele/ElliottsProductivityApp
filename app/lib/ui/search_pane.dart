import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/database.dart';
import '../domain/search.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'files.dart';
import 'labels.dart';
import 'peek.dart';
import 'tags.dart';
import 'tree_pane.dart';
import 'tree_providers.dart';
import 'values.dart';

/// Search (DESIGN.md §6.6): a box above the tree, filter chips under it, and
/// results in place of the tree while searching.

/// What is typed in the search box.
final searchTextProvider = NotifierProvider<SearchText, String>(SearchText.new);

class SearchText extends Notifier<String> {
  @override
  String build() => '';

  void set(String text) => state = text;
}

/// The filters picked from the chips.
final searchFiltersProvider =
    NotifierProvider<SearchFiltersState, SearchFilters>(SearchFiltersState.new);

class SearchFiltersState extends Notifier<SearchFilters> {
  @override
  SearchFilters build() => const SearchFilters();

  void set(SearchFilters filters) => state = filters;
  void clear() => state = const SearchFilters();
}

/// Whether the filter chips are shown.
final searchFiltersShownProvider = NotifierProvider<FiltersShown, bool>(
  FiltersShown.new,
);

class FiltersShown extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool shown) => state = shown;
}

/// True while there is anything to search for: the results replace the tree.
final searchingProvider = Provider<bool>(
  (ref) =>
      ref.watch(searchTextProvider).trim().isNotEmpty ||
      !ref.watch(searchFiltersProvider).isEmpty,
);

/// Results, re-run when the query, the filters or the data change.
final searchResultsProvider = StreamProvider<List<SearchResult>>((ref) async* {
  final text = ref.watch(searchTextProvider);
  final filters = ref.watch(searchFiltersProvider);
  final repo = await ref.watch(nodeRepositoryProvider.future);
  final db = ref.watch(databaseProvider);
  final query = SearchQuery.parse(text);
  yield* db
      .customSelect(
        'SELECT 1 AS search_results',
        readsFrom: {
          db.nodes,
          db.tags,
          db.nodeTags,
          db.coreValues,
          db.nodeValues,
          db.links,
          db.placements,
          db.attachments,
        },
      )
      .watch()
      .asyncMap((_) => repo.search.search(query, filters: filters));
});

/// Focus for the search box, so Ctrl+F can reach it from anywhere.
final searchFocusProvider = Provider<FocusNode>((ref) {
  final node = FocusNode(debugLabel: 'search');
  ref.onDispose(node.dispose);
  return node;
});

/// The search box with its filter toggle, and the filter chips when shown.
class SearchBox extends ConsumerStatefulWidget {
  const SearchBox({super.key});

  @override
  ConsumerState<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends ConsumerState<SearchBox> {
  late final _controller = TextEditingController(
    text: ref.read(searchTextProvider),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    ref.read(searchTextProvider.notifier).set('');
    ref.read(searchFiltersProvider.notifier).clear();
    ref.read(searchFiltersShownProvider.notifier).set(false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Text set from elsewhere (clicking a tag) shows in the box.
    ref.listen(searchTextProvider, (_, text) {
      if (_controller.text != text) {
        _controller.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    });
    final searching = ref.watch(searchingProvider);
    final filters = ref.watch(searchFiltersProvider);
    final shown = ref.watch(searchFiltersShownProvider) || !filters.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CallbackShortcuts(
          bindings: {const SingleActivator(LogicalKeyboardKey.escape): _clear},
          child: TextField(
            controller: _controller,
            focusNode: ref.watch(searchFocusProvider),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              isDense: true,
              hintText: l10n.searchHint,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: l10n.searchFilters,
                    isSelected: shown,
                    icon: const Icon(Icons.tune),
                    onPressed: () => ref
                        .read(searchFiltersShownProvider.notifier)
                        .set(!shown),
                  ),
                  if (searching)
                    IconButton(
                      tooltip: l10n.searchClear,
                      icon: const Icon(Icons.close),
                      onPressed: _clear,
                    ),
                ],
              ),
            ),
            onChanged: (text) =>
                ref.read(searchTextProvider.notifier).set(text),
          ),
        ),
        if (shown) ...[const SizedBox(height: 6), const _FilterChips()],
      ],
    );
  }
}

class _FilterChips extends ConsumerWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final f = ref.watch(searchFiltersProvider);
    void set(SearchFilters next) =>
        ref.read(searchFiltersProvider.notifier).set(next);
    final values = ref.watch(valuesProvider).value ?? const [];
    final allTags = ref.watch(allTagsProvider).value ?? const [];
    final tags = [
      ...allTags.where((t) => t.favorite),
      ...allTags.where((t) => !t.favorite),
    ];
    final top = ref.watch(childrenProvider(null)).value ?? const [];
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat.MMMd(locale);

    String summary(String label, Iterable<String> picked) => picked.isEmpty
        ? label
        : picked.length == 1
        ? picked.first
        : '$label (${picked.length})';

    Widget menu({
      required String label,
      required bool active,
      required List<Widget> items,
    }) => MenuAnchor(
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

    Set<T> toggled<T>(Set<T> set, T item, bool? on) =>
        on == true ? {...set, item} : ({...set}..remove(item));

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        menu(
          label: summary(l10n.filterValue, [
            for (final v in values)
              if (f.valueIds.contains(v.id)) v.name,
          ]),
          active: f.valueIds.isNotEmpty,
          items: [
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
        menu(
          label: summary(l10n.filterTag, [
            for (final t in tags)
              if (f.tagIds.contains(t.id)) '#${t.name}',
          ]),
          active: f.tagIds.isNotEmpty,
          items: [
            if (tags.isEmpty)
              MenuItemButton(onPressed: null, child: Text(l10n.tagsEmpty)),
            for (final t in tags)
              CheckboxMenuButton(
                value: f.tagIds.contains(t.id),
                closeOnActivate: false,
                onChanged: (on) =>
                    set(f.copyWith(tagIds: toggled(f.tagIds, t.id, on))),
                child: Text('#${t.name}'),
              ),
            if (tags.isNotEmpty) ...[
              const Divider(height: 1),
              CheckboxMenuButton(
                value: f.tagChildren,
                closeOnActivate: false,
                onChanged: (on) => set(f.copyWith(tagChildren: on ?? false)),
                child: Text(l10n.filterIncludeChildren),
              ),
            ],
          ],
        ),
        menu(
          label: summary(l10n.filterType, [
            for (final t in NodeType.values)
              if (f.types.contains(t)) l10n.nodeType(t),
          ]),
          active: f.types.isNotEmpty,
          items: [
            for (final t in NodeType.values)
              CheckboxMenuButton(
                value: f.types.contains(t),
                closeOnActivate: false,
                onChanged: (on) =>
                    set(f.copyWith(types: toggled(f.types, t, on))),
                child: Text(l10n.nodeType(t)),
              ),
          ],
        ),
        menu(
          label: summary(l10n.filterStatus, [
            for (final s in NodeStatus.values)
              if (f.statuses.contains(s)) l10n.nodeStatus(s),
          ]),
          active: f.statuses.isNotEmpty,
          items: [
            for (final s in NodeStatus.values)
              CheckboxMenuButton(
                value: f.statuses.contains(s),
                closeOnActivate: false,
                onChanged: (on) =>
                    set(f.copyWith(statuses: toggled(f.statuses, s, on))),
                child: Text(l10n.nodeStatus(s)),
              ),
          ],
        ),
        menu(
          label: f.topLevelId == null
              ? l10n.filterProject
              : l10n.titleOrUntitled(
                  top
                          .where((t) => t.node.id == f.topLevelId)
                          .firstOrNull
                          ?.node
                          .title ??
                      '',
                ),
          active: f.topLevelId != null,
          items: [
            RadioMenuButton<String?>(
              value: null,
              groupValue: f.topLevelId,
              onChanged: (id) => set(f.copyWith(topLevelId: () => id)),
              child: Text(l10n.filterAnyProject),
            ),
            for (final t in top)
              if (!t.isShortcut)
                RadioMenuButton<String?>(
                  value: t.node.id,
                  groupValue: f.topLevelId,
                  onChanged: (id) => set(f.copyWith(topLevelId: () => id)),
                  child: Text(l10n.titleOrUntitled(t.node.title)),
                ),
          ],
        ),
        FilterChip(
          visualDensity: VisualDensity.compact,
          label: Text(
            f.dueFrom == null
                ? l10n.filterDue
                : l10n.filterDueRange(
                    date.format(f.dueFrom!),
                    date.format(f.dueTo ?? f.dueFrom!),
                  ),
          ),
          selected: f.dueFrom != null,
          showCheckmark: false,
          avatar: const Icon(Icons.event, size: 18),
          onSelected: (_) async {
            if (f.dueFrom != null) {
              set(f.copyWith(dueFrom: () => null, dueTo: () => null));
              return;
            }
            final now = DateTime.now();
            final range = await showDateRangePicker(
              context: context,
              firstDate: DateTime(now.year - 5),
              lastDate: DateTime(now.year + 10),
            );
            if (range != null) {
              set(
                f.copyWith(dueFrom: () => range.start, dueTo: () => range.end),
              );
            }
          },
        ),
        FilterChip(
          visualDensity: VisualDensity.compact,
          label: Text(l10n.filterHasFiles),
          selected: f.hasFiles,
          onSelected: (on) => set(f.copyWith(hasFiles: on)),
        ),
        FilterChip(
          visualDensity: VisualDensity.compact,
          label: Text(l10n.filterArchived),
          selected: f.includeArchived,
          onSelected: (on) => set(f.copyWith(includeArchived: on)),
        ),
      ],
    );
  }
}

/// The results, one row per item, with where it is.
class SearchResults extends ConsumerWidget {
  const SearchResults({super.key, required this.onOpen, this.selectedId});

  final OpenNode onOpen;
  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return switch (ref.watch(searchResultsProvider)) {
      AsyncData(value: final results) when results.isEmpty => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l10n.searchNoResults, textAlign: TextAlign.center),
        ),
      ),
      AsyncData(value: final results) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 4),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(
              l10n.searchCount(results.length),
              style: theme.textTheme.labelMedium,
            ),
          ),
          for (final r in results)
            if (r.attachment case final a?)
              ListTile(
                dense: true,
                leading: Icon(attachmentIcon(a.kind), size: 20),
                title: Text(a.filename),
                subtitle: Text(
                  [
                    r.path
                        .map((p) => l10n.titleOrUntitled(p.title))
                        .join(' › '),
                    l10n.searchFile,
                    if (r.linkedCount > 0) l10n.searchLinkedIn(r.linkedCount),
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => AttachmentOpener.of(context)(a.id),
              )
            else
              PeekTarget(
                nodeId: r.node.id,
                onOpen: onOpen,
                child: ListTile(
                  dense: true,
                  selected: r.node.id == selectedId,
                  leading: Icon(nodeTypeIcon(r.node.type), size: 20),
                  title: Text(
                    l10n.titleOrUntitled(r.node.title),
                    style:
                        isFinished(r.node.status) &&
                            r.node.type != NodeType.note
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          )
                        : null,
                  ),
                  subtitle: Text(
                    [
                      if (r.path.isNotEmpty)
                        r.path
                            .map((p) => l10n.titleOrUntitled(p.title))
                            .join(' › '),
                      if (r.linkedCount > 0) l10n.searchLinkedIn(r.linkedCount),
                      if (r.node.lifecycle == Lifecycle.archived)
                        l10n.searchArchived,
                    ].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => onOpen(r.node.id),
                ),
              ),
        ],
      ),
      AsyncError(:final error) => Center(child: Text('$error')),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

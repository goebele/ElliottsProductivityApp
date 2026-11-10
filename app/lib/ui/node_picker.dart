import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/node_repository.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'labels.dart';

/// Picks where [node] should also show (§6.12): any item in the tree, or the
/// top level. Places it can't go (itself, inside itself, where it already
/// is) are greyed out. Returns null if cancelled; otherwise the chosen
/// parent (null = top level).
Future<({String? parentId})?> pickShortcutParent(
  BuildContext context,
  Node node,
) => showDialog<({String? parentId})>(
  context: context,
  builder: (context) => _PickerDialog(node: node),
);

class _PickerDialog extends ConsumerStatefulWidget {
  const _PickerDialog({required this.node});

  final Node node;

  @override
  ConsumerState<_PickerDialog> createState() => _PickerDialogState();
}

class _PickerDialogState extends ConsumerState<_PickerDialog> {
  late final Future<PlacementChoices> _choices = ref
      .read(nodeRepositoryProvider.future)
      .then((repo) => repo.placementChoices(widget.node.id));
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return AlertDialog(
      title: Text(
        l10n.pickerTitle('“${l10n.titleOrUntitled(widget.node.title)}”'),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      content: SizedBox(
        width: 420,
        height: size.height * 0.6,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.pickerSearch,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (q) => setState(() => _query = q.trim().toLowerCase()),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder(
                future: _choices,
                builder: (context, snap) {
                  final choices = snap.data;
                  if (choices == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _list(context, l10n, theme, choices);
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
      ],
    );
  }

  Widget _list(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    PlacementChoices choices,
  ) {
    final searching = _query.isNotEmpty;
    // Ancestor titles of each item, for the path shown while searching.
    final rows = <Widget>[];
    final trail = <String>[];
    for (final (node, depth) in choices.items) {
      trail.length = depth.clamp(0, trail.length);
      final title = l10n.titleOrUntitled(node.title);
      final path = trail.join(' › ');
      trail.add(title);
      if (searching && !title.toLowerCase().contains(_query)) continue;
      final blocked = choices.blocked.contains(node.id);
      rows.add(
        ListTile(
          dense: true,
          enabled: !blocked,
          contentPadding: EdgeInsets.only(
            left: searching ? 8 : 8.0 + depth * 16,
            right: 8,
          ),
          leading: Icon(nodeIcon(node) ?? nodeTypeIcon(node.type), size: 20),
          title: Text(title),
          subtitle: searching && path.isNotEmpty ? Text(path) : null,
          onTap: () => Navigator.pop(context, (parentId: node.id)),
        ),
      );
    }
    final top = choices.topLevelAllowed && !searching;
    if (rows.isEmpty && !top) {
      return Center(child: Text(l10n.pickerNoMatches));
    }
    return ListView(
      children: [
        if (top)
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            leading: const Icon(Icons.vertical_align_top, size: 20),
            title: Text(l10n.topLevel),
            onTap: () => Navigator.pop(context, (parentId: null)),
          ),
        ...rows,
      ],
    );
  }
}

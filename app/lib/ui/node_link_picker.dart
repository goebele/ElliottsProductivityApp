import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/search.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'labels.dart';
import 'tree_providers.dart';

/// The item or note a link should point to.
typedef PickedNode = ({String id, String title});

/// Asks which note or item to link to (§6.3): type to search titles and
/// text; with nothing typed, recently changed ones are listed. Null if
/// cancelled.
Future<PickedNode?> pickNodeLink(BuildContext context) =>
    showDialog<PickedNode>(context: context, builder: (_) => const _Picker());

class _Picker extends ConsumerStatefulWidget {
  const _Picker();

  @override
  ConsumerState<_Picker> createState() => _PickerState();
}

class _PickerState extends ConsumerState<_Picker> {
  List<Node> _results = const [];
  String _query = '';
  int _highlight = 0;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  Future<void> _search(String text) async {
    _query = text;
    final repo = await ref.read(nodeRepositoryProvider.future);
    final List<Node> found;
    if (text.trim().isEmpty) {
      found = await repo.recent();
    } else {
      found = [
        for (final r in await repo.search.search(SearchQuery.parse(text)))
          if (r.attachment == null) r.node,
      ];
    }
    if (!mounted || text != _query) return;
    setState(() {
      _results = found;
      _highlight = 0;
    });
  }

  void _pick(Node n) => Navigator.pop(context, (
    id: n.id,
    title: AppLocalizations.of(context).titleOrUntitled(n.title),
  ));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.linkToItemTitle),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      content: SizedBox(
        width: 460,
        height: 420,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.linkToItemHint,
              ),
              onChanged: _search,
              onSubmitted: (_) {
                if (_results.isNotEmpty) _pick(_results[_highlight]);
              },
            ),
            const SizedBox(height: 4),
            if (_query.trim().isEmpty && _results.isNotEmpty)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    l10n.linkToItemRecent,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
            Expanded(
              child: _results.isEmpty
                  ? Center(child: Text(l10n.searchNoResults))
                  : ListView(
                      children: [
                        for (final (i, n) in _results.indexed)
                          _Row(
                            node: n,
                            selected: i == _highlight,
                            onTap: () => _pick(n),
                          ),
                      ],
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
}

class _Row extends ConsumerWidget {
  const _Row({required this.node, required this.selected, required this.onTap});

  final Node node;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final path = ref.watch(ancestorsProvider(node.id)).value ?? const [];
    return ListTile(
      dense: true,
      selected: selected,
      leading: Icon(
        node.type == NodeType.note
            ? Icons.sticky_note_2_outlined
            : nodeTypeIcon(node.type),
        size: 20,
      ),
      title: Text(l10n.titleOrUntitled(node.title)),
      subtitle: path.isEmpty
          ? null
          : Text(
              path.map((a) => l10n.titleOrUntitled(a.title)).join(' › '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      onTap: onTap,
    );
  }
}

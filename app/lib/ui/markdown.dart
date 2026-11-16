import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/markdown_format.dart';
import '../l10n/app_localizations.dart';
import 'autosave_field.dart';
import 'node_link_picker.dart';

/// Rendered Markdown (DESIGN.md §6.3), GitHub-flavoured: headings, bold and
/// italic, lists, task-list checkboxes (read-only: lists you tick belong in
/// items), code and links. Web links open in the browser; links to items
/// (`epa://node/<id>`) open them in the app, through [onOpenNode].
class MarkdownView extends StatelessWidget {
  const MarkdownView(this.data, {super.key, this.onOpenNode});

  final String data;
  final void Function(String id)? onOpenNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MarkdownBody(
      data: data,
      softLineBreak: true,
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        p: theme.textTheme.bodyLarge,
        code: theme.textTheme.bodyMedium?.copyWith(
          fontFamily: 'monospace',
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
        ),
        codeblockDecoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onTapLink: (text, href, title) async {
        if (nodeIdFromUrl(href) case final id?) {
          onOpenNode?.call(id);
          return;
        }
        final uri = href == null ? null : Uri.tryParse(href);
        if (uri != null &&
            const {'http', 'https', 'mailto'}.contains(uri.scheme)) {
          await launchUrl(uri);
        }
      },
    );
  }
}

/// A plain-text Markdown editor with a formatting toolbar and a preview
/// toggle (§6.3). It saves like [AutosaveField]. [trailing] goes at the end
/// of the toolbar (e.g. a close button).
class MarkdownEditor extends StatefulWidget {
  const MarkdownEditor({
    super.key,
    required this.value,
    required this.onSave,
    required this.hint,
    this.minLines = 4,
    this.autofocus = false,
    this.trailing,
  });

  final String value;
  final ValueChanged<String> onSave;
  final String hint;
  final int minLines;
  final bool autofocus;
  final Widget? trailing;

  @override
  State<MarkdownEditor> createState() => MarkdownEditorState();
}

class MarkdownEditorState extends State<MarkdownEditor> {
  /// What is in the field now, saved or not.
  String get text => _controller.text;

  final _controller = TextEditingController();
  final _focus = FocusNode();
  bool _preview = false;
  String _lastText = '';
  bool _picking = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_watchForBrackets);
  }

  /// Typing `[[` opens the link picker (the brackets are replaced by the
  /// link, or kept if it's cancelled).
  void _watchForBrackets() {
    final now = _controller.text;
    final before = _lastText;
    _lastText = now;
    final sel = _controller.selection;
    if (_picking || !sel.isCollapsed || now.length != before.length + 1) {
      return;
    }
    final at = sel.start;
    if (at < 2 || now.substring(at - 2, at) != '[[') return;
    _linkToItem(replacing: (at - 2, at));
  }

  /// Picks a note or item and inserts `[title](epa://node/<id>)`: around the
  /// selected text if there is some, or in place of [replacing].
  Future<void> _linkToItem({(int, int)? replacing}) async {
    _picking = true;
    final picked = await pickNodeLink(context);
    _picking = false;
    if (!mounted) return;
    if (picked == null) {
      _focus.requestFocus();
      return;
    }
    if (replacing case (final start, final end)) {
      final v = _controller.value;
      _controller.value = TextEditingValue(
        text: v.text.replaceRange(start, end, ''),
        selection: TextSelection.collapsed(offset: start),
      );
    }
    _apply((e) => insertNodeLink(e, id: picked.id, title: picked.title));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _apply(TextEdit Function(TextEdit e) edit) {
    final v = _controller.value;
    final sel = v.selection.isValid
        ? v.selection
        : TextSelection.collapsed(offset: v.text.length);
    final result = edit(TextEdit(v.text, sel.start, sel.end));
    _controller.value = TextEditingValue(
      text: result.text,
      selection: TextSelection(
        baseOffset: result.start,
        extentOffset: result.end,
      ),
    );
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    Widget tool(IconData icon, String tooltip, TextEdit Function(TextEdit) f) =>
        IconButton(
          icon: Icon(icon),
          tooltip: tooltip,
          visualDensity: VisualDensity.compact,
          onPressed: _preview ? null : () => _apply(f),
        );

    // Toolbar taps neither take focus nor count as tapping outside the
    // field, so the cursor and selection stay where they were.
    final toolbar = TextFieldTapRegion(
      child: ExcludeFocus(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            tool(Icons.format_bold, l10n.mdBold, (e) => toggleWrap(e, '**')),
            tool(Icons.format_italic, l10n.mdItalic, (e) => toggleWrap(e, '_')),
            tool(
              Icons.title,
              l10n.mdHeading,
              (e) => toggleLinePrefix(e, '## '),
            ),
            tool(
              Icons.format_list_bulleted,
              l10n.mdBullets,
              (e) => toggleLinePrefix(e, '- '),
            ),
            tool(
              Icons.format_list_numbered,
              l10n.mdNumbers,
              (e) => toggleLinePrefix(e, '1. '),
            ),
            tool(Icons.link, l10n.mdLink, (e) => insertLink(e)),
            IconButton(
              icon: const Icon(Icons.add_link),
              tooltip: l10n.mdLinkItem,
              visualDensity: VisualDensity.compact,
              onPressed: _preview ? null : _linkToItem,
            ),
            tool(Icons.code, l10n.mdCode, toggleCode),
            const SizedBox(width: 8),
            TextButton.icon(
              icon: Icon(
                _preview ? Icons.edit_outlined : Icons.visibility_outlined,
              ),
              label: Text(_preview ? l10n.mdEdit : l10n.mdPreview),
              onPressed: () => setState(() => _preview = !_preview),
            ),
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        toolbar,
        const SizedBox(height: 4),
        // The field stays mounted while previewing, so nothing typed is
        // lost and the preview shows exactly what is in it.
        Visibility(
          visible: !_preview,
          maintainState: true,
          child: AutosaveField(
            value: widget.value,
            controller: _controller,
            focusNode: _focus,
            maxLines: null,
            minLines: widget.minLines,
            autofocus: widget.autofocus,
            decoration: InputDecoration(
              hintText: widget.hint,
              border: const OutlineInputBorder(),
            ),
            onSave: widget.onSave,
          ),
        ),
        if (_preview)
          Container(
            constraints: BoxConstraints(minHeight: widget.minLines * 24.0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, value, _) => value.text.trim().isEmpty
                  ? Text(
                      l10n.mdNothingToPreview,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  : MarkdownView(value.text),
            ),
          ),
      ],
    );
  }
}

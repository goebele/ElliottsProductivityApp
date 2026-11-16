import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Asks for one line of text; returns it trimmed, or null if cancelled.
/// The dialog owns its text field, so nothing is disposed while it's
/// still closing.
Future<String?> promptText(
  BuildContext context, {
  required String title,
  String initial = '',
  String? suffix,
  bool number = false,
}) => showDialog<String>(
  context: context,
  builder: (_) => _PromptDialog(
    title: title,
    initial: initial,
    suffix: suffix,
    number: number,
  ),
);

/// Asks for a whole number above zero, or null if cancelled.
Future<int?> promptNumber(
  BuildContext context, {
  required String title,
  int? initial,
  String? suffix,
}) async {
  final text = await promptText(
    context,
    title: title,
    initial: initial == null ? '' : '$initial',
    suffix: suffix,
    number: true,
  );
  final n = text == null ? null : int.tryParse(text);
  return n == null || n <= 0 ? null : n;
}

class _PromptDialog extends StatefulWidget {
  const _PromptDialog({
    required this.title,
    required this.initial,
    this.suffix,
    this.number = false,
  });

  final String title;
  final String initial;
  final String? suffix;
  final bool number;

  @override
  State<_PromptDialog> createState() => _PromptDialogState();
}

class _PromptDialogState extends State<_PromptDialog> {
  late final _controller = TextEditingController(text: widget.initial)
    ..selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.initial.length,
    );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.pop(context, _controller.text.trim());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 340,
        child: TextField(
          controller: _controller,
          autofocus: true,
          keyboardType: widget.number ? TextInputType.number : null,
          decoration: InputDecoration(suffixText: widget.suffix),
          onSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.save)),
      ],
    );
  }
}

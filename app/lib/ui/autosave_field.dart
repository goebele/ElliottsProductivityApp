import 'dart:async';

import 'package:flutter/material.dart';

/// A text field that saves on its own: after a short pause in typing, when it
/// loses focus, on Enter (single-line), and when it goes away.
///
/// Saving per pause rather than per keystroke keeps the change log small.
/// While the field is not focused, outside changes (e.g. from sync) replace
/// its text.
class AutosaveField extends StatefulWidget {
  const AutosaveField({
    super.key,
    required this.value,
    required this.onSave,
    this.decoration,
    this.style,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
  });

  final String value;
  final ValueChanged<String> onSave;
  final InputDecoration? decoration;
  final TextStyle? style;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;

  @override
  State<AutosaveField> createState() => _AutosaveFieldState();
}

class _AutosaveFieldState extends State<AutosaveField> {
  static const _pause = Duration(milliseconds: 600);

  late final _controller = TextEditingController(text: widget.value);
  final _focus = FocusNode();
  Timer? _timer;
  late String _saved = widget.value;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) _flush();
    });
  }

  @override
  void didUpdateWidget(AutosaveField old) {
    super.didUpdateWidget(old);
    if (!_focus.hasFocus && widget.value != _controller.text) {
      _controller.text = widget.value;
      _saved = widget.value;
    }
  }

  void _changed(String _) {
    _timer?.cancel();
    _timer = Timer(_pause, _flush);
  }

  void _flush() {
    _timer?.cancel();
    final text = _controller.text;
    if (text != _saved) {
      _saved = text;
      widget.onSave(text);
    }
  }

  @override
  void dispose() {
    _flush();
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focus,
      autofocus: widget.autofocus,
      decoration: widget.decoration,
      style: widget.style,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      keyboardType: widget.maxLines == 1
          ? TextInputType.text
          : TextInputType.multiline,
      onChanged: _changed,
      onSubmitted: widget.maxLines == 1 ? (_) => _flush() : null,
    );
  }
}

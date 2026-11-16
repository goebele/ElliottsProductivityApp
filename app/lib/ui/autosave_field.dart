import 'dart:async';

import 'package:flutter/material.dart';

/// A text field that saves on its own: after a short pause in typing, when it
/// loses focus, on Enter (single-line), and when it goes away.
///
/// Saving per pause rather than per keystroke keeps the change log small.
/// While the field is not focused, outside changes (e.g. from sync) replace
/// its text. Edits made through [controller] (a formatting toolbar, say) are
/// saved the same way as typing.
class AutosaveField extends StatefulWidget {
  const AutosaveField({
    super.key,
    required this.value,
    required this.onSave,
    this.controller,
    this.focusNode,
    this.decoration,
    this.style,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
  });

  final String value;
  final ValueChanged<String> onSave;

  /// Optional, for callers that edit the text too. Its text is set from
  /// [value] when the field starts.
  final TextEditingController? controller;
  final FocusNode? focusNode;
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

  late final TextEditingController _controller;
  late final FocusNode _focus;
  Timer? _timer;
  late String _saved = widget.value;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.text = widget.value;
    _controller.addListener(_changed);
    _focus = widget.focusNode ?? FocusNode();
    _focus.addListener(_focusChanged);
  }

  void _focusChanged() {
    if (!_focus.hasFocus) _flush();
  }

  @override
  void didUpdateWidget(AutosaveField old) {
    super.didUpdateWidget(old);
    if (!_focus.hasFocus && widget.value != _controller.text) {
      _saved = widget.value;
      _controller.text = widget.value;
    }
  }

  void _changed() {
    if (_controller.text == _saved) return; // selection moves, outside sets
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
    _controller.removeListener(_changed);
    _focus.removeListener(_focusChanged);
    if (widget.focusNode == null) _focus.dispose();
    if (widget.controller == null) _controller.dispose();
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
      onSubmitted: widget.maxLines == 1 ? (_) => _flush() : null,
    );
  }
}

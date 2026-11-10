import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'files.dart';

/// Markup (DESIGN.md §6.4): strokes, highlighter and text labels drawn
/// over an image, and highlighted ranges in a text file. Every mark is its
/// own `annotations` row.

/// The preset colours.
const markupColors = <int>[
  0xFFE53935, // red
  0xFFFB8C00, // orange
  0xFFFDD835, // yellow
  0xFF43A047, // green
  0xFF1E88E5, // blue
  0xFF212121, // black
];

enum MarkupTool { pen, highlighter, eraser, text }

/// A decoded stroke or label, in 0–1 image coordinates.
sealed class _Mark {
  const _Mark(this.id, this.color);
  final String id;
  final Color color;

  static _Mark? parse(Annotation a) {
    try {
      final d = jsonDecode(a.dataJson) as Map<String, dynamic>;
      return switch (a.kind) {
        AnnotationKind.stroke => _Stroke(
          a.id,
          Color(a.color),
          [for (final p in (d['points'] as List).cast<num>()) p.toDouble()],
          (d['width'] as num?)?.toDouble() ?? 0.006,
          d['pen'] == 'highlighter',
        ),
        AnnotationKind.textLabel => _Label(
          a.id,
          Color(a.color),
          Offset((d['x'] as num).toDouble(), (d['y'] as num).toDouble()),
          d['text'] as String? ?? '',
        ),
        AnnotationKind.highlight => null,
      };
    } catch (_) {
      return null; // Unreadable (e.g. from a newer version): skipped.
    }
  }
}

class _Stroke extends _Mark {
  const _Stroke(
    super.id,
    super.color,
    this.points,
    this.width,
    this.highlighter,
  );
  final List<double> points;
  final double width;
  final bool highlighter;

  Iterable<Offset> get offsets sync* {
    for (var i = 0; i + 1 < points.length; i += 2) {
      yield Offset(points[i], points[i + 1]);
    }
  }
}

class _Label extends _Mark {
  const _Label(super.id, super.color, this.at, this.text);
  final Offset at;
  final String text;
}

/// Whether [n] is within [reach] of any segment of [stroke] (0–1 units).
bool _nearStroke(_Stroke stroke, Offset n, double reach) {
  final pts = stroke.offsets.toList();
  if (pts.length == 1) return (pts.first - n).distance < reach;
  for (var i = 0; i + 1 < pts.length; i++) {
    final a = pts[i];
    final b = pts[i + 1];
    final ab = b - a;
    final len2 = ab.dx * ab.dx + ab.dy * ab.dy;
    final t = len2 == 0
        ? 0.0
        : (((n - a).dx * ab.dx + (n - a).dy * ab.dy) / len2).clamp(0.0, 1.0);
    if ((a + ab * t - n).distance < reach) return true;
  }
  return false;
}

/// Draws marks over an image of [size].
class _MarkupPainter extends CustomPainter {
  _MarkupPainter(this.marks, {this.live});

  final List<_Mark> marks;

  /// The stroke being drawn right now.
  final _Stroke? live;

  @override
  void paint(Canvas canvas, Size size) =>
      _paintMarks(canvas, size, [...marks, ?live]);

  @override
  bool shouldRepaint(_MarkupPainter old) =>
      old.marks != marks || old.live != live;
}

void _paintMarks(Canvas canvas, Size size, List<_Mark> marks) {
  final scale = math.min(size.width, size.height);
  for (final m in marks) {
    switch (m) {
      case _Stroke():
        final pts = [
          for (final o in m.offsets)
            Offset(o.dx * size.width, o.dy * size.height),
        ];
        if (pts.isEmpty) continue;
        final paint = Paint()
          ..color = m.highlighter ? m.color.withValues(alpha: 0.4) : m.color
          ..strokeWidth = m.width * scale
          ..strokeCap = m.highlighter ? StrokeCap.square : StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke
          ..blendMode = m.highlighter ? BlendMode.multiply : BlendMode.srcOver;
        if (pts.length == 1) {
          canvas.drawPoints(ui.PointMode.points, pts, paint);
        } else {
          final path = Path()..moveTo(pts.first.dx, pts.first.dy);
          for (final p in pts.skip(1)) {
            path.lineTo(p.dx, p.dy);
          }
          canvas.drawPath(path, paint);
        }
      case _Label():
        final tp = TextPainter(
          text: TextSpan(
            text: m.text,
            style: TextStyle(
              color: m.color,
              fontSize: math.max(12, scale * 0.04),
              fontWeight: FontWeight.w600,
              shadows: const [Shadow(color: Colors.white, blurRadius: 3)],
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: size.width);
        tp.paint(canvas, Offset(m.at.dx * size.width, m.at.dy * size.height));
    }
  }
}

/// An image with its markup. View mode zooms and pans; markup mode draws
/// with the chosen tool.
class ImageMarkupView extends ConsumerStatefulWidget {
  const ImageMarkupView({
    super.key,
    required this.attachment,
    required this.editing,
    required this.showMarkup,
  });

  final Attachment attachment;
  final bool editing;
  final bool showMarkup;

  @override
  ConsumerState<ImageMarkupView> createState() => _ImageMarkupViewState();
}

class _ImageMarkupViewState extends ConsumerState<ImageMarkupView> {
  MarkupTool _tool = MarkupTool.pen;
  int _color = markupColors.first;
  List<double>? _drawing;

  /// Marks added in this session, newest last, for Undo.
  final _mine = <String>[];

  Offset _norm(Offset local, Size size) => Offset(
    (local.dx / size.width).clamp(0, 1),
    (local.dy / size.height).clamp(0, 1),
  );

  Future<void> _finishStroke() async {
    final pts = _drawing;
    setState(() => _drawing = null);
    if (pts == null || pts.isEmpty) return;
    final repo = (await ref.read(nodeRepositoryProvider.future)).files;
    final id = await repo.annotate(
      widget.attachment.id,
      AnnotationKind.stroke,
      {
        'points': [for (final p in pts) double.parse(p.toStringAsFixed(4))],
        'width': _tool == MarkupTool.highlighter ? 0.03 : 0.006,
        'pen': _tool == MarkupTool.highlighter ? 'highlighter' : 'pen',
      },
      color: _color,
    );
    _mine.add(id);
  }

  /// Where the current drag touched down.
  Offset? _down;

  /// Where the eraser last was, so a fast swipe erases everything between.
  Offset? _lastErase;

  /// Erases every mark the eraser's path from [_lastErase] to [n] touches.
  Future<void> _eraseAt(Offset n, List<_Mark> marks, Size size) async {
    final from = _lastErase ?? n;
    _lastErase = n;
    final scale = math.min(size.width, size.height);
    final reach = 12 / scale; // about 12 px, in 0–1 units
    final steps = math.max(1, ((n - from).distance / (reach / 2)).ceil());
    final path = [
      for (var i = 0; i <= steps; i++) Offset.lerp(from, n, i / steps)!,
    ];
    final hits = <String>{
      for (final m in marks)
        if (path.any(
          (p) => switch (m) {
            _Stroke() => _nearStroke(m, p, reach + m.width),
            _Label() =>
              (p - m.at).dx > -reach &&
                  (p - m.at).dx < 0.3 &&
                  (p - m.at).dy > -reach &&
                  (p - m.at).dy < 0.06,
          },
        ))
          m.id,
    };
    if (hits.isEmpty) return;
    final repo = (await ref.read(nodeRepositoryProvider.future)).files;
    for (final id in hits) {
      await repo.setAnnotationDeleted(id, true);
    }
  }

  Future<void> _label(Offset n) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.markupLabelTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (text == null || text.trim().isEmpty) return;
    final repo = (await ref.read(nodeRepositoryProvider.future)).files;
    _mine.add(
      await repo.annotate(widget.attachment.id, AnnotationKind.textLabel, {
        'x': n.dx,
        'y': n.dy,
        'text': text.trim(),
      }, color: _color),
    );
  }

  Future<void> _undo() async {
    if (_mine.isEmpty) return;
    final repo = (await ref.read(nodeRepositoryProvider.future)).files;
    await repo.setAnnotationDeleted(_mine.removeLast(), true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final a = widget.attachment;
    final blobs = ref.watch(blobStoreProvider).value;
    final file = blobs?.fileFor(a.contentHash);
    final marks = [
      for (final r
          in ref.watch(annotationsProvider(a.id)).value ?? const <Annotation>[])
        ?_Mark.parse(r),
    ];
    final aspect = (a.width ?? 4) / (a.height ?? 3);

    final image = file == null || !file.existsSync()
        ? const Center(child: Icon(Icons.broken_image_outlined, size: 48))
        : Image.file(file, fit: BoxFit.fill);

    Widget canvas(Size size) => Stack(
      fit: StackFit.expand,
      children: [
        image,
        if (widget.showMarkup || widget.editing)
          CustomPaint(
            painter: _MarkupPainter(
              marks,
              live: _drawing == null
                  ? null
                  : _Stroke(
                      'live',
                      Color(_color),
                      _drawing!,
                      _tool == MarkupTool.highlighter ? 0.03 : 0.006,
                      _tool == MarkupTool.highlighter,
                    ),
            ),
          ),
        if (widget.editing)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (d) {
              final n = _norm(d.localPosition, size);
              switch (_tool) {
                case MarkupTool.text:
                  _label(n);
                case MarkupTool.eraser:
                  _lastErase = null;
                  _eraseAt(n, marks, size);
                case MarkupTool.pen || MarkupTool.highlighter:
                  setState(() => _drawing = [n.dx, n.dy]);
                  _finishStroke();
              }
            },
            // Strokes start where the pen touched down, not where the drag
            // was recognised, so the start of a line isn't lost.
            onPanDown: (d) => _down = _norm(d.localPosition, size),
            onPanCancel: () => _down = null,
            onPanStart: (d) {
              final here = _norm(d.localPosition, size);
              final start = _down ?? here;
              _down = null;
              if (_tool == MarkupTool.eraser) {
                _lastErase = start;
                _eraseAt(here, marks, size);
              } else if (_tool != MarkupTool.text) {
                setState(
                  () => _drawing = [
                    start.dx,
                    start.dy,
                    if (here != start) ...[here.dx, here.dy],
                  ],
                );
              }
            },
            onPanUpdate: (d) {
              final n = _norm(d.localPosition, size);
              if (_tool == MarkupTool.eraser) {
                _eraseAt(n, marks, size);
              } else if (_drawing != null) {
                setState(() => _drawing = [..._drawing!, n.dx, n.dy]);
              }
            },
            onPanEnd: (_) => _finishStroke(),
          ),
      ],
    );

    final picture = Center(
      child: AspectRatio(
        aspectRatio: aspect,
        child: LayoutBuilder(
          builder: (context, c) => canvas(Size(c.maxWidth, c.maxHeight)),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.editing)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SegmentedButton<MarkupTool>(
                  showSelectedIcon: false,
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                  ),
                  segments: [
                    ButtonSegment(
                      value: MarkupTool.pen,
                      icon: const Icon(Icons.edit),
                      tooltip: l10n.markupPen,
                    ),
                    ButtonSegment(
                      value: MarkupTool.highlighter,
                      icon: const Icon(Icons.highlight),
                      tooltip: l10n.markupHighlighter,
                    ),
                    ButtonSegment(
                      value: MarkupTool.text,
                      icon: const Icon(Icons.text_fields),
                      tooltip: l10n.markupText,
                    ),
                    ButtonSegment(
                      value: MarkupTool.eraser,
                      icon: const Icon(Icons.auto_fix_normal),
                      tooltip: l10n.markupEraser,
                    ),
                  ],
                  selected: {_tool},
                  onSelectionChanged: (s) => setState(() => _tool = s.single),
                ),
                const SizedBox(width: 8),
                for (final c in markupColors)
                  Semantics(
                    selected: c == _color,
                    button: true,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => setState(() => _color = c),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Color(c),
                          child: c == _color
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: l10n.markupUndo,
                  icon: const Icon(Icons.undo),
                  onPressed: _mine.isEmpty ? null : _undo,
                ),
              ],
            ),
          ),
        // Drawing needs the picture still; viewing can zoom and pan.
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 640),
          child: widget.editing
              ? picture
              : InteractiveViewer(maxScale: 6, child: picture),
        ),
      ],
    );
  }
}

/// Renders [a] with its markup into a PNG at the image's own size.
Future<Uint8List?> flattenImage(WidgetRef ref, Attachment a) async {
  final repo = (await ref.read(nodeRepositoryProvider.future)).files;
  final bytes = await repo.bytesOf(a);
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  final img = frame.image;
  final size = Size(img.width.toDouble(), img.height.toDouble());
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawImage(img, Offset.zero, Paint());
  _paintMarks(canvas, size, [
    for (final r in await repo.annotations(a.id)) ?_Mark.parse(r),
  ]);
  final out = await recorder.endRecording().toImage(img.width, img.height);
  final png = await out.toByteData(format: ui.ImageByteFormat.png);
  img.dispose();
  out.dispose();
  return png?.buffer.asUint8List();
}

/// A text file. `.md` shows formatted until markup mode, which shows the
/// raw text: select some and Highlight it; "Clear" removes highlights in
/// the selection. Highlights are character ranges of the raw text.
class TextMarkupView extends ConsumerStatefulWidget {
  const TextMarkupView({
    super.key,
    required this.attachment,
    required this.editing,
    required this.showMarkup,
    required this.formatted,
  });

  final Attachment attachment;
  final bool editing;
  final bool showMarkup;

  /// Shown as rendered markdown when not marking up.
  final Widget Function(String text)? formatted;

  @override
  ConsumerState<TextMarkupView> createState() => _TextMarkupViewState();
}

class _TextMarkupViewState extends ConsumerState<TextMarkupView> {
  TextSelection? _selection;
  int _color = markupColors[2];
  String? _text;
  String? _loadedHash;

  /// Bigger text files open in another app instead.
  static const _maxShown = 2 * 1024 * 1024;

  /// Text files are small: read straight from the blob store.
  String? _textOf(Attachment a) {
    if (_loadedHash == a.contentHash) return _text;
    final blobs = ref.read(blobStoreProvider).value;
    final file = blobs?.fileFor(a.contentHash);
    if (file == null || !file.existsSync()) return null;
    _loadedHash = a.contentHash;
    return _text = utf8.decode(file.readAsBytesSync(), allowMalformed: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    if (widget.attachment.sizeBytes > _maxShown) {
      return Text(l10n.fileTooBigToShow);
    }
    final text = _textOf(widget.attachment);
    if (text == null) return const SizedBox(height: 120);
    final highlights = [
      for (final r
          in ref.watch(annotationsProvider(widget.attachment.id)).value ??
              const <Annotation>[])
        if (r.kind == AnnotationKind.highlight)
          if (_range(r, text.length) case final range?) (r, range),
    ];

    if (!widget.editing && widget.formatted != null) {
      return widget.formatted!(text);
    }

    final spans = <TextSpan>[];
    if (!widget.showMarkup && !widget.editing) {
      spans.add(TextSpan(text: text));
    } else {
      // Colour per character, latest highlight on top.
      final colors = List<int?>.filled(text.length, null);
      for (final (r, (start, end)) in highlights) {
        for (var i = start; i < end; i++) {
          colors[i] = r.color;
        }
      }
      var i = 0;
      while (i < text.length) {
        var j = i;
        while (j < text.length && colors[j] == colors[i]) {
          j++;
        }
        spans.add(
          TextSpan(
            text: text.substring(i, j),
            style: colors[i] == null
                ? null
                : TextStyle(
                    backgroundColor: Color(colors[i]!).withValues(alpha: 0.45),
                  ),
          ),
        );
        i = j;
      }
    }

    Future<void> highlight() async {
      final s = _selection;
      if (s == null || s.isCollapsed) return;
      final repo = (await ref.read(nodeRepositoryProvider.future)).files;
      await repo.annotate(widget.attachment.id, AnnotationKind.highlight, {
        'start': s.start,
        'end': s.end,
      }, color: _color);
    }

    Future<void> clear() async {
      final s = _selection;
      if (s == null) return;
      final repo = (await ref.read(nodeRepositoryProvider.future)).files;
      for (final (r, (start, end)) in highlights) {
        if (start < s.end && end > s.start) {
          await repo.setAnnotationDeleted(r.id, true);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.editing)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.highlight),
                  label: Text(l10n.markupHighlight),
                  onPressed: highlight,
                ),
                TextButton(onPressed: clear, child: Text(l10n.markupClear)),
                for (final c in markupColors.take(5))
                  InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => setState(() => _color = c),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 11,
                        backgroundColor: Color(c),
                        child: c == _color
                            ? const Icon(
                                Icons.check,
                                size: 13,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                Text(l10n.markupSelectHint, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        SelectableText.rich(
          TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              height: 1.4,
            ),
            children: spans,
          ),
          onSelectionChanged: (s, _) => _selection = s,
        ),
      ],
    );
  }

  static (int, int)? _range(Annotation r, int length) {
    try {
      final d = jsonDecode(r.dataJson) as Map<String, dynamic>;
      final start = (d['start'] as num).toInt().clamp(0, length);
      final end = (d['end'] as num).toInt().clamp(0, length);
      return end > start ? (start, end) : null;
    } catch (_) {
      return null;
    }
  }
}

/// Saves bytes through the system "Save as" dialog.
Future<void> saveBytesAs(
  BuildContext context,
  String filename,
  Uint8List bytes,
  String mime,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.maybeOf(context);
  final uri = await saveFileDialog(filename, bytes, mime);
  if (uri != null) {
    messenger?.showSnackBar(SnackBar(content: Text(l10n.fileSaved)));
  }
}

/// Replaceable in tests, which have no file dialogs.
Future<Object?> Function(String name, Uint8List bytes, String mime)
saveFileDialog = (name, bytes, mime) =>
    FilePicker.saveFile(fileName: name, bytes: bytes, mimeType: mime);

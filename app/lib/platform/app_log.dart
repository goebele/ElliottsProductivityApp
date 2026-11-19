import 'dart:io';
import 'dart:ui' show AppExitResponse, PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// A small log file on this device (`logs/app.log` in app support), so an
/// app that closes or misbehaves leaves a trace: startup, errors, the app
/// going to the background and back, close requests, sync problems.
///
/// Kept small for phones: when it passes [maxBytes] it becomes
/// `app.prev.log` (replacing the older one), so at most two files.
/// Never synced; holds no note contents.
class AppLog {
  static const maxBytes = 512 * 1024;

  static File? _file;
  static int _size = 0;
  static AppLifecycleListener? _lifecycle;

  static File? get file => _file;

  /// Opens the log and hooks in error reporting. Call once, at startup;
  /// without it (tests) nothing is written.
  static Future<void> init() async {
    try {
      final dir = Directory(
        p.join((await getApplicationSupportDirectory()).path, 'logs'),
      );
      await dir.create(recursive: true);
      _file = File(p.join(dir.path, 'app.log'));
      _size = _file!.existsSync() ? _file!.lengthSync() : 0;
    } catch (_) {
      _file = null;
      return;
    }

    write(
      'start',
      '${Platform.operatingSystem} ${Platform.operatingSystemVersion}, '
          'pid $pid, ${kReleaseMode ? 'release' : 'debug'}',
    );

    // Everything that already goes to debugPrint lands here too.
    final print = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      print(message, wrapWidth: wrapWidth);
      if (message != null) write('print', message);
    };

    final flutterError = FlutterError.onError;
    FlutterError.onError = (details) {
      write('error', details.exceptionAsString(), details.stack);
      flutterError?.call(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      write('uncaught', error, stack);
      return false; // still reported the usual way
    };

    _lifecycle = AppLifecycleListener(
      onStateChange: (state) => write('app', state.name),
      onExitRequested: () async {
        write('app', 'close requested');
        return AppExitResponse.exit;
      },
    );
  }

  /// One line (and a stack, if given). Never throws.
  static void write(String tag, Object? message, [StackTrace? stack]) {
    final f = _file;
    if (f == null) return;
    try {
      final b = StringBuffer()
        ..write(DateTime.now().toIso8601String())
        ..write(' [$tag] ')
        ..writeln(message);
      if (stack != null) {
        // The top of the stack is what matters; keep lines bounded.
        b.writeln(stack.toString().split('\n').take(30).join('\n'));
      }
      final text = b.toString();
      if (_size + text.length > maxBytes) {
        final prev = File(p.join(f.parent.path, 'app.prev.log'));
        if (prev.existsSync()) prev.deleteSync();
        f.renameSync(prev.path);
        _size = 0;
      }
      // Written straight away, so a sudden exit doesn't lose the last line.
      f.writeAsStringSync(text, mode: FileMode.append, flush: true);
      _size += text.length;
    } catch (_) {
      // A log must never take the app down.
    }
  }

  /// The newest lines of the log (both files), for copying.
  static String tail({int lines = 300}) {
    final f = _file;
    if (f == null) return '';
    final all = <String>[];
    for (final file in [File(p.join(f.parent.path, 'app.prev.log')), f]) {
      try {
        if (file.existsSync()) all.addAll(file.readAsLinesSync());
      } catch (_) {}
    }
    return all.skip(all.length > lines ? all.length - lines : 0).join('\n');
  }

  @visibleForTesting
  static void useFile(File? file) {
    _file = file;
    _size = file != null && file.existsSync() ? file.lengthSync() : 0;
    _lifecycle?.dispose();
    _lifecycle = null;
  }
}

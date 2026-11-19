import 'dart:io';

import 'package:elliotts_productivity_app/platform/app_log.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory dir;
  setUp(() {
    dir = Directory.systemTemp.createTempSync('epa_log_');
    AppLog.useFile(File(p.join(dir.path, 'app.log')));
  });
  tearDown(() {
    AppLog.useFile(null);
    dir.deleteSync(recursive: true);
  });

  test('writes lines with a tag, and a stack when given', () {
    AppLog.write('start', 'hello');
    AppLog.write('error', 'boom', StackTrace.current);
    final text = AppLog.file!.readAsStringSync();
    expect(text, contains('[start] hello'));
    expect(text, contains('[error] boom'));
    expect(text, contains('app_log_test.dart'));
  });

  test('rolls over to app.prev.log, keeping at most two files', () {
    final line = 'x' * 1000;
    for (var i = 0; i < (AppLog.maxBytes ~/ 1000) * 3; i++) {
      AppLog.write('t', line);
    }
    final files = dir.listSync().map((f) => p.basename(f.path)).toSet();
    expect(files, {'app.log', 'app.prev.log'});
    for (final f in dir.listSync().whereType<File>()) {
      expect(f.lengthSync(), lessThanOrEqualTo(AppLog.maxBytes));
    }
    expect(AppLog.tail(lines: 5).split('\n'), hasLength(5));
  });

  test('without a file nothing is written and nothing throws', () {
    AppLog.useFile(null);
    AppLog.write('t', 'ignored');
    expect(AppLog.tail(), isEmpty);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'platform/app_log.dart';
import 'platform/reminder_notifier.dart';
import 'platform/timer_platform.dart';
import 'ui/app.dart';
import 'ui/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // A trace on disk if the app closes or misbehaves (Settings > App log).
  await AppLog.init();
  // This device's own settings (the theme), before the first frame.
  await LocalPrefs.load();
  // Time slots keep their wall-clock time across DST (§6.5).
  await ReminderNotifier.initTimeZones();
  await TimerPlatform.init();
  runApp(const ProviderScope(child: App()));
}

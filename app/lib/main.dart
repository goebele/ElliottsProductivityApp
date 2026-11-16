import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'platform/reminder_notifier.dart';
import 'platform/timer_platform.dart';
import 'ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Time slots keep their wall-clock time across DST (§6.5).
  await ReminderNotifier.initTimeZones();
  await TimerPlatform.init();
  runApp(const ProviderScope(child: App()));
}

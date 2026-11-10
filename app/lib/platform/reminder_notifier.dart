import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../domain/calendar.dart';
import '../domain/node_repository.dart';

/// Local notifications for reminders (DESIGN.md §6.5): Windows toasts and
/// Android notifications, scheduled for the next two weeks and rescheduled
/// whenever items, reminders or completions change. No push in v1.
class ReminderNotifier {
  ReminderNotifier._();

  static final instance = ReminderNotifier._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  StreamSubscription<void>? _changes;
  Timer? _debounce;

  /// Item ids from tapped notifications, for the app to open.
  final opened = ValueNotifier<String?>(null);

  /// Off in widget tests, which have no notification platform.
  static bool enabled = true;

  static bool get _supported =>
      enabled &&
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.android);

  /// Loads the time zone database and this device's zone (so time slots
  /// keep their wall-clock time, §6.5). Safe to call more than once.
  static Future<void> initTimeZones() async {
    tzdata.initializeTimeZones();
    try {
      final id = (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(id));
      deviceTimeZone = id;
    } catch (_) {
      // Unknown zone: times fall back to the device's local offset.
    }
  }

  Future<void> _init() async {
    if (_ready || !_supported) return;
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        windows: WindowsInitializationSettings(
          appName: "Elliott's Productivity App",
          appUserModelId: 'Elliott.ProductivityApp.Reminders.1',
          guid: '5b8f6c2e-3a4d-4e7b-9c1f-2d6a8e0b4f37',
        ),
      ),
      onDidReceiveNotificationResponse: (r) => opened.value = r.payload,
    );
    _ready = true;
  }

  /// Asks to show notifications (Android 13+) and set exact alarms.
  Future<void> requestPermission() async {
    if (!_supported) return;
    await _init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
  }

  /// Schedules now and again after every change (debounced).
  Future<void> start(NodeRepository repo) async {
    if (!_supported) return;
    try {
      await _init();
    } catch (e) {
      debugPrint('Reminders unavailable: $e');
      return;
    }
    await _changes?.cancel();
    _changes = repo.reminders.watchChanges().listen((_) {
      _debounce?.cancel();
      _debounce = Timer(
        const Duration(seconds: 2),
        () => unawaited(
          _reschedule(
            repo,
          ).catchError((Object e) => debugPrint('Reminders not scheduled: $e')),
        ),
      );
    });
  }

  Future<void> _reschedule(NodeRepository repo) async {
    final now = DateTime.now();
    final planned = await repo.reminders.planned(
      now,
      now.add(ReminderRepository.horizon),
    );
    await _plugin.cancelAllPendingNotifications();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final exact = await android?.canScheduleExactNotifications() ?? true;
    // Platforms cap pending alarms; two weeks rarely gets near this.
    for (final (i, p) in planned.take(60).indexed) {
      final e = p.entry;
      final title = e.node.title.trim().isEmpty ? '…' : e.node.title.trim();
      await _plugin.zonedSchedule(
        id: i,
        title: title,
        body: _body(e),
        payload: e.node.id,
        scheduledDate: tz.TZDateTime.from(p.at, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminders',
            'Reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          windows: WindowsNotificationDetails(),
        ),
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  static String _body(CalendarEntry e) {
    String two(int n) => n.toString().padLeft(2, '0');
    final s = e.start;
    return switch (e.kind) {
      CalendarEntryKind.deadline when s == null => 'Due ${dateKey(e.day)}',
      _ when s != null => '${two(s.hour)}:${two(s.minute)}',
      _ => dateKey(e.day),
    };
  }
}

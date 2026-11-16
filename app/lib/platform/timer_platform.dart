import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '../data/database.dart';
import 'reminder_notifier.dart';

/// Where a running timer shows outside the app window (DESIGN.md §6.15):
/// on Windows a tray icon (with Pause / Stop / Show) and an optional
/// always-on-top mini window; on Android an ongoing notification with
/// Pause and Stop.
class TimerPlatform with TrayListener {
  TimerPlatform._();

  static final instance = TimerPlatform._();

  /// Off in widget tests, which have no tray, windows or notifications.
  static bool enabled = true;

  /// The app's handlers for "pause", "stop" and "show" (set at startup).
  void Function(String action)? onAction;

  /// True while the app is shrunk to the mini timer window.
  final miniWindow = ValueNotifier<bool>(false);

  static bool get _windows =>
      enabled && !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
  static bool get _android =>
      enabled && !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  bool get canMiniWindow => _windows;

  String? _shown;
  bool _trayUp = false;
  Rect? _bounds;

  static const _notificationId = 999001;

  /// Called on every timer tick; acts only when something visible changed
  /// (the tray tooltip changes once a minute).
  void update({
    required TimeEntry? running,
    required String title,
    required bool paused,
  }) {
    if (!_windows && !_android) return;
    final minutes = running == null
        ? 0
        : DateTime.now().toUtc().difference(running.startedAt).inMinutes;
    final key = running == null
        ? (paused ? 'paused|$title' : null)
        : 'run|${running.id}|$title|$minutes';
    if (key == _shown) return;
    _shown = key;
    unawaited(
      _apply(
        running,
        title,
        paused,
        minutes,
      ).catchError((Object e) => debugPrint('Timer display unavailable: $e')),
    );
  }

  Future<void> _apply(
    TimeEntry? running,
    String title,
    bool paused,
    int minutes,
  ) async {
    if (_windows) {
      if (running == null && !paused) {
        if (_trayUp) {
          await trayManager.destroy();
          trayManager.removeListener(this);
          _trayUp = false;
        }
        if (miniWindow.value) await exitMiniWindow();
        return;
      }
      if (!_trayUp) {
        await trayManager.setIcon('assets/tray_icon.ico');
        trayManager.addListener(this);
        _trayUp = true;
      }
      final h = minutes ~/ 60;
      final m = (minutes % 60).toString().padLeft(2, '0');
      await trayManager.setToolTip(
        running == null ? '⏸ $title' : '⏱ $title · $h:$m',
      );
      await trayManager.setContextMenu(
        Menu(
          items: [
            MenuItem(key: 'show', label: 'Show'),
            MenuItem.separator(),
            if (running != null)
              MenuItem(key: 'pause', label: 'Pause')
            else
              MenuItem(key: 'resume', label: 'Resume'),
            MenuItem(key: 'stop', label: 'Stop'),
          ],
        ),
      );
    }
    if (_android) {
      final plugin = await ReminderNotifier.instance.plugin();
      if (running == null) {
        await plugin.cancel(id: _notificationId);
        return;
      }
      await plugin.show(
        id: _notificationId,
        title: title,
        body: running.focusMinutes == null
            ? 'Timer running'
            : 'Focus · ${running.focusMinutes} min',
        payload: running.nodeId,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'timer',
            'Timer',
            importance: Importance.low,
            priority: Priority.low,
            ongoing: true,
            autoCancel: false,
            onlyAlertOnce: true,
            showWhen: true,
            usesChronometer: true,
            when: running.startedAt.millisecondsSinceEpoch,
            actions: const [
              AndroidNotificationAction(
                'timer_pause',
                'Pause',
                showsUserInterface: true,
              ),
              AndroidNotificationAction(
                'timer_stop',
                'Stop',
                showsUserInterface: true,
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void onTrayIconMouseDown() => onAction?.call('show');

  @override
  void onTrayIconRightMouseDown() => trayManager.popUpContextMenu();

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key case final key?) onAction?.call(key);
  }

  /// Shrinks the app to a small always-on-top window showing just the
  /// timer.
  Future<void> enterMiniWindow() async {
    if (!_windows || miniWindow.value) return;
    _bounds = await windowManager.getBounds();
    miniWindow.value = true;
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setMinimumSize(const Size(240, 44));
    await windowManager.setSize(const Size(380, 52));
    await windowManager.setAlwaysOnTop(true);
  }

  Future<void> exitMiniWindow() async {
    if (!_windows || !miniWindow.value) return;
    miniWindow.value = false;
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.setMinimumSize(const Size(400, 300));
    if (_bounds case final b?) await windowManager.setBounds(b);
    await windowManager.show();
    await windowManager.focus();
  }

  /// Brings the main window forward (from the tray).
  Future<void> show() async {
    if (!_windows) return;
    if (miniWindow.value) await exitMiniWindow();
    await windowManager.show();
    await windowManager.focus();
  }

  /// Windows: sets up the window manager. Call once before runApp.
  static Future<void> init() async {
    if (!_windows || !Platform.isWindows) return;
    await windowManager.ensureInitialized();
  }
}

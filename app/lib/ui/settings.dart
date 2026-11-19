import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/app_localizations.dart';
import '../platform/app_log.dart';

/// Settings for this device only (§5.4 `ui_prefs`): never synced, kept in
/// a small file next to the database. Loaded before the first frame, so
/// the theme is right from the start.
class LocalPrefs {
  static final _values = <String, Object?>{};
  static File? _file;

  /// Reads the file (once, at startup). Without one (tests), values stay
  /// in memory.
  static Future<void> load() async {
    try {
      final dir = await getApplicationSupportDirectory();
      _file = File(p.join(dir.path, 'ui_prefs.json'));
      if (await _file!.exists()) {
        _values.addAll(
          (jsonDecode(await _file!.readAsString()) as Map)
              .cast<String, Object?>(),
        );
      }
    } catch (_) {
      // No file or no folder: defaults.
    }
  }

  static Object? get(String key) => _values[key];

  static Future<void> set(String key, Object? value) async {
    _values[key] = value;
    try {
      await _file?.writeAsString(jsonEncode(_values));
    } catch (_) {}
  }
}

/// Light, dark, or the device's own setting (the default).
final themeModeProvider = NotifierProvider<ThemeModeSetting, ThemeMode>(
  ThemeModeSetting.new,
);

class ThemeModeSetting extends Notifier<ThemeMode> {
  static const _key = 'theme';

  @override
  ThemeMode build() => ThemeMode.values.firstWhere(
    (m) => m.name == LocalPrefs.get(_key),
    orElse: () => ThemeMode.system,
  );

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await LocalPrefs.set(_key, mode.name);
  }
}

/// The gear in the top bar: opens Settings.
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key, required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: AppLocalizations.of(context).settingsView,
    icon: const Icon(Icons.settings_outlined),
    onPressed: onOpen,
  );
}

bool get _desktop => Platform.isWindows || Platform.isMacOS || Platform.isLinux;

/// Desktop: opens the log file. Phone: copies its newest lines, to paste
/// into a message.
Future<void> _openLog(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final file = AppLog.file;
  if (_desktop && file != null && file.existsSync()) {
    await OpenFilex.open(file.path, type: 'text/plain');
    return;
  }
  await Clipboard.setData(ClipboardData(text: AppLog.tail()));
  messenger.showSnackBar(SnackBar(content: Text(l10n.settingsLogCopied)));
}

/// Settings: Appearance (this device), and Devices. Other settings move
/// here over time.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key, required this.onOpenDevices});

  final VoidCallback onOpenDevices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final mode = ref.watch(themeModeProvider);

    Widget heading(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
      child: Text(text, style: theme.textTheme.titleMedium),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        Text(l10n.settingsView, style: theme.textTheme.headlineSmall),
        heading(l10n.settingsAppearance),
        Text(l10n.settingsTheme, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                icon: const Icon(Icons.brightness_auto_outlined),
                label: Text(l10n.settingsThemeSystem),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: const Icon(Icons.light_mode_outlined),
                label: Text(l10n.settingsThemeLight),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: const Icon(Icons.dark_mode_outlined),
                label: Text(l10n.settingsThemeDark),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (s) =>
                ref.read(themeModeProvider.notifier).set(s.single),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.settingsThisDeviceOnly,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        heading(l10n.settingsSync),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: const Icon(Icons.devices_outlined),
            title: Text(l10n.devicesView),
            subtitle: Text(l10n.settingsDevicesHelp),
            trailing: const Icon(Icons.chevron_right),
            onTap: onOpenDevices,
          ),
        ),
        heading(l10n.settingsTroubleshooting),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.settingsLog),
            subtitle: Text(
              _desktop
                  ? l10n.settingsLogHelpDesktop
                  : l10n.settingsLogHelpPhone,
            ),
            trailing: Icon(_desktop ? Icons.open_in_new : Icons.copy),
            onTap: () => _openLog(context),
          ),
        ),
      ],
    );
  }
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Elliott\'s Productivity App';

  @override
  String get homeReady =>
      'Your device is set up. Tasks and goals arrive in the next milestone.';

  @override
  String homeUserId(String id) {
    return 'User ID: $id';
  }

  @override
  String homeDeviceId(String id) {
    return 'Device ID: $id';
  }

  @override
  String startupError(String error) {
    return 'Something went wrong while starting up: $error';
  }
}

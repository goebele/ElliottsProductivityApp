import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

export 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Users, Spaces, SpaceMembers, Devices])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens the on-device database in the app support folder
  /// (`%APPDATA%\...` on Windows, app-internal storage on Android).
  factory AppDatabase.open() => AppDatabase(
        driftDatabase(
          name: 'epa',
          native: const DriftNativeOptions(
            databaseDirectory: getApplicationSupportDirectory,
          ),
        ),
      );

  @override
  int get schemaVersion => 1;
}

import 'package:drift/drift.dart';

import '../data/database.dart';
import '../sync/change_writer.dart';
import 'ids.dart';

/// Personal settings that follow you between devices (`user_settings`,
/// §5.0): one row per key, its id derived from the key (§7.6, L2), so two
/// devices setting the same key write the same row.
class SettingsRepository {
  SettingsRepository(this._db, this._writer, {required this.spaceId});

  final AppDatabase _db;
  final ChangeWriter _writer;
  final String spaceId;

  SimpleSelectStatement<$UserSettingsTable, UserSetting> _query(String key) =>
      _db.select(_db.userSettings)
        ..where((s) => s.key.equals(key) & s.deleted.equals(false))
        ..limit(1);

  /// The stored JSON for [key], or null if unset.
  Future<String?> get(String key) async =>
      (await _query(key).getSingleOrNull())?.value;

  Stream<String?> watch(String key) =>
      _query(key).watchSingleOrNull().map((r) => r?.value);

  /// Sets [key] to [json]; null clears it.
  Future<void> set(String key, String? json) async {
    final id = pairId('user_settings', [key]);
    if (json == null) {
      final row = await _query(key).getSingleOrNull();
      if (row != null) {
        await _writer.update(
          _db.userSettings,
          row.id,
          const UserSettingsCompanion(deleted: Value(true)),
        );
      }
      return;
    }
    await _writer.upsert(
      _db.userSettings,
      UserSettingsCompanion(
        id: Value(id),
        spaceId: Value(spaceId),
        key: Value(key),
        value: Value(json),
        deleted: const Value(false),
      ),
    );
  }
}

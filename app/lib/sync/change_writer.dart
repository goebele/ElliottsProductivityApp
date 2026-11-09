import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/database.dart';
import '../domain/ids.dart';
import 'hlc.dart';

/// The single write path for synced tables (DESIGN.md §4, §7.1).
///
/// Each insert or update stamps the row with a new HLC and the author, writes
/// it, and records one `change_log` op per field in the same transaction.
/// Sync (M3) sends those ops to peers; undo, reports and sharing can reuse them.
///
/// Callers pass companions with only the fields they mean to set; the
/// bookkeeping columns (`created_*`, `updated_by`, `hlc`) are filled in here.
class ChangeWriter {
  ChangeWriter(
    this._db, {
    required this.userId,
    required this.deviceId,
    HlcClock? clock,
  }) : _clock = clock ?? HlcClock(deviceId);

  /// Resumes this device's clock from the newest op it has issued, so stamps
  /// keep increasing across restarts even if the wall clock went backwards.
  static Future<ChangeWriter> open(
    AppDatabase db, {
    required String userId,
    required String deviceId,
  }) async {
    final max = db.changeLog.hlc.max();
    final last =
        await (db.selectOnly(db.changeLog)
              ..addColumns([max])
              ..where(db.changeLog.originDeviceId.equals(deviceId)))
            .map((r) => r.read(max))
            .getSingle();
    return ChangeWriter(
      db,
      userId: userId,
      deviceId: deviceId,
      clock: HlcClock(deviceId, last: last == null ? null : Hlc.parse(last)),
    );
  }

  final AppDatabase _db;
  final String userId;
  final String deviceId;
  final HlcClock _clock;

  /// Columns that describe the row itself rather than a field value; peers
  /// derive them from each op's own HLC and author.
  static const _notOps = {'id', 'hlc', 'updated_by'};

  /// Inserts a new row. [row] must set `id` and `spaceId`.
  Future<void> insert<T extends Table, D>(
    TableInfo<T, D> table,
    Insertable<D> row, {
    DateTime? now,
  }) {
    return _db.transaction(() async {
      final hlc = _clock.now().toString();
      final values = _sqlValues(row)
        ..putIfAbsent('created_at', () => _sql(now ?? DateTime.now().toUtc()))
        ..putIfAbsent('created_by', () => userId)
        ..['updated_by'] = userId
        ..['hlc'] = hlc;

      final id = values['id'];
      final spaceId = values['space_id'];
      if (id is! String || spaceId is! String) {
        throw ArgumentError('Inserted rows need an id and a spaceId.');
      }

      final columns = values.keys.toList();
      await _db.customInsert(
        'INSERT INTO ${table.actualTableName} (${columns.join(', ')}) '
        'VALUES (${List.filled(columns.length, '?').join(', ')})',
        variables: [for (final c in columns) _variable(values[c])],
        updates: {table},
      );
      await _recordOps(table, id, spaceId, values, hlc, userId);
    });
  }

  /// Updates the fields set in [changes] on row [rowId].
  Future<void> update<T extends Table, D>(
    TableInfo<T, D> table,
    String rowId,
    Insertable<D> changes,
  ) {
    return _db.transaction(() async {
      final hlc = _clock.now().toString();
      final values = _sqlValues(changes)
        ..remove('id')
        ..['updated_by'] = userId
        ..['hlc'] = hlc;

      final spaceId =
          values['space_id'] as String? ?? await _spaceIdOf(table, rowId);

      final columns = values.keys.toList();
      final updated = await _db.customUpdate(
        'UPDATE ${table.actualTableName} '
        'SET ${columns.map((c) => '$c = ?').join(', ')} WHERE id = ?',
        variables: [
          for (final c in columns) _variable(values[c]),
          Variable.withString(rowId),
        ],
        updates: {table},
        updateKind: UpdateKind.update,
      );
      if (updated != 1) {
        throw StateError('No ${table.actualTableName} row with id $rowId.');
      }
      await _recordOps(table, rowId, spaceId, values, hlc, userId);
    });
  }

  /// Records ops for a row that was written before the change log existed,
  /// using the row's own HLC and last author. The row itself is unchanged.
  Future<void> recordExisting<T extends Table, D>(
    TableInfo<T, D> table,
    Insertable<D> row,
  ) async {
    final values = _sqlValues(row);
    await _recordOps(
      table,
      values['id']! as String,
      values['space_id']! as String,
      values,
      values['hlc']! as String,
      values['updated_by']! as String,
    );
  }

  Future<void> _recordOps(
    TableInfo<Table, dynamic> table,
    String rowId,
    String spaceId,
    Map<String, Object?> values,
    String hlc,
    String author,
  ) async {
    await _db.batch((b) {
      b.insertAll(_db.changeLog, [
        for (final MapEntry(:key, :value) in values.entries)
          if (!_notOps.contains(key))
            ChangeLogCompanion.insert(
              opId: newId(),
              spaceId: spaceId,
              rowTable: table.actualTableName,
              rowId: rowId,
              columnName: key,
              value: jsonEncode(value),
              hlc: hlc,
              originDeviceId: deviceId,
              authorUserId: author,
              schemaVersion: _db.schemaVersion,
            ),
      ]);
    });
  }

  Future<String> _spaceIdOf(
    TableInfo<Table, dynamic> table,
    String rowId,
  ) async {
    final row = await _db
        .customSelect(
          'SELECT space_id FROM ${table.actualTableName} WHERE id = ?',
          variables: [Variable.withString(rowId)],
        )
        .getSingleOrNull();
    if (row == null) {
      throw StateError('No ${table.actualTableName} row with id $rowId.');
    }
    return row.read<String>('space_id');
  }

  /// Column name → plain SQL value (type converters and date encoding
  /// already applied), as stored in SQLite.
  Map<String, Object?> _sqlValues(Insertable<Object?> row) {
    return {
      for (final MapEntry(:key, :value) in row.toColumns(true).entries)
        key: switch (value) {
          Variable(:final value) => _sql(value),
          Constant(:final value) => _sql(value),
          _ => throw UnsupportedError(
            'Only plain values can be written through ChangeWriter '
            '($key was ${value.runtimeType}).',
          ),
        },
    };
  }

  Object? _sql(Object? dartValue) =>
      _db.typeMapping.mapToSqlVariable(dartValue);

  /// Column names in the SQL above come from generated table code, never
  /// from user input; values are always bound as parameters.
  Variable<Object> _variable(Object? sqlValue) => Variable<Object>(sqlValue);
}

import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/database.dart';
import 'change_writer.dart';
import 'fixups.dart';

/// One field change as it travels between devices (§7.1): a `change_log`
/// row.
class SyncOp {
  const SyncOp({
    required this.opId,
    required this.spaceId,
    required this.table,
    required this.rowId,
    required this.column,
    required this.value,
    required this.hlc,
    required this.originDeviceId,
    required this.authorUserId,
    required this.schemaVersion,
  });

  factory SyncOp.fromLog(ChangeOp o) => SyncOp(
    opId: o.opId,
    spaceId: o.spaceId,
    table: o.rowTable,
    rowId: o.rowId,
    column: o.columnName,
    value: o.value,
    hlc: o.hlc,
    originDeviceId: o.originDeviceId,
    authorUserId: o.authorUserId,
    schemaVersion: o.schemaVersion,
  );

  factory SyncOp.fromJson(Map<String, dynamic> j) => SyncOp(
    opId: j['o'] as String,
    spaceId: j['s'] as String,
    table: j['t'] as String,
    rowId: j['r'] as String,
    column: j['c'] as String,
    value: j['v'] as String,
    hlc: j['h'] as String,
    originDeviceId: j['d'] as String,
    authorUserId: j['a'] as String,
    schemaVersion: j['n'] as int,
  );

  final String opId;
  final String spaceId;
  final String table;
  final String rowId;
  final String column;

  /// JSON-encoded SQL value.
  final String value;
  final String hlc;
  final String originDeviceId;
  final String authorUserId;
  final int schemaVersion;

  Map<String, Object?> toJson() => {
    'o': opId,
    's': spaceId,
    't': table,
    'r': rowId,
    'c': column,
    'v': value,
    'h': hlc,
    'd': originDeviceId,
    'a': authorUserId,
    'n': schemaVersion,
  };
}

/// The highest HLC seen from each origin device (§7.3): what a device
/// already has, so a peer only sends what's missing.
typedef VersionVector = Map<String, String>;

/// What the fix-ups will need to look at once every batch is in.
class PendingFixups {
  final movedNodes = <String>{};
  final tables = <String>{};
}

/// What applying a batch did.
class ApplyResult {
  const ApplyResult({
    required this.received,
    required this.applied,
    required this.unknown,
  });

  /// Ops that were new to this device.
  final int received;

  /// Rows written.
  final int applied;

  /// Ops kept for a later version (§7.5).
  final int unknown;
}

/// Sync without the network (§7.3, §7.6 step 2): which ops a peer is
/// missing, and applying ops from a peer field by field (the highest HLC
/// wins). The connection, pairing and sessions sit on top.
class SyncEngine {
  SyncEngine(this._db, this._writer) : fixups = SyncFixups(_db, _writer);

  final AppDatabase _db;
  final ChangeWriter _writer;
  final SyncFixups fixups;

  /// Synced tables by SQL name, with their column names.
  late final Map<String, ({TableInfo<Table, dynamic> info, Set<String> cols})>
  _tables = {
    for (final t in _db.syncedTables)
      t.actualTableName: (info: t, cols: {for (final c in t.$columns) c.name}),
  };

  /// What this device has: the newest op from each origin.
  Future<VersionVector> vector() async {
    final rows = await _db
        .customSelect(
          'SELECT origin_device_id AS d, MAX(hlc) AS h FROM change_log '
          'GROUP BY origin_device_id',
          readsFrom: {_db.changeLog},
        )
        .get();
    return {for (final r in rows) r.read<String>('d'): r.read<String>('h')};
  }

  /// Ops a peer with [theirs] doesn't have, a page at a time (at most
  /// [maxOps] ops or about [maxBytes] of values per page), so a long
  /// history is never all in memory (§7.6, phones).
  Stream<List<SyncOp>> missingPages(
    VersionVector theirs, {
    int maxOps = 500,
    int maxBytes = 1024 * 1024,
  }) async* {
    final mine = await vector();
    for (final device in mine.keys) {
      final since = theirs[device];
      final until = mine[device]!;
      if (since != null && since.compareTo(until) >= 0) continue;
      // Keyset paging on (hlc, op id): each page starts after the last.
      String? lastHlc;
      String? lastOp;
      while (true) {
        final rows = await _db
            .customSelect(
              'SELECT * FROM change_log WHERE origin_device_id = ?1 '
              'AND (?2 IS NULL OR hlc > ?2) AND hlc <= ?3 '
              'AND (?4 IS NULL OR hlc > ?4 OR (hlc = ?4 AND op_id > ?5)) '
              'ORDER BY hlc, op_id LIMIT ?6',
              variables: [
                Variable.withString(device),
                Variable(since),
                Variable.withString(until),
                Variable(lastHlc),
                Variable(lastOp),
                Variable.withInt(maxOps),
              ],
              readsFrom: {_db.changeLog},
            )
            .asyncMap((r) => _db.changeLog.mapFromRow(r))
            .get();
        if (rows.isEmpty) break;
        var page = <SyncOp>[];
        var bytes = 0;
        for (final r in rows) {
          page.add(SyncOp.fromLog(r));
          bytes += r.value.length + 200;
          if (bytes >= maxBytes) {
            yield page;
            page = [];
            bytes = 0;
          }
        }
        if (page.isNotEmpty) yield page;
        if (rows.length < maxOps) break;
        lastHlc = rows.last.hlc;
        lastOp = rows.last.opId;
      }
    }
  }

  /// Ops this device has that a peer with [theirs] doesn't, oldest first.
  Future<List<SyncOp>> missingFor(VersionVector theirs) async {
    final mine = await vector();
    final out = <SyncOp>[];
    for (final device in mine.keys) {
      final since = theirs[device];
      if (since != null && since.compareTo(mine[device]!) >= 0) continue;
      final q = _db.select(_db.changeLog)
        ..where(
          (o) =>
              o.originDeviceId.equals(device) &
              (since == null
                  ? const Constant(true)
                  : o.hlc.isBiggerThanValue(since)),
        );
      out.addAll((await q.get()).map(SyncOp.fromLog));
    }
    out.sort((a, b) => a.hlc.compareTo(b.hlc));
    return out;
  }

  /// Stores [ops] from a peer and applies them: for every field they
  /// touch, the op with the highest HLC (here or received) wins. A row
  /// this device doesn't have is created from its ops. Ops for tables or
  /// columns this version doesn't know are kept and passed on (§7.5).
  /// Then the merge fix-ups run (§7.6).
  Future<ApplyResult> apply(List<SyncOp> ops) async {
    final pending = PendingFixups();
    final r = await applyBatch(ops, pending);
    await runFixups(pending);
    return r;
  }

  /// Runs the merge fix-ups for everything [pending] collected.
  Future<void> runFixups(PendingFixups pending) async {
    if (pending.tables.isEmpty) return;
    await fixups.run(movedNodes: pending.movedNodes, tables: pending.tables);
  }

  /// Like [apply], for one batch of many; the fix-ups wait until the last
  /// batch ([runFixups]), collected in [pending].
  Future<ApplyResult> applyBatch(
    List<SyncOp> ops,
    PendingFixups pending,
  ) async {
    if (ops.isEmpty) {
      return const ApplyResult(received: 0, applied: 0, unknown: 0);
    }
    var received = 0;
    var unknown = 0;
    final touched = <(String, String)>{};
    final parentMoves = <String>{};

    final applied = await _db.transaction(() async {
      for (final op in ops) {
        final inserted = await _db.customInsert(
          'INSERT OR IGNORE INTO change_log (op_id, space_id, table_name, '
          'row_id, column_name, value, hlc, origin_device_id, '
          'author_user_id, schema_version) '
          'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          variables: [
            Variable.withString(op.opId),
            Variable.withString(op.spaceId),
            Variable.withString(op.table),
            Variable.withString(op.rowId),
            Variable.withString(op.column),
            Variable.withString(op.value),
            Variable.withString(op.hlc),
            Variable.withString(op.originDeviceId),
            Variable.withString(op.authorUserId),
            Variable.withInt(op.schemaVersion),
          ],
        );
        if (inserted == 0) continue; // already had it
        received++;
        _writer.observe(op.hlc);
        final t = _tables[op.table];
        if (t == null || !t.cols.contains(op.column)) {
          unknown++;
          await _db
              .into(_db.pendingUnknownOps)
              .insert(
                PendingUnknownOpsCompanion.insert(opId: op.opId),
                mode: InsertMode.insertOrIgnore,
              );
          continue;
        }
        touched.add((op.table, op.rowId));
        if (op.table == 'nodes' && op.column == 'parent_id') {
          parentMoves.add(op.rowId);
        }
      }
      var n = 0;
      for (final (table, rowId) in touched) {
        if (await _materialise(table, rowId)) n++;
      }
      return n;
    });

    pending.movedNodes.addAll(parentMoves);
    pending.tables.addAll({for (final (t, _) in touched) t});
    return ApplyResult(received: received, applied: applied, unknown: unknown);
  }

  /// Applies ops kept by an older version whose table and column this
  /// version knows now (after an upgrade).
  Future<int> applyPending() async {
    final pending = await _db.select(_db.pendingUnknownOps).get();
    if (pending.isEmpty) return 0;
    final touched = <(String, String)>{};
    for (final p in pending) {
      final op = await (_db.select(
        _db.changeLog,
      )..where((o) => o.opId.equals(p.opId))).getSingleOrNull();
      if (op == null) continue;
      final t = _tables[op.rowTable];
      if (t == null || !t.cols.contains(op.columnName)) continue;
      touched.add((op.rowTable, op.rowId));
      await (_db.delete(
        _db.pendingUnknownOps,
      )..where((x) => x.opId.equals(p.opId))).go();
    }
    var n = 0;
    await _db.transaction(() async {
      for (final (table, rowId) in touched) {
        if (await _materialise(table, rowId)) n++;
      }
    });
    return n;
  }

  /// Writes the winning value of every known field of one row from the
  /// change log. Returns whether the row was written.
  Future<bool> _materialise(String table, String rowId) async {
    final t = _tables[table]!;
    final ops = await _db
        .customSelect(
          'SELECT column_name, value, hlc, author_user_id FROM change_log '
          'WHERE table_name = ? AND row_id = ? ORDER BY hlc',
          variables: [Variable.withString(table), Variable.withString(rowId)],
        )
        .get();
    final winners = <String, Object?>{};
    String? lastHlc;
    String? lastAuthor;
    for (final o in ops) {
      final col = o.read<String>('column_name');
      if (!t.cols.contains(col)) continue;
      winners[col] = jsonDecode(o.read<String>('value'));
      lastHlc = o.read<String>('hlc');
      lastAuthor = o.read<String>('author_user_id');
    }
    if (winners.isEmpty || lastHlc == null) return false;
    final values = {...winners, 'hlc': lastHlc, 'updated_by': lastAuthor ?? ''};

    final exists = await _db
        .customSelect(
          'SELECT 1 FROM $table WHERE id = ?',
          variables: [Variable.withString(rowId)],
        )
        .getSingleOrNull();
    final cols = values.keys.toList();
    if (exists != null) {
      await _db.customUpdate(
        'UPDATE $table SET ${cols.map((c) => '$c = ?').join(', ')} '
        'WHERE id = ?',
        variables: [
          for (final c in cols) Variable<Object>(values[c]),
          Variable.withString(rowId),
        ],
        updates: {t.info},
        updateKind: UpdateKind.update,
      );
      return true;
    }
    try {
      await _db.customInsert(
        'INSERT INTO $table (id, ${cols.join(', ')}) '
        'VALUES (?, ${List.filled(cols.length, '?').join(', ')})',
        variables: [
          Variable.withString(rowId),
          for (final c in cols) Variable<Object>(values[c]),
        ],
        updates: {t.info},
      );
      return true;
    } on Exception {
      // Not all of the row's required fields have arrived (an older
      // peer's partial history): it's made when they do.
      return false;
    }
  }
}

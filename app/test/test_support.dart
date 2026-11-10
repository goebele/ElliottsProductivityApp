import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/domain/node_repository.dart';
import 'package:elliotts_productivity_app/identity/identity_service.dart';
import 'package:elliotts_productivity_app/identity/secret_store.dart';
import 'package:elliotts_productivity_app/sync/change_writer.dart';

/// An in-memory database with a first-run identity, a writer and a repository.
class TestEnv {
  TestEnv._(this.db, this.identity, this.writer, this.nodes);

  final AppDatabase db;
  final LocalIdentity identity;
  final ChangeWriter writer;
  final NodeRepository nodes;

  static Future<TestEnv> create() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase(NativeDatabase.memory());
    final identity = await IdentityService(
      db,
      InMemorySecretStore(),
    ).ensureIdentity();
    final writer = await ChangeWriter.open(
      db,
      userId: identity.userId,
      deviceId: identity.deviceId,
    );
    final nodes = NodeRepository(
      db,
      writer,
      personalSpaceId: identity.personalSpaceId,
      userId: identity.userId,
    );
    return TestEnv._(db, identity, writer, nodes);
  }

  Future<List<ChangeOp>> opsFor(String rowId) =>
      (db.select(db.changeLog)..where((o) => o.rowId.equals(rowId))).get();

  Future<void> close() => db.close();
}

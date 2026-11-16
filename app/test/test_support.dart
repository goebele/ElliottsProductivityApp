import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:elliotts_productivity_app/data/blob_store.dart';
import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/domain/node_repository.dart';
import 'package:elliotts_productivity_app/identity/identity_service.dart';
import 'package:elliotts_productivity_app/identity/secret_store.dart';
import 'package:elliotts_productivity_app/sync/change_writer.dart';

/// An in-memory database with a first-run identity, a writer and a repository.
class TestEnv {
  TestEnv._(this.db, this.identity, this.writer, this.nodes, this.blobDir);

  final AppDatabase db;
  final LocalIdentity identity;
  final ChangeWriter writer;
  final NodeRepository nodes;

  /// A temporary blob store folder, deleted by [close].
  final Directory blobDir;

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
    final blobDir = Directory.systemTemp.createTempSync('epa_blobs_');
    final nodes = NodeRepository(
      db,
      writer,
      personalSpaceId: identity.personalSpaceId,
      userId: identity.userId,
      blobStore: BlobStore(blobDir),
    );
    return TestEnv._(db, identity, writer, nodes, blobDir);
  }

  Future<List<ChangeOp>> opsFor(String rowId) =>
      (db.select(db.changeLog)..where((o) => o.rowId.equals(rowId))).get();

  Future<void> close() async {
    await db.close();
    try {
      if (blobDir.existsSync()) blobDir.deleteSync(recursive: true);
    } on FileSystemException {
      // A file still open (an image being shown) on Windows; it's in temp.
    }
  }
}

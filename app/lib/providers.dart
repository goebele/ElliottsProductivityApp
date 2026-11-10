import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'data/blob_store.dart';
import 'data/database.dart';
import 'domain/node_repository.dart';
import 'identity/identity_service.dart';
import 'identity/secret_store.dart';
import 'sync/change_writer.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
});

final secretStoreProvider = Provider<SecretStore>(
  (ref) => const SecureSecretStore(),
);

/// Loads this install's identity, creating it on first run.
final identityProvider = FutureProvider<LocalIdentity>((ref) {
  return IdentityService(
    ref.watch(databaseProvider),
    ref.watch(secretStoreProvider),
  ).ensureIdentity();
});

/// The single write path for synced tables. One per app run, so the HLC
/// clock is shared by every write.
final changeWriterProvider = FutureProvider<ChangeWriter>((ref) async {
  final identity = await ref.watch(identityProvider.future);
  return ChangeWriter.open(
    ref.watch(databaseProvider),
    userId: identity.userId,
    deviceId: identity.deviceId,
  );
});

/// Attachment files, in `<app support>/blobs` (§6.4).
final blobStoreProvider = FutureProvider<BlobStore>((ref) async {
  final dir = await getApplicationSupportDirectory();
  return BlobStore(Directory(p.join(dir.path, 'blobs')));
});

final nodeRepositoryProvider = FutureProvider<NodeRepository>((ref) async {
  final identity = await ref.watch(identityProvider.future);
  final repo = NodeRepository(
    ref.watch(databaseProvider),
    await ref.watch(changeWriterProvider.future),
    personalSpaceId: identity.personalSpaceId,
    userId: identity.userId,
    blobStore: await ref.watch(blobStoreProvider.future),
  );
  // Trash older than 30 days is purged at startup (§6.11), then files
  // nothing uses any more are freed.
  unawaited(repo.purgeExpiredTrash().then((_) => repo.files.collectGarbage()));
  return repo;
});

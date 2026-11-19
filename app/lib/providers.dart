import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'data/blob_store.dart';
import 'data/database.dart';
import 'domain/node_repository.dart';
import 'identity/identity_service.dart';
import 'identity/secret_store.dart';
import 'sync/change_writer.dart';
import 'sync/discovery.dart';
import 'sync/sync_service.dart';

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

/// LAN sync (§7.6 step 5), started once the data is open; restarts when
/// the identity changes (after joining). Null when switched off (tests).
final syncServiceProvider = FutureProvider<SyncService?>((ref) async {
  if (!SyncService.enabled) return null;
  final db = ref.watch(databaseProvider);
  final secrets = ref.watch(secretStoreProvider);
  final identity = await ref.watch(identityProvider.future);
  final service = SyncService(
    db: db,
    writer: await ref.watch(changeWriterProvider.future),
    identity: IdentityService(db, secrets),
    secrets: secrets,
    blobStore: await ref.watch(blobStoreProvider.future),
    deviceId: identity.deviceId,
    userId: identity.userId,
    userPublicKey: identity.userPublicKey,
    personalSpaceId: identity.personalSpaceId,
    backupDir: Directory(
      p.join((await getApplicationSupportDirectory()).path, 'backups'),
    ),
  );
  ref.onDispose(service.stop);
  await service.start();
  return service;
});

final syncStatusProvider = StreamProvider<SyncStatus?>((ref) async* {
  final service = await ref.watch(syncServiceProvider.future);
  if (service == null) {
    yield null;
    return;
  }
  yield service.status;
  yield* service.statusChanges;
});

final nearbyDevicesProvider = StreamProvider<List<NearbyDevice>>((ref) async* {
  final service = await ref.watch(syncServiceProvider.future);
  if (service == null) {
    yield const [];
    return;
  }
  yield service.nearby;
  yield* service.nearbyChanges;
});

/// Your devices this one knows (local-only, §5.4), this one first.
final knownDevicesProvider = StreamProvider<List<Device>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.devices)..orderBy([
        (d) => OrderingTerm.desc(d.isThisDevice),
        (d) => OrderingTerm.desc(d.lastSyncAt),
      ]))
      .watch();
});

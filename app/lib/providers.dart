import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final nodeRepositoryProvider = FutureProvider<NodeRepository>((ref) async {
  final identity = await ref.watch(identityProvider.future);
  final repo = NodeRepository(
    ref.watch(databaseProvider),
    await ref.watch(changeWriterProvider.future),
    personalSpaceId: identity.personalSpaceId,
    userId: identity.userId,
  );
  // Trash older than 30 days is purged at startup (§6.11).
  unawaited(repo.purgeExpiredTrash());
  return repo;
});

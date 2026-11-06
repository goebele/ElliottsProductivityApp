import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database.dart';
import 'identity/identity_service.dart';
import 'identity/secret_store.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
});

final secretStoreProvider =
    Provider<SecretStore>((ref) => const SecureSecretStore());

/// Loads this install's identity, creating it on first run.
final identityProvider = FutureProvider<LocalIdentity>((ref) {
  return IdentityService(
    ref.watch(databaseProvider),
    ref.watch(secretStoreProvider),
  ).ensureIdentity();
});

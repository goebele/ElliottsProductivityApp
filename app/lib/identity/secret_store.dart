import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where private keys live (§5.4 `local_secrets`): OS secure storage, never
/// the SQLite database.
abstract interface class SecretStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

/// Android Keystore / Windows Credential Locker via flutter_secure_storage.
class SecureSecretStore implements SecretStore {
  const SecureSecretStore([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
}

/// For tests.
class InMemorySecretStore implements SecretStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

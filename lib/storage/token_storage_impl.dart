import 'package:attend/storage/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageImpl implements TokenStorage {
  final FlutterSecureStorage flutterSecureStorage;

  TokenStorageImpl(this.flutterSecureStorage);

  static const _key =
      'auth_token'; //_key is simply the identifier used to store and retrieve the token in secure storage. Think of secure storage like a key-value database:

  @override
  Future<void> saveToken(String token) async {
    await flutterSecureStorage.write(key: _key, value: token);
  }

  @override
  Future<String?> getToken() async {
    return flutterSecureStorage.read(key: _key);
  }

  @override
  Future<void> clearToken() async {
    await flutterSecureStorage.delete(key: _key);
  }
}

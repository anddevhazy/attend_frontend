import 'package:attend/global/storage/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageImpl implements TokenStorage {
  final FlutterSecureStorage flutterSecureStorage;

  TokenStorageImpl(this.flutterSecureStorage);

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  @override
  Future<void> saveAccessToken(String token) async {
    await flutterSecureStorage.write(key: _accessKey, value: token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await flutterSecureStorage.write(key: _refreshKey, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    return flutterSecureStorage.read(key: _accessKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return flutterSecureStorage.read(key: _refreshKey);
  }

  @override
  Future<void> clearTokens() async {
    await flutterSecureStorage.delete(key: _accessKey);
    await flutterSecureStorage.delete(key: _refreshKey);
  }
}

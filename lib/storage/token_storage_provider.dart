import 'package:attend/global/constants/api_config_const.dart';

import 'secure_storage_provider.dart';

abstract class TokenStorageProvider {
  Future<void> saveTokens({required String accessToken, String? refreshToken});

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> clearTokens();
}

class TokenStorageProviderImpl implements TokenStorageProvider {
  final SecureStorageProvider _secureStorage;

  TokenStorageProviderImpl(this._secureStorage);

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _secureStorage.write(ApiConfigConst.accessTokenKey, accessToken);

    if (refreshToken != null) {
      await _secureStorage.write(ApiConfigConst.refreshTokenKey, refreshToken);
    }
  }

  @override
  Future<String?> getAccessToken() {
    return _secureStorage.read(ApiConfigConst.accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() {
    return _secureStorage.read(ApiConfigConst.refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await _secureStorage.delete(ApiConfigConst.accessTokenKey);
    await _secureStorage.delete(ApiConfigConst.refreshTokenKey);
  }
}

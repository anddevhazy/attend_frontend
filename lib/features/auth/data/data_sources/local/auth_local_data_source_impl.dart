import 'package:attend/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:attend/global/storage/token_storage.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final TokenStorage tokenStorage;

  AuthLocalDataSourceImpl({required this.tokenStorage});

  @override
  Future<void> saveAccessToken(String token) {
    return tokenStorage.saveAccessToken(token);
  }

  @override
  Future<void> saveRefreshToken(String token) {
    return tokenStorage.saveRefreshToken(token);
  }

  @override
  Future<String?> getAccessToken() {
    return tokenStorage.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() {
    return tokenStorage.getRefreshToken();
  }

  @override
  Future<void> logout() {
    return tokenStorage.clearTokens();
  }
}

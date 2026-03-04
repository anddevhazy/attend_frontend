import 'package:attend/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:attend/storage/token_storage.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final TokenStorage tokenStorage;

  AuthLocalDataSourceImpl(this.tokenStorage);

  @override
  Future<void> saveToken(String token) {
    return tokenStorage.saveToken(token);
  }

  @override
  Future<String?> getToken() {
    return tokenStorage.getToken();
  }

  @override
  Future<void> logout() {
    return tokenStorage.clearToken();
  }
}

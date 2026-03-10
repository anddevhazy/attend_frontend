import 'package:attend/global/core/config/flavor_config.dart';
import 'package:attend/global/core/network/api_endpoints.dart';
import 'package:attend/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:dio/dio.dart';

class RefreshTokenInterceptor extends Interceptor {
  final AuthLocalDataSource localDataSource;

  late Dio dio;

  final Dio refreshClient = Dio();

  bool _isRefreshing = false;

  RefreshTokenInterceptor(this.localDataSource) {
    refreshClient.options.baseUrl = FlavorConfig.instance.baseApiUrl;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    if (statusCode != 401) {
      return handler.next(err);
    }

    // Prevent infinite loop
    if (err.requestOptions.path.contains('refresh-token')) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;

    try {
      final refreshToken = await localDataSource.getRefreshToken();

      if (refreshToken == null) {
        await localDataSource.logout();
        return handler.next(err);
      }

      final response = await refreshClient.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final newAccess = response.data['accessToken'];
      final newRefresh = response.data['refreshToken'];

      await localDataSource.saveAccessToken(newAccess);
      await localDataSource.saveRefreshToken(newRefresh);

      // Update header
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccess';

      // Retry original request
      final cloneResponse = await dio.fetch(err.requestOptions);

      return handler.resolve(cloneResponse);
    } catch (_) {
      await localDataSource.logout();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }
}

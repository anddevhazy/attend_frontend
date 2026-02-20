import 'package:attend/core/utils/app_logger.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();
}

class LoggingInterceptor extends Interceptor {
  final AppLogger logger;

  LoggingInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d(
      'REQUEST[${options.method}] => PATH: ${options.uri} | DATA: ${options.data}',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.uri}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.uri} | MESSAGE: ${err.message}',
      error: err.error,
      stackTrace: err.stackTrace,
    );
    super.onError(err, handler);
  }
}

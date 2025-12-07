import 'package:dio/dio.dart';
import '../config/flavor_config.dart';
import '../error/error_messages.dart';
import 'api_exceptions.dart';
import 'network_info.dart';

class ApiClient {
  final Dio _dio;
  final NetworkInfo _networkInfo;

  ApiClient(this._dio, this._networkInfo) {
    _dio.options
      ..baseUrl = FlavorConfig.instance.baseApiUrl
      ..connectTimeout = const Duration(seconds: 20)
      ..receiveTimeout = const Duration(seconds: 20)
      ..responseType = ResponseType.json;
  }

  Future<Response<T>> getRequest<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _ensureConnected();
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Response<T>> postRequest<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _ensureConnected();
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Response<T>> putRequest<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _ensureConnected();
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Response<T>> deleteRequest<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _ensureConnected();
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<void> _ensureConnected() async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException(message: ErrorMessages.network);
    }
  }

  ApiException _mapDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutException();

      case DioExceptionType.badResponse:
        if (statusCode == 401) {
          return UnauthorizedException(
            message: _extractMessage(data) ?? ErrorMessages.unauthorized,
          );
        }
        if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: _extractMessage(data) ?? ErrorMessages.server,
            statusCode: statusCode,
          );
        }
        return BadRequestException(
          message: _extractMessage(data) ?? ErrorMessages.badRequest,
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
        return ApiException(
          message: _extractMessage(data) ?? ErrorMessages.unexpected,
          statusCode: statusCode,
          data: data,
        );
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['message'] is String) return data['message'] as String;
      if (data['error'] is String) return data['error'] as String;
    }
    return null;
  }
}

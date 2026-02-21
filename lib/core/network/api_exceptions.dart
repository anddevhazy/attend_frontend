class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message, data: $data)';
}

class NetworkException extends ApiException {
  NetworkException({required super.message});
}

class TimeoutException extends ApiException {
  TimeoutException({required super.message});
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({required super.message, required super.statusCode});
}

class ServerException extends ApiException {
  ServerException({required super.message, required super.statusCode});
}

class BadRequestException extends ApiException {
  BadRequestException({required super.message, required super.statusCode});
}

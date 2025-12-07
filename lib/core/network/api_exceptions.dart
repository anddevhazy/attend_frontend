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
  NetworkException({super.message = 'No internet connection'});
}

class TimeoutException extends ApiException {
  TimeoutException({super.message = 'Request timeout'});
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({super.message = 'Unauthorized'})
    : super(statusCode: 401);
}

class ServerException extends ApiException {
  ServerException({super.message = 'Server error', super.statusCode});
}

class BadRequestException extends ApiException {
  BadRequestException({super.message = 'Bad request', super.statusCode});
}

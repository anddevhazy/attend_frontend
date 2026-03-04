import 'dart:developer' as developer;

abstract class AppLogger {
  void d(String message, {Object? error, StackTrace? stackTrace});
  void e(String message, {Object? error, StackTrace? stackTrace});
}

class AppLoggerImpl implements AppLogger {
  @override
  void d(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'DEBUG', error: error, stackTrace: stackTrace);
  }

  @override
  void e(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'ERROR', error: error, stackTrace: stackTrace);
  }
}

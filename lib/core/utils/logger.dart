import 'dart:developer' as developer;

abstract class Logger {
  void d(String message, {Object? error, StackTrace? stackTrace});
  void e(String message, {Object? error, StackTrace? stackTrace});
}

class AppLogger implements Logger {
  @override
  void d(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'DEBUG', error: error, stackTrace: stackTrace);
  }

  @override
  void e(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'ERROR', error: error, stackTrace: stackTrace);
  }
}

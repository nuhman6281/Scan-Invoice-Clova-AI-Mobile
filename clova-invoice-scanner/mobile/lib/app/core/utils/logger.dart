import 'dart:developer' as developer;

class Logger {
  static void info(String message) {
    developer.log(message, name: 'INFO');
  }
  
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    developer.log(message, name: 'ERROR', error: error, stackTrace: stackTrace);
  }
  
  static void debug(String message) {
    developer.log(message, name: 'DEBUG');
  }
} 
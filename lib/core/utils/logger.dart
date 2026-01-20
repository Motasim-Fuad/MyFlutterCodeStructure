import 'package:logger/logger.dart';

// APP LOGGER

// WHY: Structured logging for better debugging
// - Colored console output
// - Log levels (debug, info, warning, error)
// - Stack trace for errors
// - Easy to disable in production

class AppLogger {
  //  LOGGER INSTANCE
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to show
      errorMethodCount: 8, // Number of method calls for errors
      lineLength: 120, // Width of the output
      colors: true, // Colorful output
      printEmojis: true, // Emoji for log levels 🐛 💡 ⚠️ ⛔
      printTime: true, // Include timestamp
    ),
  );

  //  DEBUG LOG
  // WHY: Development debugging information
  // Use for: Variable values, flow tracking
  // Example: AppLogger.debug('User ID: $userId');
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  // INFO LOG
  // WHY: General information messages
  // Use for: API calls, user actions, state changes
  // Example: AppLogger.info('User logged in successfully');
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  // WARNING LOG
  // WHY: Potentially problematic situations
  // Use for: Deprecated features, validation issues
  // Example: AppLogger.warning('Cache is 90% full');
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  // ERROR LOG
  // WHY: Error conditions that need attention
  // Use for: API failures, caught exceptions
  // Example: AppLogger.error('Login failed', error, stackTrace);
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  //  VERBOSE LOG
  // WHY: Very detailed information (noisy)
  // Use sparingly: Deep debugging only
  static void verbose(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  //  API LOG
  // WHY: Dedicated API request/response logging
  static void api(String endpoint, {
    String? method,
    dynamic request,
    dynamic response,
    int? statusCode,
  }) {
    final buffer = StringBuffer();
    buffer.writeln(' API CALL');
    if (method != null) buffer.writeln('Method: $method');
    buffer.writeln('Endpoint: $endpoint');
    if (request != null) buffer.writeln('Request: $request');
    if (statusCode != null) buffer.writeln('Status: $statusCode');
    if (response != null) buffer.writeln('Response: $response');

    info(buffer.toString());
  }
}
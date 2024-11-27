import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Logger {
  static const String debugTag = 'Logger';
  static void log(String message,
      {String tag = "Logger", String level = "INFO"}) {
    String formattedMessage = _formatMessage(tag, message, level);
    if (kDebugMode) {
      print(formattedMessage);
    }
  }

  // Specific log levels
  static void logDebug(String message, {String tag = debugTag}) {
    log(message, tag: tag, level: "DEBUG");
  }

  static void logInfo(String message, {String tag = debugTag}) {
    log(message, tag: tag, level: "INFO");
  }

  static void logWarning(String message, {String tag = debugTag}) {
    log(message, tag: tag, level: "WARNING");
  }

  static void logError(String message, {String tag = debugTag}) {
    log(message, tag: tag, level: "ERROR");
  }

  // Helper method to format the message
  static String _formatMessage(String tag, String message, String level) {
    String timeStamp = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    return "[$debugTag | $timeStamp] [$level] [$tag] $message";
  }
}

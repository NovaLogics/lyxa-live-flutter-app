import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class LoggerLevels {
  static const String levelInfo = 'INFO';
  static const String levelDebug = 'DEBUG';
  static const String levelWarning = 'WARNING';
  static const String levelError = 'ERROR';
}

class Logger {
  static const String _debugTag = 'Logger';
  static const String _dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';

  static void log(
    String message, {
    String tag = _debugTag,
    String level = LoggerLevels.levelInfo,
  }) {
    String formattedMessage = _formatMessage(tag, message, level);
    if (kDebugMode) {
      print(formattedMessage);
    }
  }

  static void logDebug(String message, {String tag = _debugTag}) {
    log(message, tag: tag, level: LoggerLevels.levelDebug);
  }

  static void logInfo(String message, {String tag = _debugTag}) {
    log(message, tag: tag, level: LoggerLevels.levelInfo);
  }

  static void logWarning(String message, {String tag = _debugTag}) {
    log(message, tag: tag, level: LoggerLevels.levelWarning);
  }

  static void logError(String message, {String tag = _debugTag}) {
    log(message, tag: tag, level: LoggerLevels.levelError);
  }

  static String _formatMessage(
    String tag,
    String message,
    String level,
  ) {
    String timeStamp = DateFormat(_dateTimeFormat).format(DateTime.now());
    return '[$_debugTag | $timeStamp] [$level] [$tag] $message';
  }
}

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Logger {
  static const String debugTag = 'Logger';
  static const String levelInfo = 'INFO';
  static const String levelDebug = 'DEBUG';
  static const String levelWarning = 'WARNING';
  static const String levelError = 'ERROR';
  static const String _dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';

  static void log(
    String message, {
    String tag = debugTag,
    String level = levelInfo,
  }) {
    String formattedMessage = _formatMessage(tag, message, level);
    if (kDebugMode) {
      print(formattedMessage);
    }
  }

  static void logDebug(String message, {String tag = debugTag}) {
    log(message, tag: tag, level: levelDebug);
  }

  static void logInfo(String message, {String tag = debugTag}) {
    log(message, tag: tag, level: levelInfo);
  }

  static void logWarning(String message, {String tag = debugTag}) {
    log(message, tag: tag, level: levelWarning);
  }

  static void logError(String message, {String tag = debugTag}) {
    log(message, tag: tag, level: levelError);
  }

  static String _formatMessage(
    String tag,
    String message,
    String level,
  ) {
    String timeStamp = DateFormat(_dateTimeFormat).format(DateTime.now());
    return '[$debugTag | $timeStamp] [$level] [$tag] $message';
  }
}

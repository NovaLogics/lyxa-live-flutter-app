import 'package:intl/intl.dart';

class DateTimeStyles {
  // Full date-time format: "2024-11-17 14:30:00"
  static const String fullDateTime = 'yyyy-MM-dd HH:mm:ss';

  // Short date format: "2024-11-17"
  static const String shortDate = 'yyyy-MM-dd';

  // Time format: "14:30:00"
  static const String time = 'HH:mm:ss';

  // Date with day name: "Sunday, 2024-11-17"
  static const String dayNameWithDate = 'EEEE, yyyy-MM-dd';

  // Month and year format: "November 2024"
  static const String monthYear = 'MMMM yyyy';

  // Custom format for short readable time: "Nov 17, 2024, 1:30 am"
  static const String customShortDate = 'MMM dd, yyyy, hh:mm a';
}

class DateTimeUtil {
  // Default DateFormat instance
  static final DateFormat _defaultFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  /// Convert DateTime to a formatted string
  static String formatDate(DateTime dateTime,
      {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    try {
      final DateFormat customFormat = DateFormat(format);
      return customFormat.format(dateTime);
    } catch (e) {
      // Return default format if there's an error in the custom format
      return _defaultFormat.format(dateTime);
    }
  }

  /// Convert a string to DateTime using a specific format
  static DateTime parseDate(String dateString,
      {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    try {
      final DateFormat customFormat = DateFormat(format);
      return customFormat.parse(dateString);
    } catch (e) {
      // Return current time if the string can't be parsed
      return DateTime.now();
    }
  }

  /// Get current date-time in custom format
  static String getCurrentDateTime({String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return formatDate(DateTime.now(), format: format);
  }

  /// Get a readable time difference (e.g., "2 hours ago")
  static String timeAgo(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inDays > 7) {
      return DateFormat('yyyy-MM-dd')
          .format(dateTime); // If older than 7 days, return the date.
    } else if (diff.inDays >= 1) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return '${diff.inSeconds} second${diff.inSeconds > 1 ? 's' : ''} ago';
    }
  }

  static String datetimeAgo(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);

    // Check for years
    if (diff.inDays >= 365) {
      final int years = (diff.inDays / 365).floor();
      return '${years} year${years > 1 ? 's' : ''} ago';
    }
    // Check for weeks (more than 7 days but less than a year)
    else if (diff.inDays > 7) {
      return DateFormat('yyyy-MM-dd')
          .format(dateTime); // If older than 7 days, return the date.
    }
    // Check for days
    else if (diff.inDays >= 1) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    }
    // Check for hours
    else if (diff.inHours >= 1) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    }
    // Check for minutes
    else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    }
    // Check for seconds
    else {
      return '${diff.inSeconds} second${diff.inSeconds > 1 ? 's' : ''} ago';
    }
  }
}

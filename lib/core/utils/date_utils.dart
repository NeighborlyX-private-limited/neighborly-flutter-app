import 'package:intl/intl.dart';

String convertToIndianTime(String utcTime) {
  // Parse the UTC time
  DateTime utcDateTime = DateTime.parse(utcTime);

  // Convert to IST (Indian Standard Time)
  DateTime istDateTime = utcDateTime.add(Duration(hours: 5, minutes: 30));

  // Format the IST time
  String formattedTime = DateFormat('hh:mm a').format(istDateTime);

  return formattedTime;
}

class DateUtilsHelper {
  // Formats time as 02:00 AM, 05:00 PM
  String formatIndianTime(String isoTimestamp) {
    if (isoTimestamp.isEmpty) return '';
    DateTime inputTime = DateTime.parse(isoTimestamp)
        .toUtc()
        .add(Duration(hours: 5, minutes: 30));
    return DateFormat('hh:mm a').format(inputTime);
  }

  static String simplifyISOtimeString(String date) {
    try {
      DateTime dateTimeStart = DateTime.parse(date);
      String formattedDate = DateFormat('MMMM d, yyyy').format(dateTimeStart);
      return formattedDate;
    } catch (e) {
      return '$e';
    }
  }

  static String simplifyISOtimeStringOnlyHour(String date) {
    try {
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final DateFormat timeFormat = DateFormat('hh:mm a');
      DateTime dateTime = dateFormat.parse(date);
      return timeFormat.format(dateTime);
    } catch (e) {
      return '';
    }
  }
}

String getTimeAgo(String utcTime) {
  DateTime postTime = DateTime.parse(utcTime).toLocal();

  final now = DateTime.now();
  final difference = now.difference(postTime);

  if (difference.inSeconds < 60) {
    return "Just now";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} min ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
  } else if (difference.inDays == 1) {
    return "Yesterday";
  } else if (difference.inDays < 7) {
    return DateFormat('EEEE').format(postTime);
  } else if (difference.inDays < 30) {
    return "${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago";
  } else if (difference.inDays < 365) {
    return "${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago";
  } else {
    return DateFormat('dd MMM yyyy').format(postTime);
  }
}

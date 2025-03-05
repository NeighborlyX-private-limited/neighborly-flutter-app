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
    print('date: $date');
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

import 'package:intl/intl.dart';

class DateUtilsHelper {
  static DateTime dateFormatter(String date) =>
      DateFormat('dd/MM/yyyy HH:mm').parse(date);

  static DateTime dateFormatterJustDate(String date) =>
      DateFormat('dd/MM/yyyy').parse(date);

  static String simplifyISOtimeStringStartEnd(
      String dateStart, String dateEnd) {
    DateTime dateTimeStart = DateTime.parse(dateStart);
    DateTime dateTimeEnd = DateTime.parse(dateEnd);

    // Formata a data no formato desejado (dd/MM)
    String formattedDateStart = DateFormat('dd/MM').format(dateTimeStart);
    String formattedDateEnd = DateFormat('dd/MM').format(dateTimeEnd);

    return '$formattedDateStart - $formattedDateEnd';
  }

  static String simplifyISOtimeString(String date) {
    try {
      DateTime dateTimeStart = DateTime.parse(date);

      // Formata a data no formato desejado (dd/MM)
      String formattedDate = DateFormat('MMMM d, yyyy').format(dateTimeStart);

      return formattedDate;
    } catch (e) {
      print('simplifyISOtimeString ERROR: $e [data: $date]');
      return '';
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

  static DateTime? tryFormatDate(String? date) {
    try {
      if (date != null) {
        return dateFormatter(date);
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  static String? dbFormatToDate(String? dateString, [String separator = '/']) {
    if (dateString == null || dateString == '') return null;

    try {
      DateTime dateTime = DateTime.parse(dateString);
      DateFormat formatter = DateFormat('dd/MM/yy'); // Format for "Jun/24"
      String formattedDate =
          formatter.format(dateTime).replaceAll('/', separator);

      return formattedDate;
    } catch (_) {
      return null;
    }
  }

  static String? dbFormatToMonthYear(String? dateString) {
    if (dateString == null || dateString == '') return null;

    try {
      DateTime dateTime = DateTime.parse(dateString);
      DateFormat formatter = DateFormat('MMM-yy'); // Format for "Jun/24"
      String formattedDate = formatter.format(dateTime);

      return formattedDate.replaceAll('-', '');
    } catch (_) {
      return null;
    }
  }

  // static String getVerboseDesc(DateTime date, DateFormat fallbackFormat) {
  //   if (isToday(date)) {
  //     return CoreStrings.dates.today;
  //   } else if (isYesterday(date)) {
  //     return CoreStrings.dates.yesterday;
  //   } else {
  //     return fallbackFormat.format(date);
  //   }
  // }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    if (now.day == date.day &&
        now.month == date.month &&
        now.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    if (yesterday.day == date.day &&
        yesterday.month == date.month &&
        yesterday.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  static List<DateTime> lastMonths({int monthsToReturn = 12, DateTime? since}) {
    final months = <DateTime>[];
    months.add(since ?? DateTime.now());

    while (months.length < monthsToReturn) {
      final lastDate = months.last;
      months.add(DateTime(lastDate.year, lastDate.month - 1));
    }
    return months;
  }

  static List<DateTime> nextMonths({int monthsToReturn = 12, DateTime? since}) {
    final months = <DateTime>[];
    months.add(since ?? DateTime.now());
    while (months.length < monthsToReturn) {
      final lastDate = months.last;
      months.add(DateTime(lastDate.year, lastDate.month + 1));
    }
    return months;
  }

  static bool isPast(DateTime date) {
    final now = DateTime.now();
    final pastDaysDifference = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (pastDaysDifference >= 0) {
      return false;
    } else {
      return true;
    }
  }

  static int extractYearFromIsodateString(String dateString) {
    final DateFormat dateFormat = DateFormat('yyyy');
    final DateTime parsedDate = dateFormat.parse(dateString);
    print('extractYearFromIsodateString=${parsedDate.year}');
    return parsedDate.year;
  }
}

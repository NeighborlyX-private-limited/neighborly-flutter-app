import 'package:intl/intl.dart';

String formatTimeDifference(String isoTimestamp) {
  DateTime inputTime = DateTime.parse(isoTimestamp);
  DateTime now = DateTime.now();
  Duration difference = now.difference(inputTime);

  if (difference.inDays > 3) {
    return '${inputTime.year}-${inputTime.month.toString().padLeft(2, '0')}-${inputTime.day.toString().padLeft(2, '0')}';
  } else if (difference.inDays >= 1) {
    return '${difference.inDays}d';
  } else if (difference.inHours >= 1) {
    if (difference.inHours == 1) {
      return '${difference.inHours}hr';
    }
    return '${difference.inHours}hrs';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes}m';
  } else {
    return 'Just now';
  }
}

String convertDateString(String dateString) {
  // Parse the input string into a DateTime object
  DateTime dateTime = DateTime.parse(dateString);

  // Define a DateFormat for the desired output
  DateFormat formatter = DateFormat('MMM dd, HH:mm a');

  // Convert the DateTime object to the desired string format
  String formattedDate =
      formatter.format(dateTime.toLocal()); // Ensure local time

  return formattedDate;
}

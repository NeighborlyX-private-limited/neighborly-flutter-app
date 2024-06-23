import 'package:intl/intl.dart';

String formatTimeDifference(String isoTimestamp) {
  DateTime inputTime = DateTime.parse(isoTimestamp);
  DateTime now = DateTime.now();
  Duration difference = now.difference(inputTime);

  if (difference.inDays > 10) {
    return '${inputTime.day.toString().padLeft(2, '0')}-${inputTime.month.toString().padLeft(2, '0')}-${inputTime.year}';
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

String timeAgo(String dateString) {
  // Parse the input string into a DateTime object
  DateTime dateTime = DateTime.parse(dateString).toLocal();

  // Get the current time
  DateTime now = DateTime.now();

  // Calculate the difference between the current time and the input time
  Duration difference = now.difference(dateTime);

  // Define the output string
  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 30) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 365) {
    int months = (difference.inDays / 30).floor();
    return '$months months ago';
  } else {
    int years = (difference.inDays / 365).floor();
    return '$years years ago';
  }
}

bool isValidEmail(String email) {
  // Define the regular expression for a valid email address.
  String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // Create a RegExp object with the pattern.
  RegExp regExp = RegExp(emailPattern);

  // Return whether the email matches the pattern.
  return regExp.hasMatch(email);
}

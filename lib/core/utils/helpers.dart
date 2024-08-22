import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

import '../entities/option_entity.dart';

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
    if (difference.inSeconds == 1) {
      return '${difference.inSeconds} second ago';
    }
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    if (difference.inMinutes == 1) {
      return '${difference.inMinutes} minute ago';
    }
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    if (difference.inHours == 1) {
      return '${difference.inHours} hour ago';
    }
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 30) {
    if (difference.inDays == 1) {
      return '${difference.inDays} day ago';
    }
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

double calculatePercentage(double value, double total) {
  if (total == 0) {
    return 0; // Avoid division by zero
  }
  double percentage = (value / total) * 100;
  return double.parse(percentage.toStringAsFixed(1));
}

Future<String> getAddressFromLatLng(List<double> position) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position[0], position[1]);
    Placemark place = placemarks[0];

    // Check for non-null and non-empty subLocality
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      return place.subLocality!;
    } else {
      return '';
    }
  } catch (e) {
    // Handle the error here
    print('Error: $e');
    return 'Error occurred: $e';
  }
}

double calculateTotalVotes(List<OptionEntity> options) {
  double totalVotes = 0;

  for (var option in options) {
    // Parse the votes as an integer and add to the total sum.
    totalVotes += double.parse(option.votes.toString());
  }

  return totalVotes;
}

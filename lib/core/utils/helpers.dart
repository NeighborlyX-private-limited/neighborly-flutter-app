import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

import '../entities/option_entity.dart';

/// format Time Difference
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

///convert Date String
String convertDateString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);

  DateFormat formatter = DateFormat('MMM dd, HH:mm a');

  String formattedDate = formatter.format(dateTime.toLocal());

  return formattedDate;
}

///time Ago
String timeAgo(String dateString) {
  DateTime dateTime = DateTime.parse(dateString).toLocal();
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);
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

///isValidPhoneNumber
bool isValidPhoneNumber(String phoneNumber) {
  final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
  return phoneRegex.hasMatch(phoneNumber);
}

///isValidEmail
bool isValidEmail(String email) {
  String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regExp = RegExp(emailPattern);
  return regExp.hasMatch(email);
}

////calculatePercentage
double calculatePercentage(double value, double total) {
  if (total == 0) {
    return 0;
  }
  double percentage = (value / total) * 100;
  return double.parse(percentage.toStringAsFixed(1));
}

///getAddressFromLatLng
Future<String> getAddressFromLatLng(List<double> position) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position[0], position[1]);
    Placemark place = placemarks[0];

    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      return place.subLocality!;
    } else {
      return '';
    }
  } catch (e) {
    return 'Error occurred: $e';
  }
}

///calculateTotalVotes
double calculateTotalVotes(List<OptionEntity> options) {
  double totalVotes = 0;

  for (var option in options) {
    totalVotes += double.parse(option.votes.toString());
  }

  return totalVotes;
}

Color parseColor(String hexColor) {
  // Remove '#' if present
  hexColor = hexColor.replaceAll('#', '');

  // Add '0xFF' for full opacity
  return Color(int.parse('0xFF$hexColor'));
}

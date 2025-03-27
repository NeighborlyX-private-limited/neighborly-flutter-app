import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../entities/option_entity.dart';

void saveSearch(String query) async {
  final box = Hive.box<String>('search_history');

  // Retrieve existing history
  List<String> history = box.values.toList();
  print('Before saving: $history');

  // Remove duplicate entry
  history.remove(query);

  // Insert at the start
  history.insert(0, query);

  // Keep only the last 6 searches
  if (history.length > 6) {
    history = history.sublist(0, 6);
  }

  print('After saving: $history');

  // Update Hive storage correctly
  await box.clear(); // Ensure the box is empty before adding new values
  for (String item in history) {
    await box.add(item); // Add one by one to avoid issues
  }

  // Verify saved history
  List<String> newHistory = box.values.toList();
  print('Final saved history: $newHistory');
}

Future<void> removeSearch(String query) async {
  final box = Hive.box<String>('search_history');
  List<String> history = box.values.toList();
  print('search histroy: $history');

  // Remove the specific search term
  history.remove(query);
  print('search histroy after: $history');

  // Clear the box and update with the modified history list
  await box.clear();
  print('search histroy afterclear: $history');
  for (String item in history) {
    await box.add(item); // Add one by one to avoid issues
  }
  // box.addAll(history);
  final newbox = Hive.box<String>('search_history');
  List<String> newhistory = newbox.values.toList();
  print('search histroy after new: $newhistory');
}

// AGO TIME
String formatTimeDifference(String isoTimestamp) {
  if (isoTimestamp == '') return '';
  DateTime inputTime = DateTime.parse(isoTimestamp);
  DateTime now = DateTime.now();
  Duration difference = now.difference(inputTime);

  if (difference.inDays > 10) {
    return '${inputTime.day.toString().padLeft(2, '0')}-${inputTime.month.toString().padLeft(2, '0')}-${inputTime.year}';
  } else if (difference.inDays >= 1) {
    return '${difference.inDays} day ago';
  } else if (difference.inHours >= 1) {
    if (difference.inHours == 1) {
      return '${difference.inHours} hour ago';
    }
    return '${difference.inHours} hours ago';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} mins ago';
  } else {
    return 'Just now';
  }
}

/// convert Date String
String convertDateString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  DateFormat formatter = DateFormat('MMM dd, HH:mm a');
  String formattedDate = formatter.format(dateTime.toLocal());
  return formattedDate;
}

/// time Ago
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

/// is Valid Email
bool isValidEmail(String email) {
  String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regExp = RegExp(emailPattern);
  return regExp.hasMatch(email);
}

/// calculate Total Votes
double calculateTotalVotes(List<OptionEntity> options) {
  double totalVotes = 0;
  for (var option in options) {
    totalVotes += double.parse(option.votes.toString());
  }
  return totalVotes;
}

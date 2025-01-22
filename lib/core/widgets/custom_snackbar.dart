import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String message}) {
  // Hide any current SnackBar
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  // Show the new SnackBar with the given message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ),
  );
}

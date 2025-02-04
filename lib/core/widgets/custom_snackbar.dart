import 'package:flutter/material.dart';

import '../theme/colors.dart';

void showSnackBar({required BuildContext context, required String message}) {
  // Hide any current SnackBar
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  // Show the new SnackBar with the given message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      duration: Duration(seconds: 2),
      elevation: 2,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black87,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  );
}

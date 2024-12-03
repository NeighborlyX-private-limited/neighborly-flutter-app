import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

class SomethingWentWrong extends StatelessWidget {
  final String imagePath;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const SomethingWentWrong({
    super.key,
    required this.imagePath,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 400,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.26),
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Displaying the image
            SvgPicture.asset(
              imagePath,
              width: 150,
              height: 130,
            ),
            SizedBox(height: 8),

            /// Title text
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),

            /// Message text
            Text(
              message,
              style: TextStyle(fontSize: 14, color: AppColors.greyColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),

            /// Retry or go back button
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SomethingWentWrong extends StatelessWidget {
  final String imagePath; // Path to the image (SVG)
  final String title; // Title text
  final String message; // Message text
  final String buttonText; // Text for the button
  final VoidCallback onButtonPressed; // Button press callback

  // Constructor to accept these values
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
        height: 300,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying the image
            SvgPicture.asset(
              imagePath,
              width: 150,
              height: 130,
            ),
            SizedBox(height: 8),
            // Title text
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            // Message text
            Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            // Retry button
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

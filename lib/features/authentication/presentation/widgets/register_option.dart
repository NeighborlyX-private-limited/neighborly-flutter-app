import 'package:flutter/material.dart';

class RegisterWidget extends StatelessWidget {
  final Image image;
  final String title;
  const RegisterWidget({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: Colors.white,
            borderRadius: BorderRadius.circular(40)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class RegisterOption extends StatelessWidget {
  final Image image;
  final String title;
  final Function onTap;
  const RegisterOption({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.blackColor, width: 1),
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.blackColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

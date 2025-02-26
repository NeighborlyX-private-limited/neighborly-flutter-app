import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class ButtonContainerWidget extends StatelessWidget {
  final String? text;
  final Color color;
  final bool isFilled;
  final bool isActive;
  final VoidCallback? onTapListener;
  const ButtonContainerWidget({
    super.key,
    this.text,
    required this.color,
    required this.isFilled,
    this.isActive = false,
    this.onTapListener,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTapListener : null,
      child: Opacity(
        opacity: isActive ? 1 : 0.3,
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            border: isFilled ? null : Border.all(color: color, width: 1),
            color: isFilled ? color : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              "$text",
              style: TextStyle(
                color: isFilled ? AppColors.whiteColor : AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

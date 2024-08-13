import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

class ButtonContainerWidget extends StatelessWidget {
  final Color color;
  final String? text;
  final VoidCallback? onTapListener;
  final bool isActive;
  final bool isFilled;
  const ButtonContainerWidget(
      {super.key,
      required this.color,
      this.text,
      this.isActive = false,
      this.onTapListener,
      required this.isFilled});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? onTapListener : null,
      child: Opacity(
        opacity: isActive ? 1 : 0.3,
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
              border: isFilled ? null : Border.all(color: color, width: 1),
              color: isFilled ? color : Colors.white,
              borderRadius: BorderRadius.circular(32)),
          child: Center(
            child: Text(
              "$text",
              style: TextStyle(
                  color: isFilled ? Colors.white : AppColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

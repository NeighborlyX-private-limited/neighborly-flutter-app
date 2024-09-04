import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Color color;
  final String text;
  final Color textColor;
  final VoidCallback onTapListener;
  final bool isActive;
  const ButtonWidget({
    super.key,
    required this.color,
    required this.text,
    required this.textColor,
    required this.onTapListener,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? onTapListener : null,
      child: Opacity(
        opacity: isActive ? 1 : 0.3,
        child: Container(
          width: 145,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: color,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

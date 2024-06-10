import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final Color color;
  final Color titleColor;
  final String? action;
  const OptionCard(
      {super.key,
      required this.title,
      required this.color,
      this.action,
      required this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: action == null
              ? Border.all(
                  color: Colors.grey[300]!,
                )
              : null,
        ),
        padding: const EdgeInsets.all(8),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (action != null)
              Text(
                action!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ));
  }
}

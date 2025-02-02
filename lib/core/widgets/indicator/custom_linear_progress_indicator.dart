import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

class CustomLinearIndicator extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const CustomLinearIndicator({
    super.key,
    this.width = double.infinity,
    this.height = 4.0,
    this.color = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}

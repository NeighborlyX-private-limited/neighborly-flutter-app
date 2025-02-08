import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

class CustomCircularIndicator extends StatelessWidget {
  final Color color;
  const CustomCircularIndicator({
    super.key,
    this.color = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

class CircularSvgImage extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color color;

  const CircularSvgImage({
    super.key,
    required this.assetPath,
    this.size = 24.0,
    this.color = AppColors.greyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: SvgPicture.asset(
          assetPath,
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

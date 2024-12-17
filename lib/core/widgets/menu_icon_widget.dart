import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/colors.dart';

class MenuIconItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final double? iconSize;
  final String? svgPath;
  final VoidCallback onTap;
  final Color? textColor;
  const MenuIconItem({
    super.key,
    required this.title,
    this.icon = Icons.abc,
    this.iconSize = 20,
    this.svgPath = '',
    this.textColor = AppColors.blackColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            svgPath != ''
                ? SvgPicture.asset(
                    svgPath!,
                    width: iconSize,
                  )
                : Icon(
                    icon,
                    size: iconSize,
                  ),
            const SizedBox(width: 10),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.normal,
                fontSize: 18,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

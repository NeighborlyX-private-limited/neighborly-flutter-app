import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';

class PostButtonWidget extends StatelessWidget {
  final String? title;
  final bool isActive;
  final VoidCallback? onTapListener;
  const PostButtonWidget({
    super.key,
    required this.isActive,
    this.title,
    required this.onTapListener,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? onTapListener : null,
      child: Opacity(
        opacity: isActive ? 1 : 0.3,
        child: Container(
            padding: const EdgeInsets.all(12),
            width: 81,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                title ?? 'Post',
                style: whiteNormalTextStyle,
              ),
            )),
      ),
    );
  }
}

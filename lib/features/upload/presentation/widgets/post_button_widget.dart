import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';

class PostButtonWidget extends StatelessWidget {
  final bool isActive;
  
  const PostButtonWidget({
    super.key,
    required this.isActive,
 
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? () {} : null,
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
                'Post',
                style: whiteNormalTextStyle,
              ),
            )),
      ),
    );
  }
}

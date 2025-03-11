import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neighborly_flutter_app/core/constants/app_images.dart';
import '../../../../core/theme/colors.dart';

class ChatEmptyWidget extends StatelessWidget {
  const ChatEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppImages.emptyChat,
              width: MediaQuery.of(context).size.width * 0.60,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to chat!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Engage by joining communities or sending direct messages.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

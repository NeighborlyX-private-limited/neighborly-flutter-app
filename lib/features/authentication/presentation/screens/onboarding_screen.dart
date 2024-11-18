import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../widgets/button_widget.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 70.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/onboardingIcon.png'),
            const SizedBox(
              height: 25,
            ),
            Text(
              'Welcome to Neighborly',
              textAlign: TextAlign.center,
              style: onboardingHeading1Style,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Connect with your neighbors, share stories, and stay informed with Neighborly, your hyper-local community app designed to bring people together.',
              textAlign: TextAlign.center,
              style: blackonboardingBody1Style,
            ),
            Expanded(child: Container()),
            ButtonContainerWidget(
              text: 'Sign up',
              color: AppColors.primaryColor,
              onTapListener: () {
                context.push("/registerScreen");
              },
              isActive: true,
              isFilled: true,
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonContainerWidget(
              color: AppColors.primaryColor,
              text: 'Log in',
              isFilled: false,
              onTapListener: () {
                context.push("/loginScreen");
              },
              isActive: true,
            ),
          ],
        ),
      ),
    ));
  }
}

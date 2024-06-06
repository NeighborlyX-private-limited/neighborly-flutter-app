import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/widgets/button_widget.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
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
              style: onboardingHeading1Style,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              textAlign: TextAlign.center,
              style: onboardingBody1Style,
            ),
            Expanded(child: Container()),
            ButtonContainerWidget(
              text: 'Join Neighborly',
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

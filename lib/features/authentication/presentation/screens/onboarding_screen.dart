import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../widgets/button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              AppLocalizations.of(context)!.welcome_to_neighborly,
              // 'Welcome to Neighborly',
              textAlign: TextAlign.center,
              style: onboardingHeading1Style,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              AppLocalizations.of(context)!
                  .connect_with_your_neighbors_share_stories_and_stay_informed_with_neighborly_your_hyper_local_community_app_designed_to_bring_people_together,
              // 'Connect with your neighbors, share stories, and stay informed with Neighborly, your hyper-local community app designed to bring people together.',
              textAlign: TextAlign.center,
              style: blackonboardingBody1Style,
            ),
            Expanded(child: Container()),
            ButtonContainerWidget(
              text: AppLocalizations.of(context)!.signup,
              // text: 'Sign up',
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
              text: AppLocalizations.of(context)!.login,
              // text: 'Log in',
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

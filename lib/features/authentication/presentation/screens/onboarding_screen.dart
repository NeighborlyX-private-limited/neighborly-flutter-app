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
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 70.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/onboardingIcon.png'),
              const SizedBox(
                height: 25,
              ),
              Text(
                AppLocalizations.of(context)!.welcome_to_neighborly,
                textAlign: TextAlign.center,
                style: onboardingHeading1Style,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!
                    .connect_with_your_neighbors_share_stories_and_stay_informed_with_neighborly_your_hyper_local_community_app_designed_to_bring_people_together,
                textAlign: TextAlign.center,
                style: blackonboardingBody1Style,
              ),
              Expanded(child: Container()),
              ButtonContainerWidget(
                text: AppLocalizations.of(context)!.signup,
                color: AppColors.primaryColor,
                isActive: true,
                isFilled: true,
                onTapListener: () {
                  context.push("/registerScreen");
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonContainerWidget(
                text: AppLocalizations.of(context)!.login,
                color: AppColors.primaryColor,
                isFilled: false,
                isActive: true,
                onTapListener: () {
                  context.push("/loginScreen");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

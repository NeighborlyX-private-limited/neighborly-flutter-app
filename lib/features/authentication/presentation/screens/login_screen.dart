import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/login_with_email_bloc/login_with_email_bloc.dart';
import '../widgets/button_widget.dart';
import '../widgets/or_divider_widget.dart';
import '../widgets/register_option.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _controller;
  bool _isButtonActive = true;
  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isPhoneFilled = false;
  bool isPhoneValid = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onTap: () {
            context.pop();
          },
        ),
        centerTitle: true,
        title: Row(
          children: [
            const SizedBox(width: 100),
            Image.asset(
              'assets/onboardingIcon.png',
              width: 25,
              height: 25,
            ),
          ],
        ),
      ),
      body: BlocConsumer<LoginWithEmailBloc, LoginWithEmailState>(
        listener: (BuildContext context, LoginWithEmailState state) {
          if (state is OAuthSuccessState) {
            bool isSkippedTutorial = ShardPrefHelper.getIsSkippedTutorial();
            bool isViewedTutorial = ShardPrefHelper.getIsViewedTutorial();
            print('isSkippedTutorial in login:$isSkippedTutorial');
            print('isViewedTutorial in login:$isViewedTutorial');
            if (!isSkippedTutorial && !isViewedTutorial) {
              context.go('/tutorialScreen');
            } else {
              context.go('/home/Home');
            }
          }
        },
        builder: (context, state) {
          if (state is LoginLoadingState) {
            return Center(
              child: BouncingLogoIndicator(
                logo: 'images/logo.svg',
              ),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.welcome_back,
                      //'Welcome back',
                      style: onboardingHeading1Style,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  RegisterOption(
                    image: Image.asset('assets/google_icon.png'),
                    title: AppLocalizations.of(context)!.continue_with_google,
                    // title: 'Continue with Google',
                    onTap: () {
                      if (!_isButtonActive) return;
                      setState(() {
                        _isButtonActive = false;
                      });
                      BlocProvider.of<LoginWithEmailBloc>(context).add(
                        GoogleLoginEvent(),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RegisterOption(
                    image: Image.asset('assets/email_icon.png'),
                    title: AppLocalizations.of(context)!.continue_with_email,
                    // title: 'Continue with Email',
                    onTap: () {
                      context.push("/loginWithEmailScreen");
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const OrDividerWidget(),
                  const SizedBox(
                    height: 20,
                  ),

                  /// phone number text field
                  TextFieldWidget(
                    border: true,
                    inputType: TextInputType.phone,
                    maxLength: 10,
                    onChanged: (value) {
                      setState(() {
                        isPhoneFilled = _controller.text.isNotEmpty;
                      });
                    },
                    controller: _controller,
                    isPassword: false,
                    lableText: AppLocalizations.of(context)!.enter_phone_number,
                    // lableText: 'Enter Phone Number',
                  ),

                  isPhoneValid
                      ? SizedBox()
                      : Text(
                          AppLocalizations.of(context)!
                              .please_enter_a_valid_phone_number,
                          // 'Please enter a valid phone number.',
                          style: TextStyle(color: AppColors.redColor),
                        ),
                  const SizedBox(
                    height: 15,
                  ),

                  ///continue button

                  ButtonContainerWidget(
                    color: AppColors.primaryColor,
                    isActive: isPhoneFilled,
                    text: AppLocalizations.of(context)!.continues,
                    // text: 'Continue',
                    isFilled: true,
                    onTapListener: () {
                      if (!isValidPhoneNumber(_controller.text.trim())) {
                        setState(() {
                          isPhoneValid = false;
                        });
                        return;
                      }

                      context.go('/otp/${_controller.text}/phone-login');
                    },
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.privacy_policy,
                        // 'By clicking the above button and creating an account, you have read and accepted the Terms of Service and acknowledged our Privacy Policy',
                        style: const TextStyle(
                          color: AppColors.lightGreyColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                AppLocalizations.of(context)!.terms_of_service,
                            // text: 'Terms of Service.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.3,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}

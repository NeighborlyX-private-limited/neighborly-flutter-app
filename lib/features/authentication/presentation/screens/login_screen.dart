import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_sizedbox.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool isPhoneFilled = false;
  bool isPhoneValid = true;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  // DISPOSE
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        // APP BAR
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          surfaceTintColor: Colors.transparent,
          leading: InkWell(
            child: const Icon(
              Icons.arrow_back_ios,
            ),
            onTap: () {
              context.pop();
            },
          ),
          centerTitle: true,
          title: Row(
            children: [
              const CustomSizedBox(width: 110),
              Image.asset(
                'assets/onboardingIcon.png',
                width: 25,
                height: 25,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 50.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.welcome_back,
                    style: onboardingHeading1Style,
                  ),
                ),
                const CustomSizedBox(
                  height: 40,
                ),

                // GOOGLE LOGIN BUTTON
                BlocConsumer<LoginWithEmailBloc, LoginWithEmailState>(
                  listener: (BuildContext context, LoginWithEmailState state) {
                    // OAUTH SUCCESS STATE
                    if (state is OAuthSuccessState) {
                      bool isSkippedTutorial =
                          ShardPrefHelper.getIsSkippedTutorial();
                      bool isViewedTutorial =
                          ShardPrefHelper.getIsViewedTutorial();
                      if (!isSkippedTutorial && !isViewedTutorial) {
                        context.go('/invite');
                        //context.go('/tutorialScreen');
                      } else {
                        context.go('/home');
                      }
                    }
                    // FAILURE STATE
                    if (state is OAuthFailureState) {
                      showSnackBar(
                        context: context,
                        message: state.error,
                        durationInSeconds: 5,
                      );
                    }
                  },
                  builder: (context, state) {
                    // LOADING STATE
                    if (state is LoginLoadingState) {
                      CustomCircularIndicator();
                    }
                    return RegisterOption(
                      image: Image.asset('assets/google_icon.png'),
                      title: AppLocalizations.of(context)!.continue_with_google,
                      onTap: () {
                        if (!_isButtonActive) return;
                        setState(() {
                          _isButtonActive = false;
                        });
                        BlocProvider.of<LoginWithEmailBloc>(context).add(
                          GoogleLoginEvent(),
                        );
                      },
                    );
                  },
                ),
                const CustomSizedBox(
                  height: 10,
                ),

                // EMAIL LOGIN BUTTON
                RegisterOption(
                  image: Image.asset('assets/email_icon.png'),
                  title: AppLocalizations.of(context)!.continue_with_email,
                  onTap: () {
                    context.push("/loginWithEmailScreen");
                  },
                ),
                const CustomSizedBox(
                  height: 20,
                ),
                const OrDividerWidget(),
                const CustomSizedBox(
                  height: 20,
                ),

                // PHONE TEXT FILED

                TextFieldWidget(
                  border: true,
                  inputType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: (value) {
                    setState(() {
                      isPhoneFilled =
                          _controller.text.isNotEmpty && value.length == 10;
                      if (value.length == 10) {
                        isPhoneValid = true;
                      }
                    });
                  },
                  controller: _controller,
                  isPassword: false,
                  lableText: AppLocalizations.of(context)!.enter_phone_number,
                ),

                isPhoneValid
                    ? CustomSizedBox()
                    : Text(
                        AppLocalizations.of(context)!
                            .please_enter_a_valid_phone_number,
                        style: TextStyle(color: AppColors.redColor),
                      ),
                const CustomSizedBox(
                  height: 20,
                ),

                // CONTINUE BUTTON
                ButtonContainerWidget(
                  text: AppLocalizations.of(context)!.continues,
                  color: AppColors.primaryColor,
                  isActive: isPhoneFilled,
                  isFilled: true,
                  onTapListener: () {
                    if (!isValidPhoneNumber(_controller.text.trim())) {
                      setState(() {
                        isPhoneValid = false;
                      });
                      return;
                    } else {
                      setState(() {
                        isPhoneValid = true;
                      });
                    }
                    context.push('/otp/${_controller.text}/phone-login');
                  },
                ),

                const CustomSizedBox(height: 30),
                // TERMS AND CONDITIONS BUTTON
                // TERMS AND SERVIVCES
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: SizedBox(
                      width: 350,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text:
                                  "By clicking the above button and creating an account, you have read and accepted the ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                height: 1.5,
                              ),
                            ),
                            TextSpan(
                              text: "Terms of Service",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  const url =
                                      "https://neighborly.in/TermsAndCondition";
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(
                                      Uri.parse(url),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                            ),
                            const TextSpan(
                              text: " and acknowledged our ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "Privacy Policy.",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  const url =
                                      "https://neighborly.in/PrivacyPolicy";
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(
                                      Uri.parse(url),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                            ),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

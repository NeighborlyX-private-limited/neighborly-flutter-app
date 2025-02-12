import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
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
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
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
              const SizedBox(width: 100),
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
              horizontal: 20.0,
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
                const SizedBox(
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
                        context.go('/tutorialScreen');
                      } else {
                        context.go('/home');
                      }
                    }
                    // FAILURE STATE
                    if (state is LoginFailureState) {
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
                const SizedBox(
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
                const SizedBox(
                  height: 20,
                ),
                const OrDividerWidget(),
                const SizedBox(
                  height: 20,
                ),

                // PHONE TEXT FILED

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
                ),

                isPhoneValid
                    ? SizedBox()
                    : Text(
                        AppLocalizations.of(context)!
                            .please_enter_a_valid_phone_number,
                        style: TextStyle(color: AppColors.redColor),
                      ),
                const SizedBox(
                  height: 15,
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
                    }
                    context.push('/otp/${_controller.text}/phone-login');
                  },
                ),

                const SizedBox(height: 30),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.privacy_policy,
                      style: const TextStyle(
                        color: AppColors.lightGreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: AppLocalizations.of(context)!.terms_of_service,
                          style: onboardingBody2Style,
                        ),
                      ],
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

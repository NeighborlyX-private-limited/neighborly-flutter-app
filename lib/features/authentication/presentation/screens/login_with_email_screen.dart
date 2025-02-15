import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/login_with_email_bloc/login_with_email_bloc.dart';
import '../widgets/button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginWithEmailScreen extends StatefulWidget {
  const LoginWithEmailScreen({super.key});

  @override
  State<LoginWithEmailScreen> createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  bool isActive = false;
  bool noConnection = false;
  bool isEmailFilled = false;
  bool isEmailValid = true;
  bool isPasswordFilled = false;
  bool isPasswordWrong = false;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  // DISPOSE
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // CHECK IF BOTH TEXT FIELD ARE FILLED
  bool checkIsActive() {
    if (isEmailFilled && isPasswordFilled) {
      return true;
    }
    return false;
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
                Image.asset('assets/big_email_icon.png'),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.continue_with_email,
                  style: onboardingHeading1Style,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  AppLocalizations.of(context)!.join_neighborly_with_your_email,
                  style: onboardingBodyStyle,
                ),
                const SizedBox(
                  height: 25,
                ),

                // EMAIL TEXT FIELD
                TextFieldWidget(
                  inputType: TextInputType.emailAddress,
                  border: true,
                  controller: _emailController,
                  lableText: AppLocalizations.of(context)!.enter_email_address,
                  isPassword: false,
                  onChanged: (value) {
                    setState(() {
                      isEmailFilled = _emailController.text.isNotEmpty;
                    });
                  },
                ),
                !isEmailValid
                    ? Text(
                        AppLocalizations.of(context)!
                            .please_enter_a_valid_email_address,
                        style: TextStyle(color: AppColors.redColor),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 12,
                ),

                // PASSWORD TEXT FIELD
                TextFieldWidget(
                  border: true,
                  onChanged: (value) {
                    setState(() {
                      isPasswordFilled = _passwordController.text.isNotEmpty;
                    });
                  },
                  controller: _passwordController,
                  lableText: AppLocalizations.of(context)!.password,
                  isPassword: true,
                ),
                isPasswordWrong
                    ? Text(
                        AppLocalizations.of(context)!
                            .wrong_password_Try_again_or_click_forgot_password_to_reset_it,
                        style: TextStyle(color: AppColors.redColor),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 45,
                ),
                BlocConsumer<LoginWithEmailBloc, LoginWithEmailState>(
                  listener: (BuildContext context, LoginWithEmailState state) {
                    // LOGIN FAILURE STATE
                    if (state is LoginFailureState) {
                      if (state.error.contains('Invalid Email or Password')) {
                        setState(() {
                          isPasswordWrong = true;
                        });
                        return;
                      }
                      if (state.error.contains('internet')) {
                        setState(() {
                          noConnection = true;
                        });
                        return;
                      }
                    }

                    // LOGIN SUCCESS STATE
                    else if (state is LoginSuccessState) {
                      bool isEmailVerified =
                          state.authResponseEntity.isVerified!;
                      bool isSkippedTutorial =
                          ShardPrefHelper.getIsSkippedTutorial();
                      bool isViewedTutorial =
                          ShardPrefHelper.getIsViewedTutorial();

                      if (!isEmailVerified) {
                        context
                            .push('/otp/${_emailController.text}/email-verify');
                      } else if ((!isSkippedTutorial) && (!isViewedTutorial)) {
                        context.go('/tutorialScreen');
                      } else {
                        context.go('/home');
                      }
                    }
                  },
                  builder: (context, state) {
                    // LOGIN LOADING STATE
                    if (state is LoginLoadingState) {
                      return CustomCircularIndicator();
                    }

                    // LOGIN BUTTON
                    return ButtonContainerWidget(
                      text: AppLocalizations.of(context)!.login,
                      color: AppColors.primaryColor,
                      isActive: checkIsActive(),
                      isFilled: true,
                      onTapListener: () {
                        if (!isValidEmail(_emailController.text.trim())) {
                          setState(() {
                            isEmailValid = false;
                          });
                          return;
                        }
                        setState(() {
                          isEmailValid = true;
                        });
                        BlocProvider.of<LoginWithEmailBloc>(context).add(
                          LoginButtonPressedEvent(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                // FORGOT PASSWORD TEXT BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => context.push('/forgot-password'),
                      child: Text(
                        AppLocalizations.of(context)!.forgot_your_password,
                        style: onboardingBody2Style,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                noConnection
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.no_internet_connection,
                          style: TextStyle(color: AppColors.redColor),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

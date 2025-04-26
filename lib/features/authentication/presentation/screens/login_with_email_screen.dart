import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/custom_sizedbox.dart';
import '../../../../core/widgets/custom_snackbar.dart';
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
  bool isEmailFilled = false;
  bool isEmailValid = true;
  bool isPasswordFilled = false;

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
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: InkWell(
            child: const Icon(
              Icons.arrow_back_ios,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              const CustomSizedBox(width: 100),
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
                Image.asset('assets/big_email_icon.png'),
                const CustomSizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.continue_with_email,
                  style: onboardingHeading1Style,
                ),
                const CustomSizedBox(
                  height: 5,
                ),
                Text(
                  AppLocalizations.of(context)!.join_neighborly_with_your_email,
                  style: onboardingBodyStyle,
                ),
                const CustomSizedBox(
                  height: 25,
                ),

                // EMAIL TEXT FIELD
                TextFieldWidget(
                  controller: _emailController,
                  lableText: AppLocalizations.of(context)!.enter_email_address,
                  isPassword: false,
                  inputType: TextInputType.emailAddress,
                  border: true,
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
                    : const CustomSizedBox(),
                const CustomSizedBox(
                  height: 12,
                ),

                // PASSWORD TEXT FIELD
                TextFieldWidget(
                  controller: _passwordController,
                  lableText: AppLocalizations.of(context)!.password,
                  isPassword: true,
                  border: true,
                  onChanged: (value) {
                    setState(() {
                      isPasswordFilled = _passwordController.text.isNotEmpty;
                    });
                  },
                ),

                const CustomSizedBox(
                  height: 45,
                ),
                BlocConsumer<LoginWithEmailBloc, LoginWithEmailState>(
                  listener: (BuildContext context, LoginWithEmailState state) {
                    // LOGIN FAILURE STATE
                    if (state is LoginFailureState) {
                      if (mounted) {
                        print('this:${state.error}');
                        showSnackBar(context: context, message: state.error);
                      }
                    }

                    // LOGIN SUCCESS STATE
                    else if (state is LoginSuccessState) {
                      bool isEmailVerified = ShardPrefHelper.getIsVerified();
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
                const CustomSizedBox(
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
                const CustomSizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

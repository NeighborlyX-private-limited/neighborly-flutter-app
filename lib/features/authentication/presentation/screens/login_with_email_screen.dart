import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/login_with_email_bloc/login_with_email_bloc.dart';
import '../widgets/button_widget.dart';

class LoginWithEmailScreen extends StatefulWidget {
  const LoginWithEmailScreen({super.key});

  @override
  State<LoginWithEmailScreen> createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  bool isActive = false;
  bool isEmailFilled = false;
  bool isPasswordFilled = false;
  bool isEmailValid = true;
  bool isPasswordWrong = false;
  bool noConnection = false;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/big_email_icon.png'),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Continue with Email',
                style: onboardingHeading1Style,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Join Neighborly with your email.',
                style: onboardingBodyStyle,
              ),
              const SizedBox(
                height: 25,
              ),
              TextFieldWidget(
                border: true,
                controller: _emailController,
                lableText: 'Enter Email Address',
                isPassword: false,
                onChanged: (value) {
                  setState(() {
                    isEmailFilled = _emailController.text.isNotEmpty;
                  });
                },
              ),
              !isEmailValid
                  ? const Text(
                      'Please enter a valid email address',
                      style: TextStyle(color: AppColors.redColor),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 12,
              ),
              TextFieldWidget(
                border: true,
                onChanged: (value) {
                  setState(() {
                    isPasswordFilled = _passwordController.text.isNotEmpty;
                  });
                },
                controller: _passwordController,
                lableText: 'Password',
                isPassword: true,
              ),
              isPasswordWrong
                  ? const Text(
                      'Wrong password. Try again or click Forgot password to reset it.',
                      style: TextStyle(color: AppColors.redColor),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 45,
              ),
              BlocConsumer<LoginWithEmailBloc, LoginWithEmailState>(
                listener: (BuildContext context, LoginWithEmailState state) {
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
                  } else if (state is LoginSuccessState) {
                    bool isEmailVerified = state.authResponseEntity.isVerified!;

                    bool isSkippedTutorial =
                        ShardPrefHelper.getIsSkippedTutorial();
                    bool isViewedTutorial =
                        ShardPrefHelper.getIsViewedTutorial();
                    print(
                        'isSkippedTutorial in login with email:$isSkippedTutorial');
                    print(
                        'isViewedTutorial in login with email:$isViewedTutorial');
                    if (!isEmailVerified) {
                      context.go('/otp/${_emailController.text}/email-verify');
                    } else if ((!isSkippedTutorial) && (!isViewedTutorial)) {
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
                    // return const Center(
                    //   child: CircularProgressIndicator(),
                    // );
                  }
                  return ButtonContainerWidget(
                    isActive: checkIsActive(),
                    color: AppColors.primaryColor,
                    text: 'Log in',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => context.push('/forgot-password'),
                    child: Text(
                      'Forgot your password?',
                      style: onboardingBody2Style,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              noConnection
                  ? Center(
                      child: const Text(
                        'No Internet Connection',
                        style: TextStyle(color: AppColors.redColor),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    ));
  }
}

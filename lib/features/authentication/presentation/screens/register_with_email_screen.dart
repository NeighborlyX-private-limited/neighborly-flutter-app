import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/register_bloc/register_bloc.dart';
import '../widgets/button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterWithEmailScreen extends StatefulWidget {
  const RegisterWithEmailScreen({super.key});

  @override
  State<RegisterWithEmailScreen> createState() =>
      _RegisterWithEmailScreenState();
}

class _RegisterWithEmailScreenState extends State<RegisterWithEmailScreen> {
  bool isActive = false;
  bool isEmailFilled = false;
  bool isPasswordFilled = false;
  bool isConfirmPasswordFilled = false;

  bool isEmailValid = true;
  bool isPasswordShort = false;
  bool emailAlreadyExists = false;
  bool noConnection = false;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  bool checkIsActive() {
    return isEmailFilled &&
        isPasswordFilled &&
        isConfirmPasswordFilled &&
        _passwordController.text == _confirmPasswordController.text;
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
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/big_email_icon.png'),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.continue_with_email,
                  // 'Continue with Email',
                  style: onboardingHeading1Style,
                ),
                const SizedBox(height: 5),
                Text(
                  AppLocalizations.of(context)!.join_neighborly_with_your_email,
                  // 'Join Neighborly with your email.',
                  style: onboardingBodyStyle,
                ),
                const SizedBox(height: 25),
                TextFieldWidget(
                  border: true,
                  controller: _emailController,
                  lableText: AppLocalizations.of(context)!.enter_email_address,
                  // lableText: 'Enter Email Address',
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
                        // 'Please enter a valid email address',
                        style: TextStyle(color: AppColors.redColor),
                      )
                    : const SizedBox(),
                const SizedBox(height: 12),
                TextFieldWidget(
                  border: true,
                  onChanged: (value) {
                    setState(() {
                      isPasswordFilled = _passwordController.text.isNotEmpty;
                    });
                  },
                  controller: _passwordController,
                  lableText: AppLocalizations.of(context)!.password,
                  // lableText: 'Password',
                  isPassword: true,
                ),
                isPasswordShort
                    ? Text(
                        AppLocalizations.of(context)!
                            .password_should_be_atleast_6_character_long,
                        // 'Password must be at least 6 characters long',
                        style: TextStyle(color: AppColors.redColor),
                      )
                    : const SizedBox(),
                const SizedBox(height: 12),
                TextFieldWidget(
                  border: true,
                  onChanged: (value) {
                    setState(() {
                      isConfirmPasswordFilled =
                          _confirmPasswordController.text.isNotEmpty;
                    });
                  },
                  controller: _confirmPasswordController,
                  isPassword: true,
                  lableText: AppLocalizations.of(context)!.confirm_password,
                  // lableText: 'Re-Password',
                ),
                const SizedBox(height: 45),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (BuildContext context, RegisterState state) {
                    if (state is RegisterFailureState) {
                      if (state.error.contains('email') ||
                          state.error.contains('registered')) {
                        setState(() {
                          emailAlreadyExists = true;
                        });
                        return;
                      }
                      if (state.error.contains('internet')) {
                        setState(() {
                          noConnection = true;
                        });
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    } else if (state is RegisterSuccessState) {
                      print('GOTO: otp varification...');
                      context.go('/otp/${_emailController.text}/email-verify');
                      //context
                      //.push('/otp/${_emailController.text}/email-verify');
                    }
                  },
                  builder: (context, state) {
                    if (state is RegisterLoadingState) {
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
                        text: AppLocalizations.of(context)!.signup,
                        // text: 'Sign Up',
                        isFilled: true,
                        onTapListener: () {
                          if (!isValidEmail(_emailController.text.trim())) {
                            setState(() {
                              isEmailValid = false;
                            });
                            return;
                          }
                          if (_passwordController.text.length < 6) {
                            setState(() {
                              isPasswordShort = true;
                            });
                            return;
                          }
                          setState(() {
                            isEmailValid = true;
                          });
                          BlocProvider.of<RegisterBloc>(context).add(
                            RegisterButtonPressedEvent(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            ),
                          );
                        });
                  },
                ),
                const SizedBox(height: 15),
                emailAlreadyExists
                    ? Text(
                        AppLocalizations.of(context)!
                            .email_already_exists_please_login,
                        // 'Email already exists. Please login.',
                        style: TextStyle(color: AppColors.redColor),
                      )
                    : const SizedBox(),
                noConnection
                    ? Text(
                        AppLocalizations.of(context)!.no_internet_connection,
                        // 'No Internet Connection',
                        style: TextStyle(color: AppColors.redColor),
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

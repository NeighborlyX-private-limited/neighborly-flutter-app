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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  /// init method
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  /// dispose method
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// check is active
  /// it is for button enable or disable
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
              Icons.arrow_back,
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

                /// email text field
                TextFieldWidget(
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

                ///password text field
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
                    /// failure state
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

                    ///success state
                    else if (state is LoginSuccessState) {
                      bool isEmailVerified =
                          state.authResponseEntity.isVerified!;
                      bool isSkippedTutorial =
                          ShardPrefHelper.getIsSkippedTutorial();
                      bool isViewedTutorial =
                          ShardPrefHelper.getIsViewedTutorial();

                      if (!isEmailVerified) {
                        context
                            .go('/otp/${_emailController.text}/email-verify');
                      } else if ((!isSkippedTutorial) && (!isViewedTutorial)) {
                        context.go('/tutorialScreen');
                      } else {
                        context.go('/home/Home');
                      }
                    }
                  },
                  builder: (context, state) {
                    /// loading state
                    if (state is LoginLoadingState) {
                      return Center(
                        child: BouncingLogoIndicator(
                          logo: 'images/logo.svg',
                        ),
                      );
                    }

                    ///login button
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

                /// forgot password text button
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

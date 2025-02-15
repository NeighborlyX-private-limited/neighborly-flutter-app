import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
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

  // INIT STATE
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  // DISPOSE
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // CHECK IF ALL TEXT FIELDS ARE FILLED AND PASSWORD AND CONFIRM PASSWORD ARE SAME
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
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.continue_with_email,
                  style: onboardingHeading1Style,
                ),
                const SizedBox(height: 5),
                Text(
                  AppLocalizations.of(context)!.join_neighborly_with_your_email,
                  style: onboardingBodyStyle,
                ),
                const SizedBox(height: 25),

                // EMAIL TEXT FIELD
                TextFieldWidget(
                  inputType: TextInputType.emailAddress,
                  controller: _emailController,
                  border: true,
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
                const SizedBox(height: 12),

                // PASSWORD TEXT FIELD
                TextFieldWidget(
                  controller: _passwordController,
                  border: true,
                  lableText: AppLocalizations.of(context)!.password,
                  isPassword: true,
                  onChanged: (value) {
                    setState(() {
                      isPasswordFilled = _passwordController.text.isNotEmpty;
                    });
                  },
                ),
                isPasswordShort
                    ? Text(
                        AppLocalizations.of(context)!
                            .password_should_be_atleast_6_character_long,
                        style: TextStyle(color: AppColors.redColor),
                      )
                    : const SizedBox(),
                const SizedBox(height: 12),

                // CONFIRM PASSWORD TEXT FIELD
                TextFieldWidget(
                  controller: _confirmPasswordController,
                  border: true,
                  isPassword: true,
                  lableText: AppLocalizations.of(context)!.confirm_password,
                  onChanged: (value) {
                    setState(() {
                      isConfirmPasswordFilled =
                          _confirmPasswordController.text.isNotEmpty;
                    });
                  },
                ),
                const SizedBox(height: 45),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (BuildContext context, RegisterState state) {
                    if (!mounted) return;

                    // FAILURE STATE
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
                      showSnackBar(context: context, message: state.error);
                    }

                    // SUCCESS STATE
                    else if (state is RegisterSuccessState) {
                      context
                          .push('/otp/${_emailController.text}/email-verify');
                    }
                  },
                  builder: (context, state) {
                    // LOADING STATE
                    if (state is RegisterLoadingState) {
                      return CustomCircularIndicator();
                    }

                    // SIGNUP BUTTON
                    return ButtonContainerWidget(
                      text: AppLocalizations.of(context)!.signup,
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
                      },
                    );
                  },
                ),
                const SizedBox(height: 15),
                emailAlreadyExists
                    ? Text(
                        AppLocalizations.of(context)!
                            .email_already_exists_please_login,
                        style: TextStyle(color: AppColors.redColor),
                      )
                    : const SizedBox(),
                noConnection
                    ? Text(
                        AppLocalizations.of(context)!.no_internet_connection,
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

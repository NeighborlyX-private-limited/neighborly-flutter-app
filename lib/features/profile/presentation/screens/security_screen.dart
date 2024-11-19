import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../../authentication/presentation/widgets/button_widget.dart';
import '../bloc/change_password_bloc/change_password_bloc.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool isActive = false;
  late bool isCurrentPasswordFilled = false;
  late bool isPasswordFilled = false;
  late bool isConfirmPasswordFilled = false;
  bool noConnection = false;
  bool isWrongCurrentPassword = false;
  bool isNewPasswordShoart = false;
  bool isPasswordMismatch = false;

  late TextEditingController _currentPasswordController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _currentPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  bool checkIsActive() {
    if (isPasswordFilled &&
        isCurrentPasswordFilled &&
        isConfirmPasswordFilled &&
        _passwordController.text == _confirmPasswordController.text) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            child: const Icon(Icons.arrow_back_ios, size: 20),
            onTap: () => context.pop(),
          ),
          title: Text(
            'Security',
            style: blackNormalTextStyle,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change password',
                    style: blackNormalTextStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    border: true,
                    onChanged: (value) {
                      setState(() {
                        isCurrentPasswordFilled =
                            _currentPasswordController.text.trim().isNotEmpty;
                      });
                    },
                    controller: _currentPasswordController,
                    lableText: 'Current Password',
                    isPassword: true,
                  ),
                  isWrongCurrentPassword
                      ? const Text(
                          'Wrong password. Try again or click Forgot password to reset it.',
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    border: true,
                    onChanged: (value) {
                      setState(() {
                        isNewPasswordShoart = value.length < 6 ? true : false;
                        isPasswordFilled =
                            _passwordController.text.trim().isNotEmpty;
                      });
                    },
                    controller: _passwordController,
                    lableText: 'Password',
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    border: true,
                    onChanged: (value) {
                      setState(() {
                        isConfirmPasswordFilled =
                            _confirmPasswordController.text.trim().isNotEmpty;
                        isPasswordMismatch = _passwordController.text != value;
                      });
                    },
                    controller: _confirmPasswordController,
                    isPassword: true,
                    lableText: 'Confirm Password',
                  ),
                  isNewPasswordShoart
                      ? const Text(
                          'New password should be atleast 6 character long.',
                          style: TextStyle(color: AppColors.redColor),
                        )
                      : const SizedBox(),
                  if (isPasswordMismatch)
                    const Text(
                      'Passwords do not match.',
                      style: TextStyle(color: AppColors.redColor),
                    ),
                  const SizedBox(
                    height: 45,
                  ),
                  BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                    listener: (context, state) {
                      if (state is ChangePasswordFailureState) {
                        if (state.error.contains('wrong')) {
                          setState(() {
                            isWrongCurrentPassword = true;
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
                      } else if (state is ChangePasswordSuccessState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                        context.pop();
                      }
                    },
                    builder: (context, state) {
                      if (state is ChangePasswordLoadingState) {
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
                        text: 'Save Password',
                        isFilled: true,
                        onTapListener: () {
                          final String? email = ShardPrefHelper.getEmail();
                          if (_passwordController.text.length < 6) {
                            setState(() {
                              isNewPasswordShoart = true;
                            });
                            return;
                          } else {
                            isNewPasswordShoart = false;
                            BlocProvider.of<ChangePasswordBloc>(context).add(
                              ChangePasswordButtonPressedEvent(
                                currentPassword:
                                    _currentPasswordController.text.trim(),
                                email: email ?? '',
                                newPassword: _passwordController.text.trim(),
                                flag: true,
                              ),
                            );
                          }
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
                      ? const Text(
                          'No Internet Connection',
                          style: TextStyle(color: AppColors.redColor),
                        )
                      : const SizedBox(),
                ],
              )),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/text_field_widget.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/widgets/button_widget.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_password_bloc/change_password_bloc.dart';

class BasicInformationScreen extends StatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  State<BasicInformationScreen> createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends State<BasicInformationScreen> {
  bool isActive = false;
  late bool isCurrentPasswordFilled = false;
  late bool isPasswordFilled = false;
  late bool isConfirmPasswordFilled = false;
  bool noConnection = false;
  bool isWrongCurrentPassword = false;

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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 14.0, left: 14.0, right: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            child: const Icon(Icons.arrow_back_ios, size: 20),
                            onTap: () => context.pop(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Security',
                        style: blackNormalTextStyle,
                      ),
                      // BlocConsumer<UploadPostBloc, UploadPostState>(
                      //   listener: (context, state) {
                      //     if (state is UploadPostFailureState) {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         SnackBar(content: Text(state.error)),
                      //       );
                      //     } else if (state is UploadPostSuccessState) {
                      //       _contentController.clear();
                      //       _titleController.clear();
                      //       _removeImage();
                      //       // context.go('/homescreen');
                      //     }
                      //   },
                      //   builder: (context, state) {
                      //     if (state is UploadPostLoadingState) {
                      //       return const Center(
                      //           child: CircularProgressIndicator());
                      //     }
                      //     return PostButtonWidget(
                      //       onTapListener: () async {
                      //         List<double> location =
                      //             ShardPrefHelper.getLocation();
            
                      //         List<Placemark> placemarks =
                      //             await placemarkFromCoordinates(
                      //           location[0],
                      //           location[1],
                      //         );
            
                      //         BlocProvider.of<UploadPostBloc>(context).add(
                      //           UploadPostPressedEvent(
                      //             city: placemarks[0].locality ?? '',
                      //             content: _contentController.text.trim(),
                      //             title: _titleController.text.trim(),
                      //             type: 'post',
                      //             multimedia: _selectedImage,
                      //             allowMultipleVotes: false,
                      //           ),
                      //         );
                      //       },
                      //       isActive: isTitleFilled,
                      //     );
                      //   },
                      // )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
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
                                _currentPasswordController.text
                                    .trim()
                                    .isNotEmpty;
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
                                _confirmPasswordController.text
                                    .trim()
                                    .isNotEmpty;
                          });
                        },
                        controller: _confirmPasswordController,
                        isPassword: true,
                        lableText: 'Confirm Password',
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
                            context.push('/settingsScreen');
                          }
                        },
                        builder: (context, state) {
                          if (state is ChangePasswordLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ButtonContainerWidget(
                            isActive: checkIsActive(),
                            color: AppColors.primaryColor,
                            text: 'Save Password',
                            isFilled: true,
                            onTapListener: () {
                              final String? email =
                                  ShardPrefHelper.getEmail();
                              BlocProvider.of<ChangePasswordBloc>(context)
                                  .add(
                                ChangePasswordButtonPressedEvent(
                                  currentPassword:
                                      _currentPasswordController.text
                                          .trim(),
                                  email: email!,
                                  newPassword:
                                      _passwordController.text.trim(),
                                  flag: true,
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
                          ? const Text(
                              'No Internet Connection',
                              style: TextStyle(color: Colors.red),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            )));
  }
}

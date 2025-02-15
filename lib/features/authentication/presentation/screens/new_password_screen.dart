import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../widgets/button_widget.dart';
import '../../../profile/presentation/bloc/change_password_bloc/change_password_bloc.dart';

class NewPasswordScreen extends StatefulWidget {
  final String data;
  const NewPasswordScreen({super.key, required this.data});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool isActive = false;

  late bool isPasswordFilled = false;
  late bool isConfirmPasswordFilled = false;

  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  // DISPOSE
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // CHECK IF BOTH TEXT FIELDS ARE FILLED AND PASSWORD AND CONFIRM PASSWORD IS SAME
  bool checkIsActive() {
    if (isPasswordFilled &&
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
                Image.asset('assets/big_lock_icon.png'),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Create new Password',
                  style: onboardingHeading1Style,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Set a new password for your account',
                  style: onboardingBodyStyle,
                ),
                const SizedBox(
                  height: 20,
                ),

                // PASSWORD TEXT FIELD
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
                  height: 8,
                ),

                // CONFIRM PASSWORD TEXT FIELD
                TextFieldWidget(
                  border: true,
                  onChanged: (value) {
                    setState(() {
                      isConfirmPasswordFilled =
                          _confirmPasswordController.text.trim().isNotEmpty;
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
                    // FAILURE STATE
                    if (state is ChangePasswordFailureState) {
                      showSnackBar(context: context, message: state.error);
                    }

                    // SUCCESS STATE
                    else if (state is ChangePasswordSuccessState) {
                      showSnackBar(context: context, message: state.message);
                      context.go('/loginScreen');
                    }
                  },
                  builder: (context, state) {
                    // LOADING STATE
                    if (state is ChangePasswordLoadingState) {
                      return CustomCircularIndicator();
                    }

                    // CONTINUE BUTTON
                    return ButtonContainerWidget(
                      text: 'Continue',
                      color: AppColors.primaryColor,
                      isActive: checkIsActive(),
                      isFilled: true,
                      onTapListener: () {
                        BlocProvider.of<ChangePasswordBloc>(context).add(
                          ChangePasswordButtonPressedEvent(
                            email: widget.data,
                            newPassword: _passwordController.text.trim(),
                            flag: false,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

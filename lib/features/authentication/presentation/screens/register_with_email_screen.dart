import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/register_with_email_bloc/register_with_email_bloc.dart';
import '../widgets/button_widget.dart';

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
  // bool isDayFilled = false;
  // bool isMonthFilled = false;
  // bool isYearFilled = false;
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                Text('Continue with Email', style: onboardingHeading1Style),
                const SizedBox(height: 5),
                Text('Join Neighborly with your email.',
                    style: onboardingBodyStyle),
                const SizedBox(height: 25),
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
                        style: TextStyle(color: Colors.red),
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
                  lableText: 'Password',
                  isPassword: true,
                ),
                isPasswordShort
                    ? const Text(
                        'Password must be at least 8 characters long',
                        style: TextStyle(color: Colors.red),
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
                  lableText: 'Re-Password',
                ),
                const SizedBox(height: 45),
                BlocConsumer<RegisterWithEmailBloc, RegisterWithEmailState>(
                  listener:
                      (BuildContext context, RegisterWithEmailState state) {
                    if (state is RegisterFailureState) {
                      if (state.error.contains('email')) {
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
                      context
                          .push('/otp/${_emailController.text}/email-verify');
                    }
                  },
                  builder: (context, state) {
                    if (state is RegisterLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ButtonContainerWidget(
                        isActive: checkIsActive(),
                        color: AppColors.primaryColor,
                        text: 'Sign Up',
                        isFilled: true,
                        onTapListener: () {
                          if (!isValidEmail(_emailController.text.trim())) {
                            setState(() {
                              isEmailValid = false;
                            });
                            return;
                          }
                          if (_passwordController.text.length < 8) {
                            setState(() {
                              isPasswordShort = true;
                            });
                            return;
                          }
                          setState(() {
                            isEmailValid = true;
                          });
                          BlocProvider.of<RegisterWithEmailBloc>(context).add(
                            RegisterButtonPressedEvent(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              // dob: formatDOB(
                              //     _dateController.text.trim(),
                              //     _monthController.text.trim(),
                              //     _yearController.text.trim()),
                              // gender: _selectedGender,
                            ),
                          );
                        });
                  },
                ),
                const SizedBox(height: 15),
                emailAlreadyExists
                    ? const Text(
                        'Email already exists. Please login.',
                        style: TextStyle(color: Colors.red),
                      )
                    : const SizedBox(),
                noConnection
                    ? const Text(
                        'No Internet Connection',
                        style: TextStyle(color: Colors.red),
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

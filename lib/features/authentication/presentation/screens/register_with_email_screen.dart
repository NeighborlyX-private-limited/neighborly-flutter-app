import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/resend_otp_bloc/resend_otp_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/register_with_email_bloc/register_with_email_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/widgets/button_widget.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/widgets/text_field_widget.dart';

class RegisterWithEmailScreen extends StatefulWidget {
  const RegisterWithEmailScreen({super.key});

  @override
  State<RegisterWithEmailScreen> createState() =>
      _RegisterWithEmailScreenState();
}

class _RegisterWithEmailScreenState extends State<RegisterWithEmailScreen> {
  bool isActive = false;
  late bool isEmailFilled = false;
  late bool isPasswordFilled = false;
  late bool isConfirmPasswordFilled = false;
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
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  bool checkIsActive() {
    if (isEmailFilled &&
        isPasswordFilled &&
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
          child: const Icon(
            Icons.arrow_back_ios,
            size: 15,
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
                controller: _emailController,
                lableText: 'Enter Email Address',
                isPassword: false,
                onChanged: (value) {
                  setState(() {
                    isEmailFilled = _emailController.text.isNotEmpty;
                  });
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFieldWidget(
                onChanged: (value) {
                  setState(() {
                    isPasswordFilled = _passwordController.text.isNotEmpty;
                  });
                },
                controller: _passwordController,
                lableText: 'Password',
                isPassword: true,
              ),
              const SizedBox(
                height: 12,
              ),
              TextFieldWidget(
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
              const SizedBox(
                height: 45,
              ),
              BlocConsumer<RegisterWithEmailBloc, RegisterWithEmailState>(
                listener: (BuildContext context, RegisterWithEmailState state) {
                  if (state is RegisterFailureState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  } else if (state is RegisterSuccessState) {
                    BlocProvider.of<ResendOtpBloc>(context).add(
                      ResendOTPButtonPressedEvent(
                        email: _emailController.text,
                      ),
                    );
                    context.push('/otp/${_emailController.text}/true');
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
                        BlocProvider.of<RegisterWithEmailBloc>(context).add(
                          RegisterButtonPressedEvent(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

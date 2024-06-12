import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/login_with_email_bloc/login_with_email_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/widgets/button_widget.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/widgets/text_field_widget.dart';

class LoginWithEmailScreen extends StatefulWidget {
  const LoginWithEmailScreen({super.key});

  @override
  State<LoginWithEmailScreen> createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  bool isActive = false;
  late bool isEmailFilled = false;
  late bool isPasswordFilled = false;

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
                height: 45,
              ),
              BlocConsumer<LoginWithEmailBloc, LoginWithEmailState>(
                listener: (BuildContext context, LoginWithEmailState state) {
                  if (state is LoginFailureState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  } else if (state is LoginSuccessState) {
                    bool isEmailVerified = state.authResponseEntity.isVerified;
                    isEmailVerified
                        ? context.go('/homescreen')
                        : context.push('/otp/${_emailController.text}/true');
                  }
                },
                builder: (context, state) {
                  if (state is LoginLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ButtonContainerWidget(
                    isActive: checkIsActive(),
                    color: AppColors.primaryColor,
                    text: 'Log in',
                    isFilled: true,
                    onTapListener: () {
                      BlocProvider.of<LoginWithEmailBloc>(context).add(
                        LoginButtonPressedEvent(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 10,
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
              )
            ],
          ),
        ),
      ),
    ));
  }
}

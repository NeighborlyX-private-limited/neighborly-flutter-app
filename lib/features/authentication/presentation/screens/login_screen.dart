import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/login_with_email_bloc/login_with_email_bloc.dart';
import '../widgets/button_widget.dart';
import '../widgets/or_divider_widget.dart';
import '../widgets/register_option.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isPhoneFilled = false;

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
      body: BlocConsumer<LoginWithEmailBloc, LoginWithEmailState>(
        listener: (BuildContext context, LoginWithEmailState state) {
          if (state is OAuthSuccessState) {
            Future.delayed(Duration(seconds: 5)).then((_) {
              bool isSkippedTutorial = ShardPrefHelper.getIsSkippedTutorial();
              bool isViewedTutorial = ShardPrefHelper.getIsViewedTutorial();
              if (!isSkippedTutorial && !isViewedTutorial) {
                context.go('/tutorialScreen');
              } else {
                context.push('/home/false');
              }
              setState(() {});
            });
          }
        },
        builder: (context, state) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome back',
                  style: onboardingHeading1Style,
                ),
                const SizedBox(
                  height: 40,
                ),
                RegisterOption(
                  image: Image.asset('assets/google_icon.png'),
                  title: 'Continue with Google',
                  onTap: () {
                    BlocProvider.of<LoginWithEmailBloc>(context).add(
                      GoogleLoginEvent(),
                    );
                    // context.push("/loginWithEmailScreen");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                RegisterOption(
                  image: Image.asset('assets/email_icon.png'),
                  title: 'Continue with Email',
                  onTap: () {
                    context.push("/loginWithEmailScreen");
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const OrDividerWidget(),
                const SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                  border: true,
                  inputType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() {
                      isPhoneFilled = _controller.text.isNotEmpty;
                    });
                  },
                  controller: _controller,
                  isPassword: false,
                  lableText: 'Enter Phone Number',
                ),
                const SizedBox(
                  height: 15,
                ),
                ButtonContainerWidget(
                  color: AppColors.primaryColor,
                  isActive: isPhoneFilled,
                  text: 'Continue',
                  isFilled: true,
                  onTapListener: () {
                    context.push('/otp/${_controller.text}/phone-login');
                  },
                ),
                const SizedBox(height: 30),
                RichText(
                  text: TextSpan(
                    text:
                        'By clicking the above button and creating an account, you have read and accepted the Terms of Service and acknowledged our Privacy Policy',
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.3,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}

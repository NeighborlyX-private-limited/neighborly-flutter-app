import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/fogot_password_bloc/forgot_password_bloc.dart';
import '../widgets/button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late bool isEmailFilled = false;
  late TextEditingController _emailController;
  @override
  void initState() {
    _emailController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
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
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.forgot_your_password,
                  //'Forgot your Password?',
                  style: onboardingHeading1Style,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  AppLocalizations.of(context)!
                      .enter_your_email_and_we_will_send_you_a_code_to_reset_your_password,
                  //'Enter your email and we’ll send you a code to reset your password.',
                  style: onboardingBodyStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
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
                const SizedBox(
                  height: 45,
                ),
                BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                  listener: (BuildContext context, ForgotPasswordState state) {
                    if (state is ForgotPasswordFailureState) {
                      if (state.error.contains('Invalid Token')) {
                        context.go('/loginScreen');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      }
                    } else if (state is ForgotPasswordSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                      context.push(
                          '/otp/${_emailController.text}/forgot-password');
                    }
                  },
                  builder: (context, state) {
                    if (state is ForgotPasswordLoadingState) {
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
                      isActive: isEmailFilled,
                      color: AppColors.primaryColor,
                      text: AppLocalizations.of(context)!.send,
                      // text: 'Send',
                      isFilled: true,
                      onTapListener: () {
                        BlocProvider.of<ForgotPasswordBloc>(context).add(
                          ForgotPasswordButtonPressedEvent(
                            email: _emailController.text,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/register_bloc/register_bloc.dart';
import '../widgets/button_widget.dart';
import '../widgets/or_divider_widget.dart';
import '../widgets/register_option.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _controller;
  bool _isButtonActive = true;
  bool noConnection = false;
  bool isPhoneFilled = false;
  bool phoneAlreadyExists = false;
  bool isPhoneValid = true;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  // DISPOSE
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              SizedBox(width: 100),
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
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.signup,
                    style: onboardingHeading1Style,
                  ),
                ),
                const SizedBox(height: 40),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (BuildContext context, RegisterState state) {
                    // OAUTH SUCCESS STATE
                    if (state is OAuthSuccessState) {
                      bool isSkippedTutorial =
                          ShardPrefHelper.getIsSkippedTutorial();
                      bool isViewedTutorial =
                          ShardPrefHelper.getIsViewedTutorial();

                      if (!isSkippedTutorial && !isViewedTutorial) {
                        context.go('/tutorialScreen');
                      } else {
                        context.go('/home');
                      }
                    }
                    // FAILURE STATE
                    if (state is RegisterFailureState) {
                      showSnackBar(
                        context: context,
                        message: state.error,
                        durationInSeconds: 5,
                      );
                    }
                  },
                  builder: (context, state) {
                    // GOOGLE SIGNUP BUTTON
                    return RegisterOption(
                      title: AppLocalizations.of(context)!.continue_with_google,
                      image: Image.asset('assets/google_icon.png'),
                      onTap: () {
                        if (!_isButtonActive) return;
                        setState(() {
                          _isButtonActive = false;
                        });

                        BlocProvider.of<RegisterBloc>(context).add(
                          GoogleSignUpEvent(),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),

                // EMAIL SIGNUP BUTTON
                RegisterOption(
                  title: AppLocalizations.of(context)!.continue_with_email,
                  image: Image.asset('assets/email_icon.png'),
                  onTap: () {
                    context.push("/registerWithEmailScreen");
                  },
                ),
                const SizedBox(height: 20),
                const OrDividerWidget(),
                const SizedBox(height: 20),

                // PHONE NUMBER TEXT FIELD
                TextFieldWidget(
                  controller: _controller,
                  isPassword: false,
                  lableText: AppLocalizations.of(context)!.enter_phone_number,
                  border: true,
                  inputType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: (value) {
                    setState(() {
                      isPhoneFilled = _controller.text.isNotEmpty;
                    });
                  },
                ),

                isPhoneValid
                    ? SizedBox()
                    : Text(
                        AppLocalizations.of(context)!
                            .please_enter_a_valid_phone_number,
                        style: TextStyle(color: AppColors.redColor),
                      ),
                phoneAlreadyExists
                    ? Text(
                        AppLocalizations.of(context)!
                            .phone_number_already_exists_please_login,
                        style: TextStyle(color: AppColors.redColor),
                      )
                    : const SizedBox(),
                const SizedBox(height: 15),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    // FAILURE STATE
                    if (state is RegisterFailureState) {
                      if (state.error.contains('exists') ||
                          state.error.contains('registered')) {
                        setState(() {
                          phoneAlreadyExists = true;
                        });
                      } else if (state.error.contains('internet')) {
                        setState(() {
                          noConnection = true;
                        });
                      } else {
                        showSnackBar(context: context, message: state.error);
                      }
                    }

                    // SUCCESS STATE
                    else if (state is RegisterSuccessState) {
                      context.push('/otp/${_controller.text}/phone-register');
                    }
                  },
                  builder: (context, state) {
                    // LOADING STATE
                    if (state is RegisterLoadingState) {
                      return CustomCircularIndicator();
                    }

                    // CONTINUE BUTTON
                    return ButtonContainerWidget(
                      text: AppLocalizations.of(context)!.continues,
                      color: AppColors.primaryColor,
                      isActive: isPhoneFilled,
                      isFilled: true,
                      onTapListener: () {
                        if (!isValidPhoneNumber(_controller.text.trim())) {
                          setState(() {
                            isPhoneValid = false;
                          });
                          return;
                        }

                        BlocProvider.of<RegisterBloc>(context).add(
                          RegisterButtonPressedEvent(
                            phone: _controller.text.trim(),
                          ),
                        );
                      },
                    );
                  },
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
                const SizedBox(height: 30),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.privacy_policy,
                      style: const TextStyle(
                        color: AppColors.lightGreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: AppLocalizations.of(context)!.terms_of_service,
                          style: onboardingBody2Style,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

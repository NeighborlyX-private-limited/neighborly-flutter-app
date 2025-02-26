import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/custom_sizedbox.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/resend_otp_bloc/resend_otp_bloc.dart';
import '../bloc/verify_otp_bloc/verify_otp_bloc.dart';
import '../widgets/button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtpScreen extends StatefulWidget {
  final String data;
  final String verificationFor;
  const OtpScreen({
    super.key,
    required this.data,
    required this.verificationFor,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isOtpFilled = false;
  late TextEditingController _otpController;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    if (!(widget.verificationFor == 'forgot-password')) {
      if (widget.verificationFor == 'phone-login' ||
          widget.verificationFor == 'phone-register') {
        BlocProvider.of<ResendOtpBloc>(context).add(
          ResendOTPButtonPressedEvent(
            phone: widget.data,
          ),
        );
      } else {
        BlocProvider.of<ResendOtpBloc>(context).add(
          ResendOTPButtonPressedEvent(
            email: widget.data,
          ),
        );
      }
    }
  }

  // DISPOSE
  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

// BUILD
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        // APP BAR
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: InkWell(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              const CustomSizedBox(width: 110),
              // APP LOGO
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
              horizontal: 16.0,
              vertical: 50.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/big_otp_icon.png'),
                const CustomSizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.enter_verification_code,
                  style: onboardingHeading1Style,
                ),
                const CustomSizedBox(
                  height: 5,
                ),
                Text(
                  widget.verificationFor == 'phone-login' ||
                          widget.verificationFor == 'phone-register'
                      ? '${AppLocalizations.of(context)!.we_sent_a_verification_code_to_your_phone}: ${widget.data}'
                      : '${AppLocalizations.of(context)!.we_sent_a_verification_code_to_your_email}: ${widget.data}',
                  style: onboardingBodyStyle,
                ),
                const CustomSizedBox(
                  height: 20,
                ),

                // OTP TEXT FIELD
                TextFieldWidget(
                  controller: _otpController,
                  isPassword: false,
                  border: true,
                  inputType: TextInputType.number,
                  lableText: AppLocalizations.of(context)!.enter_otp,
                  onChanged: (value) {
                    setState(() {
                      isOtpFilled = _otpController.text.isNotEmpty;
                    });
                  },
                ),

                const CustomSizedBox(
                  height: 20,
                ),
                // VERIFY BUTTON
                BlocConsumer<OtpBloc, OtpState>(
                  listener: (BuildContext context, OtpState state) {
                    // FAILURE STATE
                    if (state is OtpLoadFailure) {
                      showSnackBar(context: context, message: state.error);
                    }

                    // SUCCESS STATE
                    else if (state is OtpLoadSuccess) {
                      showSnackBar(context: context, message: state.message);

                      if (widget.verificationFor == 'email-verify' ||
                          widget.verificationFor == 'phone-login' ||
                          widget.verificationFor == 'phone-register') {
                        bool isSkippedTutorial =
                            ShardPrefHelper.getIsSkippedTutorial();
                        bool isViewedTutorial =
                            ShardPrefHelper.getIsViewedTutorial();
                        if (!isSkippedTutorial && !isViewedTutorial) {
                          context.go('/tutorialScreen');
                        } else {
                          context.go('/home');
                        }
                      } else if (widget.verificationFor == 'forgot-password') {
                        context.push('/newPassword/${widget.data}');
                      }
                    }
                  },
                  builder: (context, state) {
                    // LOADING STATE
                    if (state is OtpLoadInProgress) {
                      return CustomCircularIndicator();
                    }

                    return ButtonContainerWidget(
                      text: AppLocalizations.of(context)!.verify,
                      color: AppColors.primaryColor,
                      isActive: isOtpFilled,
                      isFilled: true,
                      onTapListener: () {
                        if (widget.verificationFor == 'phone-login' ||
                            widget.verificationFor == 'phone-register') {
                          BlocProvider.of<OtpBloc>(context).add(
                            OtpSubmitted(
                              otp: _otpController.text,
                              phone: widget.data,
                            ),
                          );
                        } else {
                          BlocProvider.of<OtpBloc>(context).add(
                            OtpSubmitted(
                              otp: _otpController.text,
                              email: widget.data,
                              verificationFor: widget.verificationFor,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                const CustomSizedBox(
                  height: 10,
                ),
                // RESEND OTP TEXT BUTTON
                GestureDetector(
                  onTap: () {
                    if (widget.verificationFor == 'phone-login' ||
                        widget.verificationFor == 'phone-register') {
                      BlocProvider.of<ResendOtpBloc>(context).add(
                        ResendOTPButtonPressedEvent(
                          phone: widget.data,
                        ),
                      );
                    } else {
                      BlocProvider.of<ResendOtpBloc>(context).add(
                        ResendOTPButtonPressedEvent(
                          email: widget.data,
                        ),
                      );
                    }
                  },
                  child: BlocConsumer<ResendOtpBloc, ResendOTPState>(
                    listener: (BuildContext context, ResendOTPState state) {
                      // FAILURE STATE
                      if (state is ResendOTPFailureState) {
                        showSnackBar(context: context, message: state.error);
                      }

                      // SUCCESS STATE
                      else if (state is ResendOTPSuccessState) {
                        showSnackBar(context: context, message: state.message);
                      }
                    },
                    builder: (context, state) {
                      // LOADING STATE
                      if (state is ResendOTPLoadingState) {
                        CustomCircularIndicator();
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.resend_code,
                            style: onboardingBody2Style,
                          )
                        ],
                      );
                    },
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

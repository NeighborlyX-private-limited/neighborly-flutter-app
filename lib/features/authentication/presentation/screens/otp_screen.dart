import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
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
  bool isInvalidOtp = false;
  bool isExpiredOtp = false;
  bool isUserNotFound = false;

  late TextEditingController _otpController;

  /// init method
  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();

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

  /// dispose method
  @override
  void dispose() {
    _otpController.dispose();
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
              Icons.arrow_back,
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
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 50.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/big_otp_icon.png'),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.enter_verification_code,
                  style: onboardingHeading1Style,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.verificationFor == 'phone-login' ||
                          widget.verificationFor == 'phone-register'
                      ? '${AppLocalizations.of(context)!.we_sent_a_verification_code_to_your_phone}: ${widget.data}'
                      : '${AppLocalizations.of(context)!.we_sent_a_verification_code_to_your_email}: ${widget.data}',
                  style: onboardingBodyStyle,
                ),
                const SizedBox(
                  height: 20,
                ),

                /// otp text field
                TextFieldWidget(
                  controller: _otpController,
                  lableText: AppLocalizations.of(context)!.enter_otp,
                  border: true,
                  isPassword: false,
                  onChanged: (value) {
                    setState(() {
                      isOtpFilled = _otpController.text.isNotEmpty;
                    });
                  },
                ),
                isInvalidOtp
                    ? Text(
                        AppLocalizations.of(context)!
                            .the_otp_entered_is_incorrect_please_try_again,
                        style: TextStyle(
                          color: AppColors.redColor,
                          fontSize: 12,
                        ),
                      )
                    : Container(),
                isExpiredOtp
                    ? Text(
                        AppLocalizations.of(context)!.otp_has_expired,
                        style: TextStyle(
                          color: AppColors.redColor,
                          fontSize: 12,
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 45,
                ),
                BlocConsumer<OtpBloc, OtpState>(
                  listener: (BuildContext context, OtpState state) {
                    /// failure state
                    if (state is OtpLoadFailure) {
                      if (state.error.contains('User not found')) {
                        setState(() {
                          isUserNotFound = true;
                        });
                      } else if (state.error.contains('OTP has expired')) {
                        setState(() {
                          isExpiredOtp = true;
                        });
                      } else if (state.error.contains('Invalid')) {
                        setState(() {
                          isInvalidOtp = true;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      }
                    }

                    /// success state
                    else if (state is OtpLoadSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
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
                          context.go('/home/Home');
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      } else if (widget.verificationFor == 'forgot-password') {
                        context.push('/newPassword/${widget.data}');
                      }
                    }
                  },
                  builder: (context, state) {
                    ///loading state
                    if (state is OtpLoadInProgress) {
                      return Center(
                        child: BouncingLogoIndicator(
                          logo: 'images/logo.svg',
                        ),
                      );
                    }

                    ///verify button
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
                const SizedBox(
                  height: 10,
                ),
                InkWell(
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
                      ///failure state
                      if (state is ResendOTPFailureState) {
                        if (state.error.contains('User not found')) {
                          setState(() {
                            isUserNotFound = true;
                          });
                        } else if (state.error.contains('OTP has expired')) {
                          setState(() {
                            isExpiredOtp = true;
                          });
                        } else if (state.error.contains('Invalid OTP')) {
                          setState(() {
                            isInvalidOtp = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error)),
                          );
                        }
                      }

                      ///success state
                      else if (state is ResendOTPSuccessState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      /// loading state
                      if (state is ResendOTPLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
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
                const SizedBox(
                  height: 20,
                ),
                isUserNotFound
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .user_not_found_please_sign_up,
                            style: TextStyle(
                              color: AppColors.redColor,
                              fontSize: 17,
                            ),
                          ),

                          /// sign up text button
                          InkWell(
                            onTap: () {
                              context.push('/registerScreen');
                            },
                            child: Text(
                              AppLocalizations.of(context)!.signup,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

class OtpScreenProfileUpdate extends StatefulWidget {
  final String data;
  final String verificationFor;
  final Function onVerifiedSuccessfully;
  const OtpScreenProfileUpdate(
      {super.key,
      required this.data,
      required this.verificationFor,
      required this.onVerifiedSuccessfully});

  @override
  State<OtpScreenProfileUpdate> createState() => _OtpScreenProfileUpdateState();
}

class _OtpScreenProfileUpdateState extends State<OtpScreenProfileUpdate> {
  bool isOtpFilled = false;
  bool isInvalidOtp = false;
  bool isExpiredOtp = false;
  bool isUserNotFound = false;

  late TextEditingController _otpController;

  @override
  void initState() {
    _otpController = TextEditingController();
    if (widget.verificationFor == 'phone-login' ||
        widget.verificationFor == 'phone-register') {
      print('phone-otp called: ${widget.data}');
      BlocProvider.of<ResendOtpBloc>(context).add(
        ResendOTPButtonPressedEvent(
          phone: widget.data,
        ),
      );
    } else {
      print('email-otp called: ${widget.data}');
      BlocProvider.of<ResendOtpBloc>(context).add(
        ResendOTPButtonPressedEvent(
          email: widget.data,
        ),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/big_otp_icon.png'),
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.enter_verification_code,
                // 'Enter Verification Code',
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
                // ? 'We sent a verification code to your phone: ${widget.data}'
                // : 'We sent a verification code to your email: ${widget.data}',
                style: onboardingBodyStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                border: true,
                controller: _otpController,
                lableText: AppLocalizations.of(context)!.enter_otp,
                // lableText: 'Enter OTP',
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
                      // 'The OTP entered is incorrect. Please try again.',
                      style: TextStyle(
                        color: AppColors.redColor,
                        fontSize: 12,
                      ),
                    )
                  : Container(),
              isExpiredOtp
                  ? Text(
                      AppLocalizations.of(context)!.otp_has_expired,
                      // 'OTP has expired',
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
                  if (state is OtpLoadFailure) {
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
                  } else if (state is OtpLoadSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                    if (widget.verificationFor == 'email-verify' ||
                        widget.verificationFor == 'phone-login' ||
                        widget.verificationFor == 'phone-register') {
                      if (widget.verificationFor == 'email-verify' ||
                          widget.verificationFor == 'phone-register') {
                        bool isSkippedTutorial =
                            ShardPrefHelper.getIsSkippedTutorial();
                        bool isViewedTutorial =
                            ShardPrefHelper.getIsViewedTutorial();
                        print(isSkippedTutorial);
                        print(isViewedTutorial);
                        if ((!isSkippedTutorial) && (!isViewedTutorial)) {
                          context.go('/tutorialScreen');
                        } else {
                          context.go('/home/Home');
                        }
                      } else {
                        bool isSkippedTutorial =
                            ShardPrefHelper.getIsSkippedTutorial();
                        bool isViewedTutorial =
                            ShardPrefHelper.getIsViewedTutorial();
                        if (!isSkippedTutorial && !isViewedTutorial) {
                          context.go('/tutorialScreen');
                        } else {
                          context.go('/home/Home');
                        }
                      }
                      widget.onVerifiedSuccessfully();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                      Navigator.of(context).pop();
                    } else if (widget.verificationFor == 'forgot-password') {
                      context.push('/newPassword/${widget.data}');
                    }
                  }
                },
                builder: (context, state) {
                  if (state is OtpLoadInProgress) {
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
                    isActive: isOtpFilled,
                    color: AppColors.primaryColor,
                    text: AppLocalizations.of(context)!.verify,
                    // text: 'Verify',
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
                              verificationFor: widget.verificationFor),
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
                    } else if (state is ResendOTPSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
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
                          // 'Resend code?',
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
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .user_not_found_please_sign_up,
                          // 'User not found, please ',
                          style: TextStyle(
                            color: AppColors.redColor,
                            fontSize: 17,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.go('/registerScreen');
                          },
                          child: Text(
                            AppLocalizations.of(context)!.signup,
                            // 'Sign Up',
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
    ));
  }
}

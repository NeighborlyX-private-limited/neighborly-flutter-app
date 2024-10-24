import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/resend_otp_bloc/resend_otp_bloc.dart';
import '../bloc/verify_otp_bloc/verify_otp_bloc.dart';
import '../widgets/button_widget.dart';

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

  @override
  void initState() {
    _otpController = TextEditingController();
    if (widget.verificationFor == 'phone-login' ||
        widget.verificationFor == 'phone-register') {
      print('phone-resend otp called: ${widget.data}');
      BlocProvider.of<ResendOtpBloc>(context).add(
        ResendOTPButtonPressedEvent(
          phone: widget.data,
        ),
      );
    } else {
      print('email-resend verify called = $widget.data');
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/big_otp_icon.png'),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Enter Verification Code',
                style: onboardingHeading1Style,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.verificationFor == 'phone-login' ||
                        widget.verificationFor == 'phone-register'
                    ? 'We sent a verification code to your phone: ${widget.data}'
                    : 'We sent a verification code to your email: ${widget.data}',
                style: onboardingBodyStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                border: true,
                controller: _otpController,
                lableText: 'Enter OTP',
                isPassword: false,
                onChanged: (value) {
                  setState(() {
                    isOtpFilled = _otpController.text.isNotEmpty;
                  });
                },
              ),
              isInvalidOtp
                  ? const Text(
                      'The OTP entered is incorrect. Please try again.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    )
                  : Container(),
              isExpiredOtp
                  ? const Text(
                      'OTP has expired',
                      style: TextStyle(
                        color: Colors.red,
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
                    } else if (state.error.contains('Invalid')) {
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
                        if (!isSkippedTutorial && !isViewedTutorial) {
                          context.go('/tutorialScreen');
                        } else {
                          context.go('/home/true');
                        }
                      } else {
                        bool isSkippedTutorial =
                            ShardPrefHelper.getIsSkippedTutorial();
                        bool isViewedTutorial =
                            ShardPrefHelper.getIsViewedTutorial();
                        if (!isSkippedTutorial && !isViewedTutorial) {
                          context.go('/tutorialScreen');
                        } else {
                          context.go('/home/false');
                        }
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
                  if (state is OtpLoadInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ButtonContainerWidget(
                    isActive: isOtpFilled,
                    color: AppColors.primaryColor,
                    text: 'Verify',
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
                          'Resend code?',
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
                        const Text(
                          'User not found, please ',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 17,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.go('/registerScreen');
                          },
                          child: const Text(
                            'Sign Up',
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

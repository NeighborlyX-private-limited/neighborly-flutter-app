part of 'resend_otp_bloc.dart';

abstract class ResendOTPState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ResendOTPInitialState extends ResendOTPState {
  ResendOTPInitialState();
}

class ResendOTPLoadingState extends ResendOTPState {
  ResendOTPLoadingState();
}

class ResendOTPSuccessState extends ResendOTPState {
  final String message;
  ResendOTPSuccessState({
    required this.message,
  });
}

class ResendOTPFailureState extends ResendOTPState {
  final String error;
  ResendOTPFailureState({required this.error});
}

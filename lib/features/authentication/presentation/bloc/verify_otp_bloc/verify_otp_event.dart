part of 'verify_otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OtpSubmitted extends OtpEvent {
  final String otp;
  final String email;
  final String verificationFor;
  OtpSubmitted({
    required this.otp,
    required this.email,
    required this.verificationFor,
  });

  @override
  List<Object?> get props => [otp, email];
}

// class OtpResendRequested extends OtpEvent {}

part of 'verify_otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OtpSubmitted extends OtpEvent {
  final String otp;
  final String? email;
  final String? verificationFor;
  final String? phone;
  OtpSubmitted({
    required this.otp,
    this.email,
    this.verificationFor,
    this.phone,
  });

  @override
  List<Object?> get props => [otp, email, verificationFor, phone];
}

part of 'resend_otp_bloc.dart';

abstract class ResendOTPEvent extends Equatable {}

class ResendOTPButtonPressedEvent extends ResendOTPEvent {
  final String email;

  ResendOTPButtonPressedEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

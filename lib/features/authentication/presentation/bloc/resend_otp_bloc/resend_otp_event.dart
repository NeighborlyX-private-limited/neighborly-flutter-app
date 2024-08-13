part of 'resend_otp_bloc.dart';

abstract class ResendOTPEvent extends Equatable {}

class ResendOTPButtonPressedEvent extends ResendOTPEvent {
  final String? email;
  final String? phone;

  ResendOTPButtonPressedEvent({this.phone, this.email});

  @override
  List<Object?> get props => [email];
}

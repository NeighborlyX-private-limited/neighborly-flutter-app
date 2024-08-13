part of 'verify_otp_bloc.dart';

abstract class OtpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OtpIdle extends OtpState {}

class OtpLoadInProgress extends OtpState {}

class OtpLoadSuccess extends OtpState {
  final String message;
  OtpLoadSuccess({
    required this.message,
  });
}

class OtpLoadFailure extends OtpState {
  final String error;

  OtpLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

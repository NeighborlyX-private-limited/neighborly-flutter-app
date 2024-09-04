part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {}

class ForgotPasswordButtonPressedEvent extends ForgotPasswordEvent {
  final String email;

  ForgotPasswordButtonPressedEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

part of 'login_with_email_bloc.dart';

abstract class LoginWithEmailEvent extends Equatable {}

class LoginButtonPressedEvent extends LoginWithEmailEvent {
  final String email;
  final String password;
  LoginButtonPressedEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class GoogleLoginEvent extends LoginWithEmailEvent {
  GoogleLoginEvent();

  @override
  List<Object?> get props => [];
}



part of 'register_with_email_bloc.dart';

abstract class RegisterWithEmailEvent extends Equatable {}

class RegisterButtonPressedEvent extends RegisterWithEmailEvent {
  final String email;
  final String password;

  RegisterButtonPressedEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}

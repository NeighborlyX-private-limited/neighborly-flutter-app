part of 'register_with_email_bloc.dart';

abstract class RegisterWithEmailEvent extends Equatable {}

class RegisterButtonPressedEvent extends RegisterWithEmailEvent {
  final String email;
  final String password;
  // final String dob;
  // final String gender;

  RegisterButtonPressedEvent({
    required this.email,
    required this.password,
    // required this.dob,
    // required this.gender,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        // dob,
        // gender,
      ];
}

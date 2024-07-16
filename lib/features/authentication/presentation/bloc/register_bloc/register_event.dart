part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {}

class RegisterButtonPressedEvent extends RegisterEvent {
  final String? email;
  final String? password;
  final String? phone;

  RegisterButtonPressedEvent({
    this.email,
    this.password,
    this.phone,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        phone,
      ];
}

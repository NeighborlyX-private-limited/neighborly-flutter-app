part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {}

class ChangePasswordButtonPressedEvent extends ChangePasswordEvent {
  final String email;
  final String? currentPassword;
  final String newPassword;
  final bool flag;

  ChangePasswordButtonPressedEvent({
    required this.email,
    this.currentPassword,
    required this.newPassword,
    required this.flag,
  });

  @override
  List<Object?> get props => [
        email,
        currentPassword,
        newPassword,
        flag,
      ];
}

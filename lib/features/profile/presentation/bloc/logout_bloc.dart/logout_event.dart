part of 'logout_bloc.dart';

abstract class LogoutEvent extends Equatable {}

class LogoutButtonPressedEvent extends LogoutEvent {
  LogoutButtonPressedEvent();

  @override
  List<Object?> get props => [];
}

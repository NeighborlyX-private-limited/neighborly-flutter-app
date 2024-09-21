part of 'google_authentication_bloc.dart';

abstract class GoogleAuthenticationEvent extends Equatable {
  const GoogleAuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class GoogleAuthenticationButtonPressedEvent extends GoogleAuthenticationEvent {
  GoogleAuthenticationButtonPressedEvent();

  @override
  List<Object?> get props => [];
}

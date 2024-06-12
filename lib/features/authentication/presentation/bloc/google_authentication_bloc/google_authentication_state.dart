part of 'google_authentication_bloc.dart';

abstract class GoogleAuthenticationState extends Equatable {
  const GoogleAuthenticationState();

  @override
  List<Object?> get props => [];
}

class GoogleAuthenticationInitialState extends GoogleAuthenticationState {}

class GoogleAuthenticationLoadingState extends GoogleAuthenticationState {}

class GoogleAuthenticationSuccessState extends GoogleAuthenticationState {
  final GoogleAuthEntitiy googleAuthEntity;

  const GoogleAuthenticationSuccessState({
    required this.googleAuthEntity,
  });

  @override
  List<Object?> get props => [googleAuthEntity];
}

class GoogleAuthenticationFailureState extends GoogleAuthenticationState {
  final String error;

  const GoogleAuthenticationFailureState({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}

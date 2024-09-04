part of 'logout_bloc.dart';

abstract class LogoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogoutInitialState extends LogoutState {
  LogoutInitialState();
}

class LogoutLoadingState extends LogoutState {
  LogoutLoadingState();
}

class LogoutSuccessState extends LogoutState {
  LogoutSuccessState();
}

class LogoutFailureState extends LogoutState {
  final String error;
  LogoutFailureState({required this.error});
}

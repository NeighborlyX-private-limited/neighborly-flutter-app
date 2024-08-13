part of 'login_with_email_bloc.dart';

abstract class LoginWithEmailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginWithEmailState {
  LoginInitialState();
}

class LoginLoadingState extends LoginWithEmailState {
  LoginLoadingState();
}

class LoginSuccessState extends LoginWithEmailState {
  final AuthResponseEntity authResponseEntity ;
  LoginSuccessState({
    required this.authResponseEntity,
  });
}

class LoginFailureState extends LoginWithEmailState {
  final String error;
  LoginFailureState({required this.error});
}

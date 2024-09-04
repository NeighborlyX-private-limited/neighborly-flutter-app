part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitialState extends ForgotPasswordState {
  ForgotPasswordInitialState();
}

class ForgotPasswordLoadingState extends ForgotPasswordState {
  ForgotPasswordLoadingState();
}

class ForgotPasswordSuccessState extends ForgotPasswordState {
  final String message;
  ForgotPasswordSuccessState({
    required this.message,
  });
}

class ForgotPasswordFailureState extends ForgotPasswordState {
  final String error;
  ForgotPasswordFailureState({required this.error});
}

part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChangePasswordInitialState extends ChangePasswordState {
  ChangePasswordInitialState();
}

class ChangePasswordLoadingState extends ChangePasswordState {
  ChangePasswordLoadingState();
}

class ChangePasswordSuccessState extends ChangePasswordState {
  final String message;
  ChangePasswordSuccessState({
    required this.message,
  });
}

class ChangePasswordFailureState extends ChangePasswordState {
  final String error;
  ChangePasswordFailureState({required this.error});
}

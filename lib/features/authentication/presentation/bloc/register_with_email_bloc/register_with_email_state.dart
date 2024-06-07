part of 'register_with_email_bloc.dart';

abstract class RegisterWithEmailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitialState extends RegisterWithEmailState {
  RegisterInitialState();
}

class RegisterLoadingState extends RegisterWithEmailState {
  RegisterLoadingState();
}

class RegisterSuccessState extends RegisterWithEmailState {
  RegisterSuccessState();
}

class RegisterFailureState extends RegisterWithEmailState {
  final String error;
  RegisterFailureState({required this.error});
}

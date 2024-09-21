part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitialState extends RegisterState {
  RegisterInitialState();
}

class RegisterLoadingState extends RegisterState {
  RegisterLoadingState();
}

class RegisterSuccessState extends RegisterState {
  RegisterSuccessState();
}

class RegisterFailureState extends RegisterState {
  final String error;
  RegisterFailureState({required this.error});
}

class OAuthSuccessState extends RegisterState {
  final String? message;
  OAuthSuccessState({this.message});
}

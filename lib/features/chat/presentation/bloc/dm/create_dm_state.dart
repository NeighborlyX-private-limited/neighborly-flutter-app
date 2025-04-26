part of 'create_dm_bloc.dart';

abstract class CreateDmState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateDmInitialState extends CreateDmState {
  CreateDmInitialState();
}

class CreateDmLoadingState extends CreateDmState {
  CreateDmLoadingState();
}

class CreateDmSuccessState extends CreateDmState {
  final String chatId;
  CreateDmSuccessState({required this.chatId});
}

class CreateDmFailureState extends CreateDmState {
  final String error;
  CreateDmFailureState({required this.error});
}

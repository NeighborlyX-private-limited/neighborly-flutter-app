part of 'update_block_user_bloc.dart';

abstract class UpdateBlockUserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateBlockUserInitialState extends UpdateBlockUserState {
  UpdateBlockUserInitialState();
}

class UpdateBlockUserLoadingState extends UpdateBlockUserState {
  UpdateBlockUserLoadingState();
}

class UpdateBlockSuccessState extends UpdateBlockUserState {
  final String message;
  UpdateBlockSuccessState({required this.message});
}

class UpdateBlockUserFailureState extends UpdateBlockUserState {
  final String error;
  UpdateBlockUserFailureState({required this.error});
}

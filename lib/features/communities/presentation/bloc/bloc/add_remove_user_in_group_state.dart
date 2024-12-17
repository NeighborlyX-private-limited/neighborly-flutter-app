part of 'add_remove_user_in_group_bloc.dart';

abstract class AddRemoveUserInGroupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddRemoveUserInGroupInitialState extends AddRemoveUserInGroupState {
  AddRemoveUserInGroupInitialState();
}

class AddRemoveUserInGroupLoadingState extends AddRemoveUserInGroupState {
  AddRemoveUserInGroupLoadingState();
}

class AddUserInGroupSuccessState extends AddRemoveUserInGroupState {
  AddUserInGroupSuccessState();
}

class RemoveUserInGroupSuccessState extends AddRemoveUserInGroupState {
  RemoveUserInGroupSuccessState();
}

class AddRemoveUserInGroupFailureState extends AddRemoveUserInGroupState {
  final String error;
  AddRemoveUserInGroupFailureState({required this.error});
}

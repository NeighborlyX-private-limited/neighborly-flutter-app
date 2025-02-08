part of 'update_mute_group_bloc.dart';

abstract class UpdateMuteGroupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateMuteGroupInitialState extends UpdateMuteGroupState {
  UpdateMuteGroupInitialState();
}

class UpdateMuteGroupLoadingState extends UpdateMuteGroupState {
  UpdateMuteGroupLoadingState();
}

class UpdateMuteGroupSuccessState extends UpdateMuteGroupState {
  UpdateMuteGroupSuccessState();
}

class UpdateMuteGroupFailureState extends UpdateMuteGroupState {
  final String error;
  UpdateMuteGroupFailureState({required this.error});
}

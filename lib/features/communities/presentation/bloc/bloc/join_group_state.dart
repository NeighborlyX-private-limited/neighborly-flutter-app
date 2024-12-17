part of 'join_group_bloc.dart';

abstract class JoinGroupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class JoinGroupInitialState extends JoinGroupState {
  JoinGroupInitialState();
}

class JoinGroupLoadingState extends JoinGroupState {
  JoinGroupLoadingState();
}

class JoinGroupSuccessState extends JoinGroupState {
  JoinGroupSuccessState();
}

class LeaveGroupSuccessState extends JoinGroupState {
  LeaveGroupSuccessState();
}

class JoinGroupFailureState extends JoinGroupState {
  final String error;
  JoinGroupFailureState({required this.error});
}

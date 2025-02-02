part of 'get_join_group_request_bloc.dart';

abstract class GetJoinGroupRequestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetJoinGroupRequestInitialState extends GetJoinGroupRequestState {
  GetJoinGroupRequestInitialState();
}

class GetJoinGroupRequestLoadingState extends GetJoinGroupRequestState {
  GetJoinGroupRequestLoadingState();
}

class GetJoinGroupRequestSuccessState extends GetJoinGroupRequestState {
  final List<GroupJoinRequestModel> communities;
  // GetJoinGroupRequestSuccessState({required this.communities});
  GetJoinGroupRequestSuccessState({required this.communities});
}

class GetJoinGroupRequestFailureState extends GetJoinGroupRequestState {
  final String error;
  GetJoinGroupRequestFailureState({required this.error});
}

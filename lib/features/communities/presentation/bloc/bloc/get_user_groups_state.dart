part of 'get_user_groups_bloc.dart';

abstract class GetUserGroupsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUserGroupsInitialState extends GetUserGroupsState {
  GetUserGroupsInitialState();
}

class GetUserGroupsLoadingState extends GetUserGroupsState {
  GetUserGroupsLoadingState();
}

class GetUserGroupsSuccessState extends GetUserGroupsState {
  final List<CommunityModel> communities;
  GetUserGroupsSuccessState({required this.communities});
}

class GetUserGroupsFailureState extends GetUserGroupsState {
  final String error;
  GetUserGroupsFailureState({required this.error});
}

part of 'get_my_groups_bloc.dart';

abstract class GetMyGroupsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetMyGroupsInitialState extends GetMyGroupsState {
  GetMyGroupsInitialState();
}

class GetMyGroupsLoadingState extends GetMyGroupsState {
  GetMyGroupsLoadingState();
}

class GetMyGroupsSuccessState extends GetMyGroupsState {
  final List<dynamic> groups;
  GetMyGroupsSuccessState({
    required this.groups,
  });
}

class GetMyGroupsFailureState extends GetMyGroupsState {
  final String error;
  GetMyGroupsFailureState({required this.error});
}

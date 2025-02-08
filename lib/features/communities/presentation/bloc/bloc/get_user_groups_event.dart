part of 'get_user_groups_bloc.dart';

abstract class GetUserGroupsEvent extends Equatable {}

class GetUserGroupsButtonPressedEvent extends GetUserGroupsEvent {
  GetUserGroupsButtonPressedEvent();

  @override
  List<Object?> get props => [];
}

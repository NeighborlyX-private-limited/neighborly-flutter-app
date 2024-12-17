part of 'add_remove_user_in_group_bloc.dart';

abstract class AddRemoveUserInGroupEvent extends Equatable {}

class AddUserInGroupButtonPressedEvent extends AddRemoveUserInGroupEvent {
  final String communityId;
  final String userId;

  AddUserInGroupButtonPressedEvent({
    required this.communityId,
    required this.userId,
  });

  @override
  List<Object?> get props => [
        communityId,
      ];
}

class RemoveUserInGroupButtonPressedEvent extends AddRemoveUserInGroupEvent {
  final String communityId;
  final String userId;

  RemoveUserInGroupButtonPressedEvent({
    required this.communityId,
    required this.userId,
  });

  @override
  List<Object?> get props => [
        communityId,
      ];
}

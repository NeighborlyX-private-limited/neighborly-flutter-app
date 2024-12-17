part of 'make_remove_admin_bloc.dart';

abstract class MakeRemoveAdminEvent extends Equatable {}

/// make admin event
class MakeAdminButtonPressedEvent extends MakeRemoveAdminEvent {
  final String communityId;
  final String userId;

  MakeAdminButtonPressedEvent({
    required this.communityId,
    required this.userId,
  });

  @override
  List<Object?> get props => [
        communityId,
      ];
}

/// remove admin event
class RemoveAdminButtonPressedEvent extends MakeRemoveAdminEvent {
  final String communityId;
  final String userId;

  RemoveAdminButtonPressedEvent({
    required this.communityId,
    required this.userId,
  });

  @override
  List<Object?> get props => [
        communityId,
      ];
}

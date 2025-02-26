part of 'join_group_bloc.dart';

abstract class JoinGroupEvent extends Equatable {}

// JOIN GROUP
class JoinGroupButtonPressedEvent extends JoinGroupEvent {
  final String communityId;

  JoinGroupButtonPressedEvent({
    required this.communityId,
  });

  @override
  List<Object?> get props => [
        communityId,
      ];
}

// LEAVE GROUP
class LeaveGroupButtonPressedEvent extends JoinGroupEvent {
  final String communityId;
  final String? userId;
  final bool isRemove;

  LeaveGroupButtonPressedEvent({
    required this.communityId,
    this.userId,
    this.isRemove = false,
  });

  @override
  List<Object?> get props => [
        communityId,
        userId,
        isRemove,
      ];
}

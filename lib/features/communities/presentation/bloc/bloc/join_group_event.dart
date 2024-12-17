part of 'join_group_bloc.dart';

abstract class JoinGroupEvent extends Equatable {}

/// join group event trigger
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

/// leave group event trigger
class LeaveGroupButtonPressedEvent extends JoinGroupEvent {
  final String communityId;

  LeaveGroupButtonPressedEvent({
    required this.communityId,
  });

  @override
  List<Object?> get props => [
        communityId,
      ];
}

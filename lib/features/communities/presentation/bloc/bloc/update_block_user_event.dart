part of 'update_block_user_bloc.dart';

abstract class UpdateBlockUserEvent extends Equatable {}

class UpdateBlockUserButtonPressedEvent extends UpdateBlockUserEvent {
  final String communityId;
  final String userId;
  final bool isBlock;

  UpdateBlockUserButtonPressedEvent({
    required this.communityId,
    required this.userId,
    required this.isBlock,
  });

  @override
  List<Object?> get props => [
        communityId,
      ];
}

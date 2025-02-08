part of 'update_mute_group_bloc.dart';

abstract class UpdateMuteGroupEvent extends Equatable {}

class UpdateMuteGroupButtonPressedEvent extends UpdateMuteGroupEvent {
  final String communityId;
  final bool isMute;

  UpdateMuteGroupButtonPressedEvent({
    required this.communityId,
    required this.isMute,
  });

  @override
  List<Object?> get props => [
        communityId,
      ];
}

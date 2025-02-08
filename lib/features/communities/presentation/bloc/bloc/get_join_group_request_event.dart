part of 'get_join_group_request_bloc.dart';

abstract class GetJoinGroupRequestEvent extends Equatable {}

class FeatchJoinGroupRequestEvent extends GetJoinGroupRequestEvent {
  final String communityId;

  FeatchJoinGroupRequestEvent({
    required this.communityId,
  });

  @override
  List<Object?> get props => [
        communityId,
      ];
}

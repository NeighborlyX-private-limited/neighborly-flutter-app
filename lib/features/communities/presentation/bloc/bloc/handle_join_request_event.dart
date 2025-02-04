part of 'handle_join_request_bloc.dart';

abstract class HandleJoinRequestEvent extends Equatable {}

class HandleGroupJoinRequestEvent extends HandleJoinRequestEvent {
  final String communityId;
  final String requestId;
  final String status;

  HandleGroupJoinRequestEvent({
    required this.communityId,
    required this.requestId,
    required this.status,
  });

  @override
  List<Object?> get props => [
        communityId,
        requestId,
        status,
      ];
}

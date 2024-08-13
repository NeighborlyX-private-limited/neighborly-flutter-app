part of 'get_comments_by_postId_bloc.dart';

abstract class GetCommentsByPostIdEvent extends Equatable {}

class GetCommentsByPostIdButtonPressedEvent extends GetCommentsByPostIdEvent {
  final num postId;
  GetCommentsByPostIdButtonPressedEvent({
    required this.postId,
  });

  @override
  List<Object?> get props => [
        postId,
      ];
}

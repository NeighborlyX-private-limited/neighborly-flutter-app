part of 'get_comments_by_postId_bloc.dart';

abstract class GetCommentsByPostIdEvent extends Equatable {}

class GetCommentsByPostIdButtonPressedEvent extends GetCommentsByPostIdEvent {
  final num postId;
  final String commentId;
  GetCommentsByPostIdButtonPressedEvent({
    required this.postId,
    required this.commentId,
  });

  @override
  List<Object?> get props => [
        postId,
        commentId,
      ];
}

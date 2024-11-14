part of 'get_comments_by_commentId_bloc.dart';

abstract class GetCommentByCommentIdEvent extends Equatable {}

class GetCommentByCommentIdButtonPressedEvent
    extends GetCommentByCommentIdEvent {
  final String commentId;

  GetCommentByCommentIdButtonPressedEvent({
    required this.commentId,
  });

  @override
  List<Object?> get props => [
        commentId,
      ];
}

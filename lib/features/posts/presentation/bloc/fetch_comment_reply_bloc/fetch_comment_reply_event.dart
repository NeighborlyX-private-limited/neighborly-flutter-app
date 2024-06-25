part of 'fetch_comment_reply_bloc.dart';

abstract class FetchCommentReplyEvent extends Equatable {}

class FetchCommentReplyButtonPressedEvent extends FetchCommentReplyEvent {
  final num commentId;
  FetchCommentReplyButtonPressedEvent({
    required this.commentId,
  });

  @override
  List<Object?> get props => [
        commentId,
      ];
}

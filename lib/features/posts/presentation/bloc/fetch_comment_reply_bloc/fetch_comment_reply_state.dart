part of 'fetch_comment_reply_bloc.dart';

abstract class FetchCommentReplyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCommentReplyInitialState extends FetchCommentReplyState {
  FetchCommentReplyInitialState();
}

class FetchCommentReplyLoadingState extends FetchCommentReplyState {
  final num commentId;
  FetchCommentReplyLoadingState({required this.commentId});
}

class FetchCommentReplySuccessState extends FetchCommentReplyState {
  final List<ReplyEntity> reply;
  final num commentId;
  FetchCommentReplySuccessState({
    required this.reply,
    required this.commentId,
  });
}

class FetchCommentReplyFailureState extends FetchCommentReplyState {
  final String error;
  final num commentId;
  FetchCommentReplyFailureState({required this.error, required this.commentId});
}

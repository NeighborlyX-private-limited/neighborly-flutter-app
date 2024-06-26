part of 'fetch_comment_reply_bloc.dart';

abstract class FetchCommentReplyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCommentReplyInitialState extends FetchCommentReplyState {
  FetchCommentReplyInitialState();
}

class FetchCommentReplyLoadingState extends FetchCommentReplyState {
  FetchCommentReplyLoadingState();
}

class FetchCommentReplySuccessState extends FetchCommentReplyState {
  final List<ReplyEntity> reply;
  FetchCommentReplySuccessState({
    required this.reply,
  });
}

class FetchCommentReplyFailureState extends FetchCommentReplyState {
  final String error;
  FetchCommentReplyFailureState({required this.error});
}

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
  FetchCommentReplySuccessState();
}

class FetchCommentReplyFailureState extends FetchCommentReplyState {
  final String error;
  FetchCommentReplyFailureState({required this.error});
}

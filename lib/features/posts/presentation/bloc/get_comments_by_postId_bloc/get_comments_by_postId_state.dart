part of 'get_comments_by_postId_bloc.dart';

abstract class GetCommentsByPostIdState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetcommentsByPostIdInitialState extends GetCommentsByPostIdState {
  GetcommentsByPostIdInitialState();
}

class GetcommentsByPostIdLoadingState extends GetCommentsByPostIdState {
  GetcommentsByPostIdLoadingState();
}

class GetcommentsByPostIdSuccessState extends GetCommentsByPostIdState {
  final List<CommentEntity> comments;
  GetcommentsByPostIdSuccessState({
    required this.comments,
  });
}

class GetcommentsByPostIdFailureState extends GetCommentsByPostIdState {
  final String error;
  GetcommentsByPostIdFailureState({required this.error});
}

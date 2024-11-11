part of 'get_comments_by_commentId_bloc.dart';

abstract class GetCommentByCommentIdState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCommentByCommentIdInitialState extends GetCommentByCommentIdState {
  GetCommentByCommentIdInitialState();
}

class GetCommentByCommentIdLoadingState extends GetCommentByCommentIdState {
  GetCommentByCommentIdLoadingState();
}

class GetCommentByCommentIdSuccessState extends GetCommentByCommentIdState {
  final SpecificCommentModel comment;
  GetCommentByCommentIdSuccessState({
    required this.comment,
  });
}

class GetCommentByCommentIdFailureState extends GetCommentByCommentIdState {
  final String error;
  GetCommentByCommentIdFailureState({required this.error});
}

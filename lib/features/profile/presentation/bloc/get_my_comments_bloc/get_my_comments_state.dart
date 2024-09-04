part of 'get_my_comments_bloc.dart';

abstract class GetMyCommentsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetMyCommentsInitialState extends GetMyCommentsState {
  GetMyCommentsInitialState();
}

class GetMyCommentsLoadingState extends GetMyCommentsState {
  GetMyCommentsLoadingState();
}

class GetMyCommentsSuccessState extends GetMyCommentsState {
  final List<PostWithCommentsEntity> post;
  GetMyCommentsSuccessState({
    required this.post,
  });
}

class GetMyCommentsFailureState extends GetMyCommentsState {
  final String error;
  GetMyCommentsFailureState({required this.error});
}

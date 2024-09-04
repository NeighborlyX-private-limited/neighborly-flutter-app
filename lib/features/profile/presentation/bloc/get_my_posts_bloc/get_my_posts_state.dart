part of 'get_my_posts_bloc.dart';

abstract class GetMyPostsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetMyPostsInitialState extends GetMyPostsState {
  GetMyPostsInitialState();
}

class GetMyPostsLoadingState extends GetMyPostsState {
  GetMyPostsLoadingState();
}

class GetMyPostsSuccessState extends GetMyPostsState {
  final List<PostEntity> post;
  GetMyPostsSuccessState({
    required this.post,
  });
}

class GetMyPostsFailureState extends GetMyPostsState {
  final String error;
  GetMyPostsFailureState({required this.error});
}

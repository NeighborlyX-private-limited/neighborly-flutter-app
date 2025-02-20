part of 'get_all_posts_bloc.dart';

abstract class GetAllPostsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllPostsInitialState extends GetAllPostsState {
  GetAllPostsInitialState();
}

class GetAllPostsLoadingState extends GetAllPostsState {
  GetAllPostsLoadingState();
}

class GetAllPostsSuccessState extends GetAllPostsState {
  final List<PostEntity> post;
  GetAllPostsSuccessState({
    required this.post,
  });
}

class GetAllPostsFailureState extends GetAllPostsState {
  final String error;
  GetAllPostsFailureState({required this.error});
}

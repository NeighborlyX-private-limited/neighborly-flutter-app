part of 'get_post_by_id_bloc.dart';

abstract class GetPostByIdState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPostByIdInitialState extends GetPostByIdState {
  GetPostByIdInitialState();
}

class GetPostByIdLoadingState extends GetPostByIdState {
  GetPostByIdLoadingState();
}

class GetPostByIdSuccessState extends GetPostByIdState {
  final PostEntity post;
  GetPostByIdSuccessState({
    required this.post,
  });
}

class GetPostByIdFailureState extends GetPostByIdState {
  final String error;
  GetPostByIdFailureState({required this.error});
}

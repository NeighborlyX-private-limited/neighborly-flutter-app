import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/entities/post_enitity.dart';
import '../../../domain/usecases/get_all_posts_usecase.dart';

part 'get_all_posts_event.dart';
part 'get_all_posts_state.dart';

class GetAllPostsBloc extends Bloc<GetAllPostsEvent, GetAllPostsState> {
  final GetAllPostsUsecase _getAllPostsUsecase;

  GetAllPostsBloc({required GetAllPostsUsecase getAllPostsUsecase})
      : _getAllPostsUsecase = getAllPostsUsecase,
        super(GetAllPostsInitialState()) {
    on<GetAllPostsButtonPressedEvent>((GetAllPostsButtonPressedEvent event,
        Emitter<GetAllPostsState> emit) async {
      emit(GetAllPostsLoadingState());

      final result = await _getAllPostsUsecase.call(
        isHome: event.isHome,
      );

      result.fold(
          (error) => emit(GetAllPostsFailureState(error: error.toString())),
          (response) => emit(GetAllPostsSuccessState(post: response)));
    });
    // on<DeleteOnePostsButtonPressedEvent>((DeleteOnePostsButtonPressedEvent event,
    //     Emitter<GetAllPostsState> emit) async {
    //    List<PostEntity> oldPost = List<PostEntity>.from(state.post);
    //    print('old post ${oldPost.length}');
    //    oldPost.removeWhere((item) => item.id == event.postId);
    //   //List<PostEntity> updatedpost = oldPost.forEach((e)=> e.id != event.postId);
    //   print('new post ${oldPost.length}');
    //   emit(GetAllPostsSuccessState(post: oldPost));
    // });
  }

  void deletepost(num postid){
    if (state is GetAllPostsSuccessState) {
      final successState = state as GetAllPostsSuccessState;
        List<PostEntity> oldPost = List<PostEntity>.from(successState.post);
       oldPost.removeWhere((item) => item.id == postid);
      emit(GetAllPostsSuccessState(post: oldPost));
    }
  }
}

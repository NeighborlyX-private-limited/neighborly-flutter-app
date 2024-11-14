import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_my_groups_usecase.dart';

part 'get_my_groups_event.dart';
part 'get_my_groups_state.dart';

class GetMyGroupsBloc extends Bloc<GetMyGroupsEvent, GetMyGroupsState> {
  final GetMyGroupUsecase _getMyGroupsUsecase;

  GetMyGroupsBloc({required GetMyGroupUsecase getMyGroupsUsecase})
      : _getMyGroupsUsecase = getMyGroupsUsecase,
        super(GetMyGroupsInitialState()) {
    on<GetMyGroupsButtonPressedEvent>((
      GetMyGroupsButtonPressedEvent event,
      Emitter<GetMyGroupsState> emit,
    ) async {
      emit(GetMyGroupsLoadingState());

      final result = await _getMyGroupsUsecase.call(
        userId: event.userId,
      );
      print('...Result in GetMyGroupsBloc: $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(GetMyGroupsFailureState(error: error.toString()));
      }, (response) {
        print('fold response: ${response.toString()}');
        emit(GetMyGroupsSuccessState(groups: response));
      });
    });
  }

  void deletepost(num postid) {
    print('delete post : ${state.props}');
    // List<PostEntity> oldPost = List<PostEntity>.from(state.props);
    // print('old post ${oldPost.length}');
    //  oldPost.removeWhere((item) => item.id == postid);
    // //List<PostEntity> updatedpost = oldPost.forEach((e)=> e.id != event.postId);
    // print('new post ${oldPost.length}');
    // emit(GetAllPostsSuccessState(post: oldPost));
  }
}

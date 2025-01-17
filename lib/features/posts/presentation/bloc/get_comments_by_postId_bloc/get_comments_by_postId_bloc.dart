import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/comment_entity.dart';
import '../../../domain/usecases/get_comments_by_postid_usecase.dart';
part 'get_comments_by_postId_event.dart';
part 'get_comments_by_postId_state.dart';

class GetCommentsByPostIdBloc
    extends Bloc<GetCommentsByPostIdEvent, GetCommentsByPostIdState> {
  final GetCommentsByPostIdUsecase _getCommentsByPostIdUsecase;
   bool isLastPage = false;
  int pageNumber = 1;
  int totalComments = 0;
 // final int nextPageTrigger = 3;

  GetCommentsByPostIdBloc(
      {required GetCommentsByPostIdUsecase getCommentsByPostIdUsecase})
      : _getCommentsByPostIdUsecase = getCommentsByPostIdUsecase,
        super(GetcommentsByPostIdInitialState()) {
    on<GetCommentsByPostIdButtonPressedEvent>(
        (GetCommentsByPostIdButtonPressedEvent event,
            Emitter<GetCommentsByPostIdState> emit) async {
               if (isLastPage) return;
      emit(GetcommentsByPostIdLoadingState());
      

      final result = await _getCommentsByPostIdUsecase.call(
        id: event.postId,
        commentId: event.commentId,
        page: pageNumber,
        
      );
      print('...Result in GetCommentsByPostIdBloc $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(GetcommentsByPostIdFailureState(error: error.toString()));
      }, (response) {
         if (response.isEmpty) {
          isLastPage = true;
        } else {
          pageNumber++;
         // totalComments = response.total;
        }
        print('fold response: ${response.toString()}');
        emit(GetcommentsByPostIdSuccessState(comments: response, ));
      });
    });
  }

  void deleteComment(num commentid) {
    print("delete post $state");
    if (state is GetcommentsByPostIdSuccessState) {
      print("delete post inside state");
      final successState = state as GetcommentsByPostIdSuccessState;
      emit(GetcommentsByPostIdLoadingState());
      List<CommentEntity> oldPost =
          List<CommentEntity>.from(successState.comments);
      print("old comments length ${oldPost.length}");
      oldPost.removeWhere((item) => item.commentid == commentid);
      print("old comment agains length ${oldPost.length}");
      emit(GetcommentsByPostIdSuccessState(comments: oldPost));
    }
  }
}

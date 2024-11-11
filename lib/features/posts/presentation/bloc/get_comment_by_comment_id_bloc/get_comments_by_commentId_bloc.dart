import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/data/model/specific_comment_model.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/get_comment_by_comment_id.dart';

part 'get_comments_by_commentId_event.dart';
part 'get_comments_by_commentId_state.dart';

class GetCommentByCommentIdBloc
    extends Bloc<GetCommentByCommentIdEvent, GetCommentByCommentIdState> {
  final GetCommentByCommentIdUsecase _commentByCommentIdUsecase;

  GetCommentByCommentIdBloc(
      {required GetCommentByCommentIdUsecase commentByCommentIdUsecase})
      : _commentByCommentIdUsecase = commentByCommentIdUsecase,
        super(GetCommentByCommentIdInitialState()) {
    on<GetCommentByCommentIdButtonPressedEvent>(
        (GetCommentByCommentIdButtonPressedEvent event,
            Emitter<GetCommentByCommentIdState> emit) async {
      emit(GetCommentByCommentIdLoadingState());

      final result = await _commentByCommentIdUsecase.call(
        id: event.commentId,
      );
      print('...Result in GetCommentByCommentIdBloc $result');
      //print('fold error: ${error.toString()}');
      //print('fold response: ${response.toString()}');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(GetCommentByCommentIdFailureState(error: error.toString()));
      }, (response) {
        print('fold response: ${response.toString()}');
        emit(GetCommentByCommentIdSuccessState(comment: response));
      });
    });
  }
}

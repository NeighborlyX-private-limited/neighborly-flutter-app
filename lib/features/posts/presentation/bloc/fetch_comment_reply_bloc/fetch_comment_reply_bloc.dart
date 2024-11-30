import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/reply_entity.dart';
import '../../../domain/usecases/fetch_comment_reply_usecase.dart';

part 'fetch_comment_reply_event.dart';
part 'fetch_comment_reply_state.dart';

class FetchCommentReplyBloc
    extends Bloc<FetchCommentReplyEvent, FetchCommentReplyState> {
  final FetchCommentReplyUsecase _fetchCommentReplyUsecase;

  FetchCommentReplyBloc(
      {required FetchCommentReplyUsecase fetchCommentReplyUsecase})
      : _fetchCommentReplyUsecase = fetchCommentReplyUsecase,
        super(FetchCommentReplyInitialState()) {
    on<FetchCommentReplyButtonPressedEvent>(
      (FetchCommentReplyButtonPressedEvent event,
          Emitter<FetchCommentReplyState> emit) async {
        emit(FetchCommentReplyLoadingState(commentId: event.commentId));

        final result = await _fetchCommentReplyUsecase.call(
          commentId: event.commentId,
        );
        print('...Result in FetchCommentReplyBloc $result');

        result.fold(
          (error) {
            print('fold error: ${error.toString()}');
            emit(
              FetchCommentReplyFailureState(
                error: error.toString(),
                commentId: event.commentId,
              ),
            );
          },
          (response) {
            print('fold response: ${response.toString()}');

            emit(
              FetchCommentReplySuccessState(
                reply: response,
                commentId: event.commentId,
              ),
            );
          },
        );
      },
    );
  }
}

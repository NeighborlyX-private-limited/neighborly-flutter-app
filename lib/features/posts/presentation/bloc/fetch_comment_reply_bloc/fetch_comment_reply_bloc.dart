import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/fetch_comment_reply_usecase.dart';

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
      emit(FetchCommentReplyLoadingState());

      final result = await _fetchCommentReplyUsecase.call(
        commentId: event.commentId,
      );

      result.fold(
          (error) =>
              emit(FetchCommentReplyFailureState(error: error.toString())),
          (response) => emit(FetchCommentReplySuccessState()));
    });
  }
}

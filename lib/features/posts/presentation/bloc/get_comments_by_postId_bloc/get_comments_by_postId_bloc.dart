import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/comment_entity.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/get_comments_by_postid_usecase.dart';

part 'get_comments_by_postId_event.dart';
part 'get_comments_by_postId_state.dart';

class GetCommentsByPostIdBloc extends Bloc<GetCommentsByPostIdEvent, GetCommentsByPostIdState> {
  final GetCommentsByPostIdUsecase _getCommentsByPostIdUsecase;

  GetCommentsByPostIdBloc({required GetCommentsByPostIdUsecase getCommentsByPostIdUsecase})
      : _getCommentsByPostIdUsecase = getCommentsByPostIdUsecase,
        super(GetcommentsByPostIdInitialState()) {
    on<GetCommentsByPostIdButtonPressedEvent>((GetCommentsByPostIdButtonPressedEvent event,
        Emitter<GetCommentsByPostIdState> emit) async {
      emit(GetcommentsByPostIdLoadingState());

      final result = await _getCommentsByPostIdUsecase.call(
        id: event.postId,
      );

      result.fold(
          (error) => emit(GetcommentsByPostIdFailureState(error: error.toString())),
          (response) => emit(GetcommentsByPostIdSuccessState(comments: response)));
    });
  }
}

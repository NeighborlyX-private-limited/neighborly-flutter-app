import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/domain/entities/post_with_comments_entity.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/get_my_comments_usecase.dart';



part 'get_my_comments_event.dart';
part 'get_my_comments_state.dart';

class GetMyCommentsBloc extends Bloc<GetMyCommentsEvent, GetMyCommentsState> {
  final GetMyCommentsUsecase _getMyCommentsUsecase;

  GetMyCommentsBloc({required GetMyCommentsUsecase getMyCommentsUsecase})
      : _getMyCommentsUsecase = getMyCommentsUsecase,
        super(GetMyCommentsInitialState()) {
    on<GetMyCommentsButtonPressedEvent>((GetMyCommentsButtonPressedEvent event,
        Emitter<GetMyCommentsState> emit) async {
      emit(GetMyCommentsLoadingState());

      final result = await _getMyCommentsUsecase.call(
        userId: event.userId,
      );

      result.fold(
          (error) => emit(GetMyCommentsFailureState(error: error.toString())),
          (response) => emit(GetMyCommentsSuccessState(post: response)));
    });
  }
}

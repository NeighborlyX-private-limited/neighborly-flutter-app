import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/entities/post_enitity.dart';
import '../../../domain/usecases/get_my_posts_usecase.dart';
part 'get_my_posts_event.dart';
part 'get_my_posts_state.dart';

class GetMyPostsBloc extends Bloc<GetMyPostsEvent, GetMyPostsState> {
  final GetMyPostsUsecase _getMyPostsUsecase;

  GetMyPostsBloc({required GetMyPostsUsecase getMyPostsUsecase})
      : _getMyPostsUsecase = getMyPostsUsecase,
        super(GetMyPostsInitialState()) {
    on<GetMyPostsButtonPressedEvent>((
      GetMyPostsButtonPressedEvent event,
      Emitter<GetMyPostsState> emit,
    ) async {
      emit(GetMyPostsLoadingState());

      final result = await _getMyPostsUsecase.call(
        userId: event.userId,
      );
      print('...Result in GetMyPostsBloc: $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(GetMyPostsFailureState(error: error.toString()));
      }, (response) {
        print('fold response: ${response.toString()}');
        emit(GetMyPostsSuccessState(post: response));
      });
    });
  }
}

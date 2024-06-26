import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/get_all_posts_usecase.dart';

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
  }
}

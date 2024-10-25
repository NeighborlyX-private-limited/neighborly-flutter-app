import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/entities/post_enitity.dart';
import '../../../domain/usecases/get_post_by_id_usecase.dart';

part 'get_post_by_id_event.dart';
part 'get_post_by_id_state.dart';

class GetPostByIdBloc extends Bloc<GetPostByIdEvent, GetPostByIdState> {
  final GetPostByIdUsecase _getPostByIdUsecase;

  GetPostByIdBloc({required GetPostByIdUsecase getPostByIdUsecase})
      : _getPostByIdUsecase = getPostByIdUsecase,
        super(GetPostByIdInitialState()) {
    on<GetPostByIdButtonPressedEvent>((GetPostByIdButtonPressedEvent event,
        Emitter<GetPostByIdState> emit) async {
      emit(GetPostByIdLoadingState());

      final result = await _getPostByIdUsecase.call(
        id: event.postId,
      );
      print('...Result in GetPostByIdBloc $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(GetPostByIdFailureState(error: error.toString()));
      }, (response) {
        print('fold response: ${response.toString()}');
        emit(GetPostByIdSuccessState(post: response));
      });
    });
  }
}

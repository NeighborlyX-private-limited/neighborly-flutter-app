import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/delete_post_usecase.dart';

part 'delete_post_event.dart';
part 'delete_post_state.dart';

class DeletePostBloc extends Bloc<DeletePostEvent, DeletePostState> {
  final DeletePostUsecase _deletePostUsecase;

  DeletePostBloc({required DeletePostUsecase deletePostUsecase})
      : _deletePostUsecase = deletePostUsecase,
        super(DeletePostInitialState()) {
    on<DeletePostButtonPressedEvent>((DeletePostButtonPressedEvent event,
        Emitter<DeletePostState> emit) async {
      emit(DeletePostLoadingState());

      final result = await _deletePostUsecase.call(
        id: event.postId,
        type: event.type,
      );
      print('...Result in DeletePostBloc $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(DeletePostFailureState(error: error.toString()));
      }, (response) {
        //  print('fold response: ${response.toString()}');
        emit(DeletePostSuccessState());
      });
    });
  }
}

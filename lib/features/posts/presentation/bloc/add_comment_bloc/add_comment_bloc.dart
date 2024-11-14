import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_comment_usecase.dart';
part 'add_comment_event.dart';
part 'add_comment_state.dart';

class AddCommentBloc extends Bloc<AddCommentEvent, AddCommentState> {
  final AddCommentUsecase _addCommentUsecase;

  AddCommentBloc({required AddCommentUsecase addCommentUsecase})
      : _addCommentUsecase = addCommentUsecase,
        super(AddCommentInitialState()) {
    on<AddCommentButtonPressedEvent>((AddCommentButtonPressedEvent event,
        Emitter<AddCommentState> emit) async {
      emit(AddCommentLoadingState());

      final result = await _addCommentUsecase.call(
        id: event.postId,
        text: event.text,
        commentId: event.commentId,
      );
      print('...Result in ForgotPasswordBloc $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(AddCommentFailureState(error: error.toString()));
      }, (response) {
        // print('fold response: ${response.toString()}');
        emit(AddCommentSuccessState());
      });
    });
  }
}

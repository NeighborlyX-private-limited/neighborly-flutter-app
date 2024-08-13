import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/feedback_usecase.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FeedbackUsecase _feedbackUsecase;

  FeedbackBloc({required FeedbackUsecase feedbackUsecase})
      : _feedbackUsecase = feedbackUsecase,
        super(FeedbackInitialState()) {
    on<FeedbackButtonPressedEvent>(
        (FeedbackButtonPressedEvent event, Emitter<FeedbackState> emit) async {
      emit(FeedbackLoadingState());

      final result = await _feedbackUsecase.call(
          id: event.postId, feedback: event.feedback, type: event.type);

      result.fold(
          (error) => emit(FeedbackFailureState(error: error.toString())),
          (response) => emit(FeedbackSuccessState()));
    });
  }
}

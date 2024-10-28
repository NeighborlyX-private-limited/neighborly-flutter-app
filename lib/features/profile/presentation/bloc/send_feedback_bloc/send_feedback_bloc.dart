import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/send_feedback_usecase.dart';

part 'send_feedback_event.dart';
part 'send_feedback_state.dart';

class SendFeedbackBloc extends Bloc<SendFeedbackEvent, SendFeedbackState> {
  final SendFeedbackUsecase _sendFeedbackUsecase;

  SendFeedbackBloc({required SendFeedbackUsecase sendFeedbackUsecase})
      : _sendFeedbackUsecase = sendFeedbackUsecase,
        super(SendFeedbackInitialState()) {
    on<SendFeedbackEventButtonPressedEvent>((
      SendFeedbackEventButtonPressedEvent event,
      Emitter<SendFeedbackState> emit,
    ) async {
      emit(SendFeedbackLoadingState());

      final result = await _sendFeedbackUsecase.call(
        feedback: event.feedback,
      );
      print('...Result in SendFeedbackBloc: $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(SendFeedbackFailureState(error: error.toString()));
      }, (response) {
        // print('fold response: ${response.toString()}');
        emit(SendFeedbackSuccessState());
      });
    });
  }
}

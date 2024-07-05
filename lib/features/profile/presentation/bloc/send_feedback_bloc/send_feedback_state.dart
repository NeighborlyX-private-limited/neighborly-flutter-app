part of 'send_feedback_bloc.dart';

abstract class SendFeedbackState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendFeedbackInitialState extends SendFeedbackState {
  SendFeedbackInitialState();
}

class SendFeedbackLoadingState extends SendFeedbackState {
  SendFeedbackLoadingState();
}

class SendFeedbackSuccessState extends SendFeedbackState {
  SendFeedbackSuccessState();
}

class SendFeedbackFailureState extends SendFeedbackState {
  final String error;
  SendFeedbackFailureState({required this.error});
}

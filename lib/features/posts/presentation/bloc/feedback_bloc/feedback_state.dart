part of 'feedback_bloc.dart';

abstract class FeedbackState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeedbackInitialState extends FeedbackState {
  FeedbackInitialState();
}

class FeedbackLoadingState extends FeedbackState {
  FeedbackLoadingState();
}

class FeedbackSuccessState extends FeedbackState {
  FeedbackSuccessState();
}

class FeedbackFailureState extends FeedbackState {
  final String error;
  FeedbackFailureState({required this.error});
}

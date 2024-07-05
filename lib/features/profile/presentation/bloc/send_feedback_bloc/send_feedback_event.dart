part of 'send_feedback_bloc.dart';

abstract class SendFeedbackEvent extends Equatable {}

class SendFeedbackEventButtonPressedEvent extends SendFeedbackEvent {
  final String feedback;

  SendFeedbackEventButtonPressedEvent({
    required this.feedback,
  });

  @override
  List<Object?> get props => [
        feedback,
      ];
}

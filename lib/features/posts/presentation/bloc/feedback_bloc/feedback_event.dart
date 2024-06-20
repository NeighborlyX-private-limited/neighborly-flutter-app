part of 'feedback_bloc.dart';

abstract class FeedbackEvent extends Equatable {}

class FeedbackButtonPressedEvent extends FeedbackEvent {
  final num postId;
  final String type;
  final String feedback;

  FeedbackButtonPressedEvent({
    required this.postId,
    required this.type,
    required this.feedback,
  });

  @override
  List<Object?> get props => [postId, type, feedback];
}

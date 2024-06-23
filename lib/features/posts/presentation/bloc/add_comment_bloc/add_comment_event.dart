part of 'add_comment_bloc.dart';

abstract class AddCommentEvent extends Equatable {}

class AddCommentButtonPressedEvent extends AddCommentEvent {
  final num postId;
  final String text;
  AddCommentButtonPressedEvent({
    required this.postId,
    required this.text,
  });

  @override
  List<Object?> get props => [
        postId,
        text,
      ];
}

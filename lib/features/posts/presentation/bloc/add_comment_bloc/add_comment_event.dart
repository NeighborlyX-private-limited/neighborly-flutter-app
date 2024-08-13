part of 'add_comment_bloc.dart';

abstract class AddCommentEvent extends Equatable {}

class AddCommentButtonPressedEvent extends AddCommentEvent {
  final num postId;
  final String text;
  num? commentId;
  AddCommentButtonPressedEvent({
    required this.postId,
    required this.text,
    this.commentId,
  });

  @override
  List<Object?> get props => [
        postId,
        text,
        commentId,
      ];
}

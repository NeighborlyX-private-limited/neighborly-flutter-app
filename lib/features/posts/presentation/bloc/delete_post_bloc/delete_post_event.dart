part of 'delete_post_bloc.dart';

abstract class DeletePostEvent extends Equatable {}

class DeletePostButtonPressedEvent extends DeletePostEvent {
  final num postId;
  DeletePostButtonPressedEvent({
    required this.postId,
  });

  @override
  List<Object?> get props => [
        postId,
      ];
}

part of 'delete_post_bloc.dart';

abstract class DeletePostEvent extends Equatable {}

class DeletePostButtonPressedEvent extends DeletePostEvent {
  final num postId;
  final String type;
  DeletePostButtonPressedEvent({
    required this.postId,
    required this.type,
  });

  @override
  List<Object?> get props => [
        postId,
      ];
}

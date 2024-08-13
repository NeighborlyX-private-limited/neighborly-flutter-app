part of 'get_post_by_id_bloc.dart';

abstract class GetPostByIdEvent extends Equatable {}

class GetPostByIdButtonPressedEvent extends GetPostByIdEvent {
  final num postId;
  GetPostByIdButtonPressedEvent({
    required this.postId,
  });

  @override
  List<Object?> get props => [
        postId,
      ];
}

part of 'get_my_posts_bloc.dart';

abstract class GetMyPostsEvent extends Equatable {}

class GetMyPostsButtonPressedEvent extends GetMyPostsEvent {
  final String? userId;
  GetMyPostsButtonPressedEvent({
    this.userId,
  });

  @override
  List<Object?> get props => [
        userId,
      ];
}

part of 'get_all_posts_bloc.dart';

abstract class GetAllPostsEvent extends Equatable {}

class GetAllPostsButtonPressedEvent extends GetAllPostsEvent {
  final bool isHome;
  GetAllPostsButtonPressedEvent({
    required this.isHome,
  });

  @override
  List<Object?> get props => [];
}

class DeleteOnePostsButtonPressedEvent extends GetAllPostsEvent {
  final num postId;
  final String type;
  DeleteOnePostsButtonPressedEvent({
    required this.postId,
    required this.type,
  });

  @override
  List<Object?> get props => [
        postId,
      ];
}

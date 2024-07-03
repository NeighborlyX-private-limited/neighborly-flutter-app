part of 'get_my_posts_bloc.dart';

abstract class GetMyPostsEvent extends Equatable {}

class GetMyPostsButtonPressedEvent extends GetMyPostsEvent {
  GetMyPostsButtonPressedEvent();

  @override
  List<Object?> get props => [];
}

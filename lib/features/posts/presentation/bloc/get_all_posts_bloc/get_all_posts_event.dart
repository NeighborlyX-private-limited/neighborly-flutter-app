part of 'get_all_posts_bloc.dart';

abstract class GetAllPostsEvent extends Equatable {}

class GetAllPostsButtonPressedEvent extends GetAllPostsEvent {
  GetAllPostsButtonPressedEvent();

  @override
  List<Object?> get props => [];
}

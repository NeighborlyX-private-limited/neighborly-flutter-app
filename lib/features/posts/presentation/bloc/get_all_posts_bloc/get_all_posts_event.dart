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

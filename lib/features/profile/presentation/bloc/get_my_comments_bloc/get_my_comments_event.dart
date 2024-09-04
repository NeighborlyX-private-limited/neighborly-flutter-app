part of 'get_my_comments_bloc.dart';

abstract class GetMyCommentsEvent extends Equatable {}

class GetMyCommentsButtonPressedEvent extends GetMyCommentsEvent {
  final String? userId;
  GetMyCommentsButtonPressedEvent({
    this.userId,
  });

  @override
  List<Object?> get props => [
        userId,
      ];
}

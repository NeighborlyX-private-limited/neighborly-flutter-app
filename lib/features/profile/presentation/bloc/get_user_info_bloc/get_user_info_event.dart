part of 'get_user_info_bloc.dart';

abstract class GetUserInfoEvent extends Equatable {}

class GetUserInfoButtonPressedEvent extends GetUserInfoEvent {
  final String userId;
  GetUserInfoButtonPressedEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [];
}

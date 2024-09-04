part of 'get_my_awards_bloc.dart';

abstract class GetMyAwardsEvent extends Equatable {}

class GetMyAwardsButtonPressedEvent extends GetMyAwardsEvent {
  GetMyAwardsButtonPressedEvent();

  @override
  List<Object?> get props => [];
}

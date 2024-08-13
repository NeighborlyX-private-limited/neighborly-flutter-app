part of 'get_profile_bloc.dart';

abstract class GetProfileEvent extends Equatable {}

class GetProfileButtonPressedEvent extends GetProfileEvent {
  GetProfileButtonPressedEvent();

  @override
  List<Object?> get props => [];
}

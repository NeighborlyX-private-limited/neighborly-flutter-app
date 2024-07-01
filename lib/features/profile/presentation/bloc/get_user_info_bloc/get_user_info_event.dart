part of 'get_user_info_bloc.dart';

abstract class GetUserInfoEvent extends Equatable {}

class GetUserInfoButtonPressedEvent extends GetUserInfoEvent {
  final String? gender;
  final String? dob;

  GetUserInfoButtonPressedEvent({
    this.gender,
    this.dob,
  });

  @override
  List<Object?> get props => [
        dob,
        gender,
      ];
}

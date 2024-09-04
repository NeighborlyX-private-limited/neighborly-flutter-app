part of 'get_gender_and_DOB_bloc.dart';

abstract class GetGenderAndDOBEvent extends Equatable {}

class GetGenderAndDOBButtonPressedEvent extends GetGenderAndDOBEvent {
  final String? gender;
  final String? dob;

  GetGenderAndDOBButtonPressedEvent({
    this.gender,
    this.dob,
  });

  @override
  List<Object?> get props => [
        dob,
        gender,
      ];
}

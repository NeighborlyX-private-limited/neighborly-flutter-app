part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {}

class EditProfileButtonPressedEvent extends EditProfileEvent {
  final String? username;
  final String? gender;
  final String? bio;
  final File? image;
  final String? phoneNumber;
  final bool? toggleFindMe;

  // final List<double> homeCoordinates;
  EditProfileButtonPressedEvent({
    this.username,
    this.gender,
    this.phoneNumber,
    this.toggleFindMe,
    this.bio,
    this.image,
    // required this.homeCoordinates,
  });

  @override
  List<Object?> get props => [
        username,
        gender,
        phoneNumber,
        toggleFindMe,
        bio,
        // homeCoordinates,
        image,
      ];
}

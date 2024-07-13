part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {}

class EditProfileButtonPressedEvent extends EditProfileEvent {
  final String username;
  final String gender;
  final String? bio;
  final File? image;
  // final List<double> homeCoordinates;
  EditProfileButtonPressedEvent({
    required this.username,
    required this.gender,
    this.bio,
    this.image,
    // required this.homeCoordinates,
  });

  @override
  List<Object?> get props => [
        username,
        gender,
        bio,
        // homeCoordinates,
        image,
      ];
}

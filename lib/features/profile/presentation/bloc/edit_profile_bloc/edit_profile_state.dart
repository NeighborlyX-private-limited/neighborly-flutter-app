part of 'edit_profile_bloc.dart';

abstract class EditProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditProfileInitialState extends EditProfileState {
  EditProfileInitialState();
}

class EditProfileLoadingState extends EditProfileState {
  EditProfileLoadingState();
}

class EditProfileSuccessState extends EditProfileState {
  EditProfileSuccessState();
}

class EditProfileFailureState extends EditProfileState {
  final String error;
  EditProfileFailureState({required this.error});
}

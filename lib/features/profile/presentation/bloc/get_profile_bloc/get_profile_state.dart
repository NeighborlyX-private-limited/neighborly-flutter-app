part of 'get_profile_bloc.dart';

abstract class GetProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProfileInitialState extends GetProfileState {
  GetProfileInitialState();
}

class GetProfileLoadingState extends GetProfileState {
  GetProfileLoadingState();
}

class GetProfileSuccessState extends GetProfileState {
  final AuthResponseEntity profile;
  GetProfileSuccessState({
    required this.profile,
  });
}

class GetProfileFailureState extends GetProfileState {
  final String error;
  GetProfileFailureState({required this.error});
}

part of 'get_user_info_bloc.dart';

abstract class GetUserInfoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUserInfoInitialState extends GetUserInfoState {
  GetUserInfoInitialState();
}

class GetUserInfoLoadingState extends GetUserInfoState {
  GetUserInfoLoadingState();
}

class GetUserInfoSuccessState extends GetUserInfoState {
  final AuthResponseEntity profile;
  GetUserInfoSuccessState({
    required this.profile,
  });
}

class GetUserInfoFailureState extends GetUserInfoState {
  final String error;
  GetUserInfoFailureState({required this.error});
}

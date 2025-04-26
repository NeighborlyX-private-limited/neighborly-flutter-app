part of 'nearby_user_bloc.dart';

sealed class NearbyUserState extends Equatable {
  const NearbyUserState();

  @override
  List<Object> get props => [];
}

final class NearbyUserInitialState extends NearbyUserState {}

final class NearbyUserLoadingState extends NearbyUserState {}

final class NearbyUserSuccessState extends NearbyUserState {
  final List<NearbyUserModel> nearbyUser;

  const NearbyUserSuccessState({required this.nearbyUser});
}

final class NearbyUserFailureState extends NearbyUserState {
  final String error;
  const NearbyUserFailureState({required this.error});
}

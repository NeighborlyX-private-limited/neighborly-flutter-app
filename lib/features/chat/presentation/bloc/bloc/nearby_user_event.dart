part of 'nearby_user_bloc.dart';

sealed class NearbyUserEvent extends Equatable {
  const NearbyUserEvent();

  @override
  List<Object> get props => [];
}

class FeatchNearbyUserEvent extends NearbyUserEvent {
  const FeatchNearbyUserEvent();
}

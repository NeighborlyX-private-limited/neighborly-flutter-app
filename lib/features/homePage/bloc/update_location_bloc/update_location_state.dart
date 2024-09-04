part of 'update_location_bloc.dart';

abstract class UpdateLocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateLocationInitialState extends UpdateLocationState {
  UpdateLocationInitialState();
}

class UpdateLocationLoadingState extends UpdateLocationState {
  UpdateLocationLoadingState();
}

class UpdateLocationSuccessState extends UpdateLocationState {
  UpdateLocationSuccessState();
}

class UpdateLocationFailureState extends UpdateLocationState {
  final String error;
  UpdateLocationFailureState({required this.error});
}

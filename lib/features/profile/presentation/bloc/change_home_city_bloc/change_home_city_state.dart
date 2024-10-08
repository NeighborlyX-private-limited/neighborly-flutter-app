// lib/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_state.dart

import 'package:equatable/equatable.dart';

// Base class for all City states
abstract class CityState extends Equatable {
  @override
  List<Object> get props => [];
}

// Initial state of the CityBloc
class CityInitialState extends CityState {}

// Loading state while city is being updated
class CityLoadingState extends CityState {}

// State when the city has been successfully updated
class CityUpdatedState extends CityState {
  final String city;

  CityUpdatedState(this.city);

  @override
  List<Object> get props => [city];
}

// Error state if updating the city fails
class CityErrorState extends CityState {
  final String errorMessage;

  CityErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

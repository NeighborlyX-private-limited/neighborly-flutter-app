import 'package:equatable/equatable.dart';

abstract class CityState extends Equatable {
  @override
  List<Object> get props => [];
}

class CityInitialState extends CityState {}

class CityLoadingState extends CityState {}

class CityUpdatedState extends CityState {
  final String city;

  CityUpdatedState(this.city);

  @override
  List<Object> get props => [city];
}

class CityErrorState extends CityState {
  final String errorMessage;

  CityErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

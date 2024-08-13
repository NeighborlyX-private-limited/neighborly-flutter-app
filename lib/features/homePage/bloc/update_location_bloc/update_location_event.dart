part of 'update_location_bloc.dart';

abstract class UpdateLocationEvent extends Equatable {}

class UpdateLocationButtonPressedEvent extends UpdateLocationEvent {
  final List<num> location;
  UpdateLocationButtonPressedEvent({
    required this.location,
  });

  @override
  List<Object?> get props => [location];
}

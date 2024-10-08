abstract class CityEvent {}

class UpdateCityEvent extends CityEvent {
  final String city;

  UpdateCityEvent(this.city);
}

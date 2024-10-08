import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/data/repositories/city_repositories.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_event.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final CityRepository cityRepository;

  CityBloc(this.cityRepository) : super(CityInitialState()) {
    // Register the event handler for UpdateCityEvent
    on<UpdateCityEvent>(_onUpdateCity);
  }

  // Handler method for UpdateCityEvent
  Future<void> _onUpdateCity(
      UpdateCityEvent event, Emitter<CityState> emit) async {
    emit(CityLoadingState()); // Emit loading state if needed

    try {
      // Call the repository to update the city
      await cityRepository.updateCity(event.city);

      // If successful, emit CityUpdatedState
      emit(CityUpdatedState(event.city));
    } catch (e) {
      // Emit CityErrorState if an error occurs
      emit(CityErrorState(e.toString()));
    }
  }
}

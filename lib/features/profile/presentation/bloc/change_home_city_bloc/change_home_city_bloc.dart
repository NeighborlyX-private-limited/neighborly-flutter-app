import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/data/repositories/city_repositories.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_event.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final CityRepository cityRepository;

  CityBloc(this.cityRepository) : super(CityInitialState()) {
    on<UpdateCityEvent>(_onUpdateCity);
  }

  Future<void> _onUpdateCity(
    UpdateCityEvent event,
    Emitter<CityState> emit,
  ) async {
    emit(CityLoadingState());

    try {
      await cityRepository.updateCity(event.city);

      emit(CityUpdatedState(event.city));
    } catch (e) {
      emit(CityErrorState(e.toString()));
    }
  }
}

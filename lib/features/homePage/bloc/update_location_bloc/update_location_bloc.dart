import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../profile/domain/usecases/update_location_usecase.dart';

part 'update_location_event.dart';
part 'update_location_state.dart';

class UpdateLocationBloc
    extends Bloc<UpdateLocationEvent, UpdateLocationState> {
  final UpdateLocationUsecase _updateLocationUsecase;

  UpdateLocationBloc({required UpdateLocationUsecase updateLocationUsecase})
      : _updateLocationUsecase = updateLocationUsecase,
        super(UpdateLocationInitialState()) {
    on<UpdateLocationButtonPressedEvent>((
      UpdateLocationButtonPressedEvent event,
      Emitter<UpdateLocationState> emit,
    ) async {
      emit(UpdateLocationLoadingState());

      final result =
          await _updateLocationUsecase.call(location: event.location);

      result.fold(
          (error) => emit(UpdateLocationFailureState(error: error.toString())),
          (response) => emit(UpdateLocationSuccessState()));
    });
  }
}

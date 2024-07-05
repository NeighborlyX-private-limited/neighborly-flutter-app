import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/get_gender_and_dob.dart';

part 'get_gender_and_DOB_event.dart';
part 'get_gender_and_DOB_state.dart';

class GetGenderAndDOBBloc
    extends Bloc<GetGenderAndDOBEvent, GetGenderAndDOBState> {
  final GetGenderAndDOBUsecase _getGenderAndDOBUsecase;

  GetGenderAndDOBBloc({required GetGenderAndDOBUsecase getGenderAndDOBUsecase})
      : _getGenderAndDOBUsecase = getGenderAndDOBUsecase,
        super(GetGenderAndDOBInitialState()) {
    on<GetGenderAndDOBButtonPressedEvent>(
        (GetGenderAndDOBButtonPressedEvent event,
            Emitter<GetGenderAndDOBState> emit) async {
      emit(GetGenderAndDOBLoadingState());

      final result = await _getGenderAndDOBUsecase.call(
        gender: event.gender,
        dob: event.dob,
      );

      result.fold(
          (error) => emit(GetGenderAndDOBFailureState(error: error.toString())),
          (response) => emit(GetGenderAndDOBSuccessState()));
    });
  }
}

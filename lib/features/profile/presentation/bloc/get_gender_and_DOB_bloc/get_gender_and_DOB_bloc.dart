import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_gender_and_dob.dart';

part 'get_gender_and_DOB_event.dart';
part 'get_gender_and_DOB_state.dart';

class GetGenderAndDOBBloc
    extends Bloc<GetGenderAndDOBEvent, GetGenderAndDOBState> {
  final GetGenderAndDOBUsecase _getGenderAndDOBUsecase;

  GetGenderAndDOBBloc({required GetGenderAndDOBUsecase getGenderAndDOBUsecase})
      : _getGenderAndDOBUsecase = getGenderAndDOBUsecase,
        super(GetGenderAndDOBInitialState()) {
    on<GetGenderAndDOBButtonPressedEvent>((
      GetGenderAndDOBButtonPressedEvent event,
      Emitter<GetGenderAndDOBState> emit,
    ) async {
      emit(GetGenderAndDOBLoadingState());

      final result = await _getGenderAndDOBUsecase.call(
        gender: event.gender,
        dob: event.dob,
      );
      print('...Result in GetGenderAndDOBBloc $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(GetGenderAndDOBFailureState(error: error.toString()));
      }, (response) {
        // print('fold response: ${response.toString()}');
        emit(GetGenderAndDOBSuccessState());
      });
    });
  }
}

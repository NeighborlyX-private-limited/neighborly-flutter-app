import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/entities/auth_response_entity.dart';
import '../../../domain/usecases/get_profile_usecase.dart';

part 'get_profile_event.dart';
part 'get_profile_state.dart';

class GetProfileBloc extends Bloc<GetProfileEvent, GetProfileState> {
  final GetProfileUsecase _getProfileUsecase;

  GetProfileBloc({required GetProfileUsecase getProfileUsecase})
      : _getProfileUsecase = getProfileUsecase,
        super(GetProfileInitialState()) {
    on<GetProfileButtonPressedEvent>((
      GetProfileButtonPressedEvent event,
      Emitter<GetProfileState> emit,
    ) async {
      emit(GetProfileLoadingState());

      final result = await _getProfileUsecase.call();
      print('...Result in GetProfileBloc: $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(GetProfileFailureState(error: error.toString()));
      }, (response) {
        print('fold response: ${response.toString()}');
        emit(GetProfileSuccessState(profile: response));
      });
    });
  }
}

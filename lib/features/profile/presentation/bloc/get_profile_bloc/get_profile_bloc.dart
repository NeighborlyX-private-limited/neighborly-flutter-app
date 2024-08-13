import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/entities/auth_response_entity.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/get_profile_usecase.dart';

part 'get_profile_event.dart';
part 'get_profile_state.dart';

class GetProfileBloc extends Bloc<GetProfileEvent, GetProfileState> {
  final GetProfileUsecase _getProfileUsecase;

  GetProfileBloc({required GetProfileUsecase getProfileUsecase})
      : _getProfileUsecase = getProfileUsecase,
        super(GetProfileInitialState()) {
    on<GetProfileButtonPressedEvent>((GetProfileButtonPressedEvent event,
        Emitter<GetProfileState> emit) async {
      emit(GetProfileLoadingState());

      final result = await _getProfileUsecase.call();

      result.fold(
          (error) => emit(GetProfileFailureState(error: error.toString())),
          (response) => emit(GetProfileSuccessState(profile: response)));
    });
  }
}

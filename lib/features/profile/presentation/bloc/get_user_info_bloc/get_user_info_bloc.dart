import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/get_user_info_usecase.dart';

part 'get_user_info_event.dart';
part 'get_user_info_state.dart';

class GetUserInfoBloc extends Bloc<GetUserInfoEvent, GetUserInfoState> {
  final GetUserInfoUsecase _getUserInfoUsecase;

  GetUserInfoBloc({required GetUserInfoUsecase getUserInfoUsecase})
      : _getUserInfoUsecase = getUserInfoUsecase,
        super(GetUserInfoInitialState()) {
    on<GetUserInfoButtonPressedEvent>((GetUserInfoButtonPressedEvent event,
        Emitter<GetUserInfoState> emit) async {
      emit(GetUserInfoLoadingState());

      final result = await _getUserInfoUsecase.call(
        gender: event.gender,
        dob: event.dob,
      );

      result.fold(
          (error) => emit(GetUserInfoFailureState(error: error.toString())),
          (response) => emit(GetUserInfoSuccessState()));
    });
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/entities/auth_response_entity.dart';
import '../../../domain/usecases/get_user_info_usecase.dart';

part 'get_user_info_event.dart';
part 'get_user_info_state.dart';

class GetUserInfoBloc extends Bloc<GetUserInfoEvent, GetUserInfoState> {
  final GetUserInfoUsecase _getUserInfoUsecase;

  GetUserInfoBloc({required GetUserInfoUsecase getUserInfoUsecase})
      : _getUserInfoUsecase = getUserInfoUsecase,
        super(GetUserInfoInitialState()) {
    on<GetUserInfoButtonPressedEvent>((
      GetUserInfoButtonPressedEvent event,
      Emitter<GetUserInfoState> emit,
    ) async {
      emit(GetUserInfoLoadingState());

      final result = await _getUserInfoUsecase.call(userId: event.userId);
      print('...Result in GetUserInfoBloc: $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(GetUserInfoFailureState(error: error.toString()));
      }, (response) {
        print('fold response: ${response.toString()}');
        emit(GetUserInfoSuccessState(profile: response));
      });
    });
  }
}

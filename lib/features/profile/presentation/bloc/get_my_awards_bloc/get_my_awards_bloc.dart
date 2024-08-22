import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_my_awards_usecase.dart';

part 'get_my_awards_event.dart';
part 'get_my_awards_state.dart';

class GetMyAwardsBloc extends Bloc<GetMyAwardsEvent, GetMyAwardsState> {
  final GetMyAwardsUsecase _getMyAwardsUsecase;

  GetMyAwardsBloc({required GetMyAwardsUsecase getMyAwardsUsecase})
      : _getMyAwardsUsecase = getMyAwardsUsecase,
        super(GetMyAwardsInitialState()) {
    on<GetMyAwardsButtonPressedEvent>((GetMyAwardsButtonPressedEvent event,
        Emitter<GetMyAwardsState> emit) async {
      emit(GetMyAwardsLoadingState());

      final result = await _getMyAwardsUsecase.call();

      result.fold(
          (error) => emit(GetMyAwardsFailureState(error: error.toString())),
          (response) => emit(GetMyAwardsSuccessState(awards: response)));
    });
  }
}

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
    on<GetMyAwardsButtonPressedEvent>((
      GetMyAwardsButtonPressedEvent event,
      Emitter<GetMyAwardsState> emit,
    ) async {
      emit(GetMyAwardsLoadingState());

      final result = await _getMyAwardsUsecase.call();
      print('...Result in GetMyAwardsBloc $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(GetMyAwardsFailureState(error: error.toString()));
      }, (response) {
        print('fold response: ${response.toString()}');
        emit(GetMyAwardsSuccessState(awards: response));
      });
    });
  }
}

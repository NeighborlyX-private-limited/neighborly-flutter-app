import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/vote_poll_usecase.dart';
part 'vote_poll_event.dart';
part 'vote_poll_state.dart';

class VotePollBloc extends Bloc<VotePollEvent, VotePollState> {
  final VotePollUsecase _votePollUsecase;

  VotePollBloc({required VotePollUsecase votePollUsecase})
      : _votePollUsecase = votePollUsecase,
        super(VotePollInitialState()) {
    on<VotePollButtonPressedEvent>(
        (VotePollButtonPressedEvent event, Emitter<VotePollState> emit) async {
      emit(VotePollLoadingState());

      final result = await _votePollUsecase.call(
        pollId: event.pollId,
        optionId: event.optionId,
      );
      print('...Result in VotePollBloc $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(VotePollFailureState(error: error.toString()));
      }, (response) {
        // print('fold response: ${response.toString()}');
        emit(VotePollSuccessState());
      });
    });
  }
}

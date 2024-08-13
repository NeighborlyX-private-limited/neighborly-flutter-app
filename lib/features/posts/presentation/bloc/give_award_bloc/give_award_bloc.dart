import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/give_award_usecase.dart';

part 'give_award_event.dart';
part 'give_award_state.dart';

class GiveAwardBloc extends Bloc<GiveAwardEvent, GiveAwardState> {
  final GiveAwardUsecase _giveAwardUsecase;

  GiveAwardBloc({required GiveAwardUsecase giveAwardUsecase})
      : _giveAwardUsecase = giveAwardUsecase,
        super(GiveAwardInitialState()) {
    on<GiveAwardButtonPressedEvent>((GiveAwardButtonPressedEvent event,
        Emitter<GiveAwardState> emit) async {
      emit(GiveAwardLoadingState());

      final result = await _giveAwardUsecase.call(
          id: event.id, awardType: event.awardType, type: event.type);

      result.fold(
          (error) => emit(GiveAwardFailureState(error: error.toString())),
          (response) => emit(GiveAwardSuccessState()));
    });
  }
}

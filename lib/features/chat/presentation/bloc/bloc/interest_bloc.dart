import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/interest_entity.dart';
import '../../../domain/usecases/get_all_interests_usecase.dart';

part 'interest_event.dart';
part 'interest_state.dart';

class InterestBloc extends Bloc<InterestEvent, InterestState> {
  final GetAllInterestsUsecase _getAllInterestsUsecase;
  InterestBloc({
    required GetAllInterestsUsecase getAllInterestsUsecase,
  })  : _getAllInterestsUsecase = getAllInterestsUsecase,
        super(InterestInitialState()) {
    on<FeatchInterestEvent>(
      (FeatchInterestEvent event, Emitter<InterestState> emit) async {
        emit(InterestLoadingState());

        final result = await _getAllInterestsUsecase.call();

        result.fold(
          (error) {
            emit(InterestFailureState(error: error.toString()));
          },
          (interests) {
            emit(InterestSuccessState(interests: interests));
          },
        );
      },
    );
  }
}

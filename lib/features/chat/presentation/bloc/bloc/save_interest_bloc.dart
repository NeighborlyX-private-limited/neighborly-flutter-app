import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neighborly_flutter_app/features/chat/presentation/bloc/bloc/save_interest_event.dart';

import '../../../domain/usecases/save_user_interest_usecase.dart';

part 'save_interest_state.dart';

// class SaveInterestBloc extends Bloc<SaveInterestEvent, SaveInterestState> {
//   SaveInterestBloc() : super(SaveInterestInitial()) {
//     on<SaveInterestEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//   }
// }

class SaveInterestBloc extends Bloc<SaveInterestEvent, SaveInterestState> {
  final SaveUserInterestsUsecase _saveUserInterestsUsecase;
  SaveInterestBloc({
    required SaveUserInterestsUsecase saveUserInterestsUsecase,
  })  : _saveUserInterestsUsecase = saveUserInterestsUsecase,
        super(SaveInterestInitialState()) {
    on<SaveUserInterestEvent>(
      (SaveUserInterestEvent event, Emitter<SaveInterestState> emit) async {
        emit(SaveInterestLoadingState());

        final result = await _saveUserInterestsUsecase.call(
            userInterest: event.userInterests);

        result.fold(
          (error) {
            emit(SaveInterestFailureState(error: error.toString()));
          },
          (_) {
            // ✅ Corrected: No parameter needed
            emit(SaveInterestSuccessState());
          },
        );
      },
    );
  }
}

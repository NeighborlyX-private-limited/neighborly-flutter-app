import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neighborly_flutter_app/features/chat/domain/usecases/create_dm_usecase.dart';

part 'create_dm_event.dart';
part 'create_dm_state.dart';

class CreateDmBloc extends Bloc<CreateDmEvent, CreateDmState> {
  final CreateDmUsecase _createDmUsecase;
  CreateDmBloc({
    required CreateDmUsecase createDmUsecase,
  })  : _createDmUsecase = createDmUsecase,
        super(CreateDmInitialState()) {
    on<CreateNewDmEvent>(
      (CreateNewDmEvent event, Emitter<CreateDmState> emit) async {
        emit(CreateDmLoadingState());

        final result = await _createDmUsecase.call(
          userId: event.userId,
        );

        result.fold(
          (error) {
            emit(CreateDmFailureState(error: error.toString()));
          },
          (chatId) {
            emit(CreateDmSuccessState(chatId: chatId));
          },
        );
      },
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/pin_message_usecase.dart';

part 'pin_message_event.dart';
part 'pin_message_state.dart';

class PinMessageBloc extends Bloc<PinMessagesEvent, PinMessagesState> {
  final PinnedMessagesUsecase _pinnedMessagesUsecase;
  PinMessageBloc({
    required PinnedMessagesUsecase pinnedMessagesUsecase,
  })  : _pinnedMessagesUsecase = pinnedMessagesUsecase,
        super(PinMessagesStateInitialState()) {
    on<PinnedAMessagesEvent>(
      (PinnedAMessagesEvent event, Emitter<PinMessagesState> emit) async {
        emit(PinMessagesStateLoadingState());

        final result = await _pinnedMessagesUsecase.call(
          messageId: event.messageId,
        );

        result.fold(
          (error) {
            emit(PinMessagesStateFailureState(error: error.toString()));
          },
          (message) {
            emit(PinMessagesStateSuccessState(message: message));
          },
        );
      },
    );
  }
}

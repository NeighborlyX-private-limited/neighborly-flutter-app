import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/pinned_message_model.dart';
import '../../domain/usecases/featch_pinned_messages_usecase.dart';

part 'featch_pinned_messages_event.dart';
part 'featch_pinned_messages_state.dart';

class FeatchPinnedMessagesBloc
    extends Bloc<FeatchPinnedMessagesEvent, FeatchPinnedMessagesState> {
  final FeatchPinnedMessagesUsecase _featchPinnedMessagesUsecase;

  FeatchPinnedMessagesBloc({
    required FeatchPinnedMessagesUsecase featchPinnedMessagesUsecase,
  })  : _featchPinnedMessagesUsecase = featchPinnedMessagesUsecase,
        super(FeatchPinnedMessagesInitialState()) {
    on<FeatchAllPinnedMessagesEvent>(
      (FeatchAllPinnedMessagesEvent event,
          Emitter<FeatchPinnedMessagesState> emit) async {
        emit(FeatchPinnedMessagesLoadingState());

        final result = await _featchPinnedMessagesUsecase.call(
          groupId: event.groupId,
        );

        result.fold(
          (error) {
            emit(FeatchPinnedMessagesFailureState(error: error.toString()));
          },
          (pinnedMessages) {
            emit(FeatchPinnedMessagesSuccessState(
                pinnedMessages: pinnedMessages));
          },
        );
      },
    );
  }
}

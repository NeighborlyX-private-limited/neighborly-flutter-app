import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/handle_join_request_usercase.dart';
part 'handle_join_request_event.dart';
part 'handle_join_request_state.dart';

class HandleJoinRequestBloc
    extends Bloc<HandleJoinRequestEvent, HandleJoinRequestState> {
  final HandleJoinRequestUsercase _handleJoinRequestUserCase;

  HandleJoinRequestBloc({
    required HandleJoinRequestUsercase handleJoinRequestUserCase,
  })  : _handleJoinRequestUserCase = handleJoinRequestUserCase,
        super(HandleJoinRequestInitialState()) {
    on<HandleGroupJoinRequestEvent>(
      (HandleGroupJoinRequestEvent event,
          Emitter<HandleJoinRequestState> emit) async {
        emit(HandleJoinRequestLoadingState());

        final result = await _handleJoinRequestUserCase.call(
          communityId: event.communityId,
          requestId: event.requestId,
          status: event.status,
        );

        result.fold(
          (error) {
            emit(HandleJoinRequestFailureState(error: error.toString()));
          },
          (response) {
            emit(HandleJoinRequestSuccessState(msg: response));
          },
        );
      },
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/handle_join_request_usercase.dart';

part 'handle_join_request_event.dart';
part 'handle_join_request_state.dart';

class HandleJoinRequestBloc
    extends Bloc<HandleJoinRequestEvent, HandleJoinRequestState> {
  final HandleJoinRequestUsercase _handleJoinRequestUserCase;

  HandleJoinRequestBloc(
      {required HandleJoinRequestUsercase handleJoinRequestUserCase})
      : _handleJoinRequestUserCase = handleJoinRequestUserCase,
        super(HandleJoinRequestInitialState()) {
    on<HandleGroupJoinRequestEvent>(_onHandleGroupJoinRequestEvent);
  }

  Future<void> _onHandleGroupJoinRequestEvent(
    HandleGroupJoinRequestEvent event,
    Emitter<HandleJoinRequestState> emit,
  ) async {
    emit(HandleJoinRequestLoadingState());

    try {
      final result = await _handleJoinRequestUserCase.call(
        communityId: event.communityId,
        requestId: event.requestId,
        status: event.status,
      );

      result.fold(
        (error) {
          print('HANDLE REQUEST ERROR:$error');
          emit(HandleJoinRequestFailureState(error: error.toString()));
        },
        (response) {
          print('HANDLE REQUEST RESPONSE:$response');
          emit(HandleJoinRequestSuccessState(msg: response));
        },
      );
    } catch (e) {
      emit(HandleJoinRequestFailureState(error: e.toString()));
    }
  }
}

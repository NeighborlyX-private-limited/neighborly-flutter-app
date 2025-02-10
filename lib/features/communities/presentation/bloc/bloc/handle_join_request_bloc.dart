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

  Future<void> _onHandleGroupJoinRequestEvent(HandleGroupJoinRequestEvent event,
      Emitter<HandleJoinRequestState> emit) async {
    print(
        "BLoC: Event received - communityId: ${event.communityId}, requestId: ${event.requestId}, status: ${event.status}");

    emit(HandleJoinRequestLoadingState());

    try {
      final result = await _handleJoinRequestUserCase.call(
        communityId: event.communityId,
        requestId: event.requestId,
        status: event.status,
      );

      print("BLoC: Result from use case: $result");

      result.fold(
        (error) {
          print("BLoC: Error received: $error");
          emit(HandleJoinRequestFailureState(error: error.toString()));
        },
        (response) {
          print("BLoC: Response received: $response");
          emit(HandleJoinRequestSuccessState(msg: response));
        },
      );
    } catch (e) {
      print("BLoC: Exception caught - $e");
      emit(HandleJoinRequestFailureState(error: e.toString()));
    }
  }
}

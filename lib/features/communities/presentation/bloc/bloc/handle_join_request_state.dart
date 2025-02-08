part of 'handle_join_request_bloc.dart';

abstract class HandleJoinRequestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HandleJoinRequestInitialState extends HandleJoinRequestState {
  HandleJoinRequestInitialState();
}

class HandleJoinRequestLoadingState extends HandleJoinRequestState {
  HandleJoinRequestLoadingState();
}

class HandleJoinRequestSuccessState extends HandleJoinRequestState {
  final String msg;

  HandleJoinRequestSuccessState({required this.msg});
}

class HandleJoinRequestFailureState extends HandleJoinRequestState {
  final String error;
  HandleJoinRequestFailureState({required this.error});
}

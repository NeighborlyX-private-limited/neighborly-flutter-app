part of 'pin_message_bloc.dart';

abstract class PinMessagesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PinMessagesStateInitialState extends PinMessagesState {
  PinMessagesStateInitialState();
}

class PinMessagesStateLoadingState extends PinMessagesState {
  PinMessagesStateLoadingState();
}

class PinMessagesStateSuccessState extends PinMessagesState {
  final String message;
  PinMessagesStateSuccessState({required this.message});
}

class PinMessagesStateFailureState extends PinMessagesState {
  final String error;
  PinMessagesStateFailureState({required this.error});
}

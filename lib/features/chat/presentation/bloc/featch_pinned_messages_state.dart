part of 'featch_pinned_messages_bloc.dart';

abstract class FeatchPinnedMessagesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeatchPinnedMessagesInitialState extends FeatchPinnedMessagesState {
  FeatchPinnedMessagesInitialState();
}

class FeatchPinnedMessagesLoadingState extends FeatchPinnedMessagesState {
  FeatchPinnedMessagesLoadingState();
}

class FeatchPinnedMessagesSuccessState extends FeatchPinnedMessagesState {
  final List<PinnedMessageModel> pinnedMessages;
  FeatchPinnedMessagesSuccessState({required this.pinnedMessages});
}

class FeatchPinnedMessagesFailureState extends FeatchPinnedMessagesState {
  final String error;
  FeatchPinnedMessagesFailureState({required this.error});
}

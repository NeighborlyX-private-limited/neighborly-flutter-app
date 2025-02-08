part of 'featch_pinned_messages_bloc.dart';

abstract class FeatchPinnedMessagesEvent extends Equatable {}

class FeatchAllPinnedMessagesEvent extends FeatchPinnedMessagesEvent {
  final String groupId;

  FeatchAllPinnedMessagesEvent({
    required this.groupId,
  });

  @override
  List<Object?> get props => [
        groupId,
      ];
}

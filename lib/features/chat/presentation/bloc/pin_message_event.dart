part of 'pin_message_bloc.dart';

abstract class PinMessagesEvent extends Equatable {}

class PinnedAMessagesEvent extends PinMessagesEvent {
  final String messageId;

  PinnedAMessagesEvent({
    required this.messageId,
  });

  @override
  List<Object?> get props => [
        messageId,
      ];
}

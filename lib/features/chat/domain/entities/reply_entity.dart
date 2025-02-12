import 'package:equatable/equatable.dart';

class MessageReplyEntity extends Equatable {
  final String messageId;
  final String userId;
  final String name;
  final String? message;
  final String? media;

  const MessageReplyEntity({
    required this.messageId,
    required this.name,
    required this.userId,
    required this.message,
    required this.media,
  });

  @override
  List<Object?> get props => [
        messageId,
        message,
        media,
        name,
      ];
}

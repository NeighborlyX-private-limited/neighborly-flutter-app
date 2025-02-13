import 'package:equatable/equatable.dart';

class MessageReplyEntity extends Equatable {
  final String messageId;
  final String userId;
  final String name;
  final String? message;
  final String? mediaLink;

  const MessageReplyEntity({
    required this.messageId,
    required this.name,
    required this.userId,
    required this.message,
    required this.mediaLink,
  });

  @override
  List<Object?> get props => [
        messageId,
        message,
        mediaLink,
        name,
      ];
}

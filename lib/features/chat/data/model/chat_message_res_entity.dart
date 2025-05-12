import 'package:equatable/equatable.dart';
import 'package:neighborly_flutter_app/features/chat/data/model/reply_model.dart';

class ChatMessageResponseEntity extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String message;
  final String? mediaLink;
  final bool isRead;
  final bool isDeletedBySender;
  final bool isDeletedByReciever;
  final bool isSender;
  final String createdAt;
  final MessageReplyModel? replyTo;

  const ChatMessageResponseEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.message,
    this.mediaLink,
    required this.isRead,
    required this.isDeletedBySender,
    required this.isDeletedByReciever,
    required this.isSender,
    required this.createdAt,
    this.replyTo,
  });

  @override
  List<Object?> get props => [
        id,
        chatId,
        senderId,
        message,
        mediaLink,
        isRead,
        isDeletedBySender,
        isDeletedByReciever,
        isSender,
        createdAt,
        replyTo,
      ];
}

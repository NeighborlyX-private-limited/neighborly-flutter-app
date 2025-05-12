class ChatMessageResponse {
  final List<ChatMessage> messages;
  final Recipient recipient;

  ChatMessageResponse({
    required this.messages,
    required this.recipient,
  });

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessageResponse(
      messages: (json['messages'] as List)
          .map((msg) => ChatMessage.fromJson(msg))
          .toList()
          .reversed
          .toList(),
      recipient: Recipient.fromJson(json['recipient']),
    );
  }
}

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String message;
  final String? mediaLink;
  final bool isRead;
  final bool isDeletedBySender;
  final bool isDeletedByReciever;
  final String? replyTo;
  final DateTime createdAt;
  final int v;
  final bool isSender;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.message,
    this.mediaLink,
    required this.isRead,
    required this.isDeletedBySender,
    required this.isDeletedByReciever,
    this.replyTo,
    required this.createdAt,
    required this.v,
    required this.isSender,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      message: json['message'],
      mediaLink: json['mediaLink'],
      isRead: json['isRead'],
      isDeletedBySender: json['isDeletedBySender'],
      isDeletedByReciever: json['isDeletedByReciever'],
      replyTo: json['replyTo'],
      createdAt: DateTime.parse(json['createdAt']),
      v: json['__v'],
      isSender: json['isSender'],
    );
  }
}

class Recipient {
  final String id;
  final String username;
  final String picture;

  Recipient({
    required this.id,
    required this.username,
    required this.picture,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      id: json['_id'],
      username: json['username'],
      picture: json['picture'],
    );
  }
}

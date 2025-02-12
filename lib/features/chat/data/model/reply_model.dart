import 'dart:convert';
import '../../domain/entities/reply_entity.dart';

class MessageReplyModel extends MessageReplyEntity {
  const MessageReplyModel({
    required super.messageId,
    required super.name,
    required super.userId,
    required super.message,
    required super.media,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'name': name,
      'userId': userId,
      'message': message,
      'media': media,
    };
  }

  factory MessageReplyModel.fromMap(Map<String, dynamic> map) {
    return MessageReplyModel(
      messageId: map['messageId'] ?? '',
      name: map['name'] ?? '',
      userId: map['userId'] ?? '',
      message: map['message'] ?? '',
      media: map['media'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageReplyModel.fromJson(String source) =>
      MessageReplyModel.fromMap(json.decode(source));

  static List<MessageReplyModel> fromJsonList(List<dynamic> json) {
    var list = <MessageReplyModel>[];

    if (json.isNotEmpty) {
      list =
          json.map((jsomItem) => MessageReplyModel.fromJson(jsomItem)).toList();
    }

    return list;
  }

  // ReplyModel copyWith({
  //   String? id,
  //   String? name,
  //   String? avatarUrl,
  //   bool? isAdmin,
  // }) {
  //   return ReplyModel(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     avatarUrl: avatarUrl ?? this.avatarUrl,
  //     isAdmin: isAdmin ?? this.isAdmin,
  //   );
  // }
}

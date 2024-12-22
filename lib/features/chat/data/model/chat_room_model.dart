import 'dart:convert';

import '../../domain/entities/chat_room_entity.dart';

class ChatRoomModel extends ChatRoomEntity {
  const ChatRoomModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
    required super.lastMessage,
    required super.lastMessageDate,
    required super.isMuted,
    required super.isGroup,
    required super.unreadCount,
  });

  ChatRoomModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? lastMessage,
    String? lastMessageDate,
    bool? isMuted,
    bool? isGroup,
    int? unreadCount,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageDate: lastMessageDate ?? this.lastMessageDate,
      isMuted: isMuted ?? this.isMuted,
      isGroup: isGroup ?? this.isGroup,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  String toString() {
    return 'ChatRoomModel(id: $id, name: $name, avatarUrl: $avatarUrl, lastMessage: $lastMessage, lastMessageDate: $lastMessageDate, isMuted: $isMuted, isGroup: $isGroup, unreadCount: $unreadCount)';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'lastMessage': lastMessage,
      'lastMessageDate': lastMessageDate,
      'isMuted': isMuted,
      'isGroup': isGroup,
      'unreadCount': unreadCount,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageDate: map['lastMessageDate'] ?? '',
      isMuted: map['isMuted'] ?? false,
      isGroup: map['isGroup'] ?? false,
      unreadCount: map['unreadCount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomModel.fromJson(String source) =>
      ChatRoomModel.fromMap(json.decode(source));

  static List<ChatRoomModel> fromJsonList(List<dynamic> json) {
    var list = <ChatRoomModel>[];

    if (json.isNotEmpty) {
      list = json
          .map<ChatRoomModel>((jsomItem) => ChatRoomModel.fromMap(jsomItem))
          .toList();
    }

    return list;
  }
}

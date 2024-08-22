import 'dart:convert';

import '../../../../core/models/post_model.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.text, // post=content
    required super.date,
    required super.isMine,
    required super.isReaded,
    required super.hasMore,
    required super.pictureUrl,
    super.pictureAsset,
    required super.isAdmin,
    required super.isPinned,
    required super.repliesCount, // post=commentCount
    required super.cheers,
    required super.bools,
    required super.boolOrCheer,
    required super.repliesAvatas,
    super.author, //  post: userId, userName, proPic
  });

  @override
  String toString() {
    return 'ChatMessageModel(id: $id, text: $text, date: $date, isMine: $isMine, isReaded: $isReaded, hasMore: $hasMore, isAdmin: $isAdmin, isPinned: $isPinned, repliesCount: $repliesCount, cheers: $cheers, bools: $bools, boolOrCheer: $boolOrCheer, pictureAsset: $pictureAsset, pictureUrl: $pictureUrl, repliesAvatas: $repliesAvatas, author: $author)';
  }

  num _extractAndConcatenateNumbers(String input) {
    final RegExp regex = RegExp(r'\d');
    final Iterable<Match> matches = regex.allMatches(input);
    final StringBuffer buffer = StringBuffer();

    for (final Match match in matches) {
      buffer.write(match.group(0));
    }

    return num.parse(buffer.toString());
  }

  PostModel toPost() {
    return PostModel(
      userId: author?.id ?? '',
      userName: author?.name ?? '',
      proPic: author?.avatarUrl ?? 'https://eu.ui-avatars.com/api/?name=${author?.name ?? "XXX"}&background=random&rounded=true',
      type: 'post',
      createdAt: date,
      cheers: cheers,
      bools: bools,
      id: _extractAndConcatenateNumbers(id),
      city: 'Gothan',
      commentCount: repliesCount,
      awardType: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': date,
      'isMine': isMine,
      'isReaded': isReaded,
      'hasMore': hasMore,
      'isAdmin': isAdmin,
      'isPinned': isPinned,
      'repliesCount': repliesCount,
      'cheers': cheers,
      'bools': bools,
      'boolOrCheer': boolOrCheer,
      'pictureAsset': pictureAsset,
      'pictureUrl': pictureUrl,
      'repliesAvatas': repliesAvatas,
      'author': author?.toMap(),
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      date: map['date'] ?? '',
      isMine: map['isMine'] ?? false,
      isReaded: map['isReaded'] ?? false,
      hasMore: map['hasMore'] ?? false,
      isAdmin: map['isAdmin'] ?? false,
      isPinned: map['isPinned'] ?? false,
      repliesCount: map['repliesCount']?.toInt() ?? 0,
      cheers: map['cheers']?.toInt() ?? 0,
      bools: map['bools']?.toInt() ?? 0,
      boolOrCheer: map['boolOrCheer'] ?? '',
      pictureAsset: null,
      pictureUrl: map['pictureUrl'] ?? '',
      repliesAvatas: map['repliesAvatas'] != null ? List<String>.from(map['repliesAvatas']) : [],
      author: map['author'] != null ? UserSimpleModel.fromMap(map['author']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessageModel.fromJson(String source) => ChatMessageModel.fromMap(json.decode(source));

  static List<ChatMessageModel> fromJsonList(List<dynamic> json) {
    var list = <ChatMessageModel>[];

    if (json.isNotEmpty) {
      list = json.map<ChatMessageModel>((jsomItem) => ChatMessageModel.fromMap(jsomItem)).toList();
    }

    return list;
  }
}

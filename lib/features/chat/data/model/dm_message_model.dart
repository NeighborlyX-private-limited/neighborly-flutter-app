// class ChatMessageResponse {
//   final List<ChatMessage> messages;
//   // final Recipient recipient;

//   ChatMessageResponse({
//     required this.messages,
//     // required this.recipient,
//   });

//   factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
//     return ChatMessageResponse(
//       messages: (json['messages'] as List)
//           .map((msg) => ChatMessage.fromJson(msg))
//           .toList()
//           .reversed
//           .toList(),
//       // recipient: Recipient.fromJson(json['recipient']),
//     );
//   }
// }

// class ChatMessage {
//   final String id;
//   final String chatId;
//   final String senderId;
//   final String message;
//   final String? mediaLink;
//   final bool isRead;
//   final bool isDeletedBySender;
//   final bool isDeletedByReciever;
//   final String? replyTo;
//   final DateTime createdAt;
//   final int v;
//   final bool isSender;

//   ChatMessage({
//     required this.id,
//     required this.chatId,
//     required this.senderId,
//     required this.message,
//     this.mediaLink,
//     required this.isRead,
//     required this.isDeletedBySender,
//     required this.isDeletedByReciever,
//     this.replyTo,
//     required this.createdAt,
//     required this.v,
//     required this.isSender,
//   });

//   factory ChatMessage.fromJson(Map<String, dynamic> json) {
//     return ChatMessage(
//       id: json['_id'],
//       chatId: json['chatId'],
//       senderId: json['senderId'],
//       message: json['message'],
//       mediaLink: json['mediaLink'],
//       isRead: json['isRead'],
//       isDeletedBySender: json['isDeletedBySender'],
//       isDeletedByReciever: json['isDeletedByReciever'],
//       replyTo: json['replyTo'],
//       createdAt: DateTime.parse(json['createdAt']),
//       v: json['__v'],
//       isSender: json['isSender'],
//     );
//   }
// }

// // class Recipient {
// //   final String id;
// //   final String username;
// //   final String picture;

// //   Recipient({
// //     required this.id,
// //     required this.username,
// //     required this.picture,
// //   });

// //   factory Recipient.fromJson(Map<String, dynamic> json) {
// //     return Recipient(
// //       id: json['_id'],
// //       username: json['username'],
// //       picture: json['picture'],
// //     );
// //   }
// // }
import 'dart:convert';
import 'package:neighborly_flutter_app/features/chat/data/model/chat_message_res_entity.dart';
import 'package:neighborly_flutter_app/features/chat/data/model/reply_model.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatMessageResponse extends ChatMessageResponseEntity {
  const ChatMessageResponse({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.message,
    required super.isRead,
    required super.isDeletedBySender,
    required super.isDeletedByReciever,
    required super.isSender,
    required super.createdAt,
  });

  @override
  @override
  String toString() {
    return 'ChatMessageResponse(id: $id, chatId: $chatId, senderId: $senderId, message: $message, isRead: $isRead, isDeletedBySender: $isDeletedBySender, isDeletedByReciever: $isDeletedByReciever, isSender: $isSender)';
  }

  /// Helper function to extract all numbers from a string and concatenate them into a single number
  // num _extractAndConcatenateNumbers(String input) {
  //   /// Regex to find digits
  //   final RegExp regex = RegExp(r'\d');
  //   final Iterable<Match> matches = regex.allMatches(input);
  //   final StringBuffer buffer = StringBuffer();

  //   /// Append all matched digits to the buffer
  //   for (final Match match in matches) {
  //     buffer.write(match.group(0));
  //   }

  //   /// Convert the concatenated string of digits to a number
  //   return num.parse(buffer.toString());
  // }

  /// Converts the current ChatMessageResponse instance to a PostModel
  // PostModel toPost() {
  //   return PostModel(
  //     awardCount: '0',
  //     userId: author?.id ?? '',
  //     userName: author?.name ?? '',
  //     proPic: author?.avatarUrl ??
  //         'https://eu.ui-avatars.com/api/?name=${author?.name ?? "XXX"}&background=random&rounded=true',
  //     type: 'post',
  //     createdAt: date,
  //     cheers: cheers,

  //     /// Note: Typo "bools" instead of "boos"
  //     bools: boos,
  //     id: _extractAndConcatenateNumbers(id),
  //     city: '',
  //     commentCount: repliesCount,
  //     awardType: [],
  //     userFeedback: '',
  //     multimedia: [],
  //   );
  // }

  /// CopyWith method for creating a new instance with updated values
  ChatMessageResponse copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? message,
    String? mediaLink,
    bool? isRead,
    bool? isDeletedBySender,
    bool? isDeletedByReciever,
    bool? isSender,
    String? createdAt,
    MessageReplyModel? replyTo,
  }) {
    return ChatMessageResponse(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      // mediaLink: mediaLink ?? this.mediaLink,
      isRead: isRead ?? this.isRead,
      isDeletedBySender: isDeletedBySender ?? this.isDeletedBySender,
      isDeletedByReciever: isDeletedByReciever ?? this.isDeletedByReciever,
      isSender: isSender ?? this.isSender,
      createdAt: createdAt ?? this.createdAt,
      // replyTo: replyTo ?? this.replyTo,
    );
  }

  /// Converts the ChatMessageResponse instance into a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'chatId': chatId,
      'senderId': senderId,
      'message': message,
      // 'mediaLink': mediaLink,
      'isRead': isRead,
      'isDeletedBySender': isDeletedBySender,
      'isDeletedByReciever': isDeletedByReciever,
      'isSender': isSender,
      'createdAt': createdAt,
      // 'replyTo': replyTo?.toMap(),
    };
  }

  /// Factory constructor to create an instance of ChatMessageResponse from a map
  factory ChatMessageResponse.fromMap(Map<String, dynamic> map) {
    return ChatMessageResponse(
      id: map['_id'] ?? '',
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      message: map['message'] ?? '',
      // mediaLink: map['mediaLink'],
      isRead: map['isRead'] ?? false,
      isDeletedBySender: map['isDeletedBySender'] ?? false,
      isDeletedByReciever: map['isDeletedByReciever'] ?? false,
      isSender: map['isSender'] ?? false,
      createdAt: map['createdAt'],
      // replyTo: map['replyTo'] != null
      //     ? MessageReplyModel.fromMap(map['replyTo'])
      //     : null,
    );
  }

  // Converts the ChatMessageResponse instance into a JSON string
  String toJson() => json.encode(toMap());

  // Factory constructor to create an instance of ChatMessageResponse from a JSON string
  factory ChatMessageResponse.fromJson(String source) =>
      ChatMessageResponse.fromMap(json.decode(source));

  // Static method to parse a list of JSON objects into a list of ChatMessageResponse
  static List<ChatMessageResponse> fromJsonList(List<dynamic> json) {
    var list = <ChatMessageResponse>[];

    // Check if the list is not empty before mapping
    if (json.isNotEmpty) {
      // Typo: "jsomItem"
      list = json
          .map<ChatMessageResponse>(
              (jsonItem) => ChatMessageResponse.fromMap(jsonItem))
          .toList()
          .reversed
          .toList();
    }

    return list;
  }
}

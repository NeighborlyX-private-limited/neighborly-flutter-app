import 'dart:convert';
import 'package:neighborly_flutter_app/features/chat/data/model/reply_model.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.text,
    required super.date,
    required super.isMine,
    required super.readByuser,
    required super.hasMore,
    required super.pictureUrl,
    required super.isAdmin,
    required super.isPinned,
    required super.repliesCount,
    required super.cheers,
    required super.boos,
    required super.booOrCheer,
    super.author,
    super.reply,
  });

  @override
  String toString() {
    return 'ChatMessageModel(id: $id, text: $text, date: $date, isMine: $isMine, readByuser: $readByuser, hasMore: $hasMore, isAdmin: $isAdmin, isPinned: $isPinned, repliesCount: $repliesCount, cheers: $cheers, boos: $boos, booOrCheer: $booOrCheer, pictureUrl: $pictureUrl, author: $author,)';
  }

  /// Helper function to extract all numbers from a string and concatenate them into a single number
  num _extractAndConcatenateNumbers(String input) {
    /// Regex to find digits
    final RegExp regex = RegExp(r'\d');
    final Iterable<Match> matches = regex.allMatches(input);
    final StringBuffer buffer = StringBuffer();

    /// Append all matched digits to the buffer
    for (final Match match in matches) {
      buffer.write(match.group(0));
    }

    /// Convert the concatenated string of digits to a number
    return num.parse(buffer.toString());
  }

  /// Converts the current ChatMessageModel instance to a PostModel
  PostModel toPost() {
    return PostModel(
      userId: author?.id ?? '',
      userName: author?.name ?? '',
      proPic: author?.avatarUrl ??
          'https://eu.ui-avatars.com/api/?name=${author?.name ?? "XXX"}&background=random&rounded=true',
      type: 'post',
      createdAt: date,
      cheers: cheers,

      /// Note: Typo "bools" instead of "boos"
      bools: boos,
      id: _extractAndConcatenateNumbers(id),
      city: '',
      commentCount: repliesCount,
      awardType: [],
      userFeedback: '',
      multimedia: [],
    );
  }

  /// Converts the ChatMessageModel instance into a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': date,
      'isMine': isMine,
      'readByuser': readByuser,
      'hasMore': hasMore,
      'isAdmin': isAdmin,
      'isPinned': isPinned,
      'repliesCount': repliesCount,
      'cheers': cheers,
      'boos': boos,
      'booOrCheer': booOrCheer,
      'pictureUrl': pictureUrl,
      'author': author?.toMap(),
      'reply': reply?.toMap(),
    };
  }

  /// Factory constructor to create an instance of ChatMessageModel from a map
  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      date: map['date'] ?? DateTime.now().toString(),
      isMine: map['isMine'] ?? false,
      readByuser: map['readByuser'] ?? false,
      repliesCount: map['repliesCount']?.toInt() ?? 0,
      isAdmin: map['isAdmin'] ?? false,
      isPinned: map['isPinned'] ?? false,
      cheers: map['cheers']?.toInt() ?? 0,
      boos: map['boos']?.toInt() ?? 0,
      booOrCheer: map['booOrCheer'] ?? '',
      hasMore: map['hasMore'] ?? false,
      pictureUrl: map['pictureUrl'] ?? '',
      author:
          map['author'] != null ? UserSimpleModel.fromMap(map['author']) : null,
      reply: map['repliedTo'] != null
          ? MessageReplyModel.fromMap(map['repliedTo'])
          : null,
    );
  }

  // Converts the ChatMessageModel instance into a JSON string
  String toJson() => json.encode(toMap());

  // Factory constructor to create an instance of ChatMessageModel from a JSON string
  factory ChatMessageModel.fromJson(String source) =>
      ChatMessageModel.fromMap(json.decode(source));

  // Static method to parse a list of JSON objects into a list of ChatMessageModel
  static List<ChatMessageModel> fromJsonList(List<dynamic> json) {
    var list = <ChatMessageModel>[];

    // Check if the list is not empty before mapping
    if (json.isNotEmpty) {
      // Typo: "jsomItem"
      list = json
          .map<ChatMessageModel>(
              (jsonItem) => ChatMessageModel.fromMap(jsonItem))
          .toList();
    }

    return list;
  }
}

// import 'dart:convert';

// import '../../../../core/models/post_model.dart';
// import '../../../../core/models/user_simple_model.dart';
// import '../../domain/entities/chat_message_entity.dart';

// class ChatMessageModel extends ChatMessageEntity {
//   const ChatMessageModel({
//     required super.id,
//     required super.text,
//     required super.date,
//     required super.isMine,
//     required super.readByuser,
//     required super.hasMore,
//     required super.pictureUrl,
//     required super.isAdmin,
//     required super.isPinned,
//     required super.repliesCount,
//     required super.cheers,
//     required super.boos,
//     required super.booOrCheer,
//     super.author,
//     this.repliedTo,
//   });

//   final RepliedToMessage? repliedTo; // Added repliedTo field

//   // @override
//   // String toString() {
//   //   return 'ChatMessageModel(id: $id, text: $text, date: $date, isMine: $isMine, '
//   //       'readByuser: $readByuser, hasMore: $hasMore, isAdmin: $isAdmin, '
//   //       'isPinned: $isPinned, repliesCount: $repliesCount, cheers: $cheers, '
//   //       'boos: $boos, booOrCheer: $booOrCheer, pictureUrl: $pictureUrl, '
//   //       'author: $author, repliedTo: $repliedTo)';
//   // }

//   /// Helper function to extract all numbers from a string and concatenate them into a single number
//   num _extractAndConcatenateNumbers(String input) {
//     final RegExp regex = RegExp(r'\d');
//     final Iterable<Match> matches = regex.allMatches(input);
//     final StringBuffer buffer = StringBuffer();

//     for (final Match match in matches) {
//       buffer.write(match.group(0));
//     }

//     return num.tryParse(buffer.toString()) ?? 0;
//   }

//   /// Converts the current ChatMessageModel instance to a PostModel
//   PostModel toPost() {
//     return PostModel(
//       userId: author?.id ?? '',
//       userName: author?.name ?? '',
//       proPic: author?.avatarUrl ??
//           'https://eu.ui-avatars.com/api/?name=${author?.name ?? "XXX"}&background=random&rounded=true',
//       type: 'post',
//       createdAt: date,
//       cheers: cheers,
//       bools: boos, // Fixed typo (was "bools")
//       id: _extractAndConcatenateNumbers(id),
//       city: '',
//       commentCount: repliesCount,
//       awardType: [],
//       userFeedback: '',
//       multimedia: [],
//     );
//   }

//   /// Converts the ChatMessageModel instance into a Map<String, dynamic>
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'text': text,
//       'date': date,
//       'isMine': isMine,
//       'readByuser': readByuser,
//       'hasMore': hasMore,
//       'isAdmin': isAdmin,
//       'isPinned': isPinned,
//       'repliesCount': repliesCount,
//       'cheers': cheers,
//       'boos': boos,
//       'booOrCheer': booOrCheer,
//       'pictureUrl': pictureUrl,
//       'author': author?.toMap(),
//       'repliedTo': repliedTo?.toMap(), // Added repliedTo field mapping
//     };
//   }

//   /// Factory constructor to create an instance of ChatMessageModel from a map
//   factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
//     return ChatMessageModel(
//       id: map['id'] ?? '',
//       text: map['text'] ?? '',
//       date: map['date'] ?? DateTime.now().toString(),
//       isMine: map['isMine'] ?? false,
//       readByuser: map['readByuser'] ?? false,
//       repliesCount: map['repliesCount']?.toInt() ?? 0,
//       isAdmin: map['isAdmin'] ?? false,
//       isPinned: map['isPinned'] ?? false,
//       cheers: map['cheers']?.toInt() ?? 0,
//       boos: map['boos']?.toInt() ?? 0,
//       booOrCheer: map['booOrCheer'],
//       hasMore: map['hasMore'] ?? false,
//       pictureUrl: map['pictureUrl'] ?? '',
//       author:
//           map['author'] != null ? UserSimpleModel.fromMap(map['author']) : null,
//       repliedTo: map['repliedTo'] != null
//           ? RepliedToMessage.fromMap(map['repliedTo'])
//           : null, // Added repliedTo mapping
//     );
//   }

//   /// Converts the ChatMessageModel instance into a JSON string
//   String toJson() => json.encode(toMap());

//   /// Factory constructor to create an instance of ChatMessageModel from a JSON string
//   factory ChatMessageModel.fromJson(String source) =>
//       ChatMessageModel.fromMap(json.decode(source));

//   /// Static method to parse a list of JSON objects into a list of ChatMessageModel
//   static List<ChatMessageModel> fromJsonList(List<dynamic> json) {
//     return json.isNotEmpty
//         ? json
//             .map<ChatMessageModel>(
//                 (jsonItem) => ChatMessageModel.fromMap(jsonItem))
//             .toList()
//         : [];
//   }
// }

// /// Model for replied-to messages
// class RepliedToMessage {
//   final String messageId;
//   final String userId;
//   final String name;
//   final String message;

//   RepliedToMessage({
//     required this.messageId,
//     required this.userId,
//     required this.name,
//     required this.message,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'messageId': messageId,
//       'userId': userId,
//       'name': name,
//       'message': message,
//     };
//   }

//   factory RepliedToMessage.fromMap(Map<String, dynamic> map) {
//     return RepliedToMessage(
//       messageId: map['messageId'] ?? '',
//       userId: map['userId'] ?? '',
//       name: map['name'] ?? '',
//       message: map['message'] ?? '',
//     );
//   }
// }

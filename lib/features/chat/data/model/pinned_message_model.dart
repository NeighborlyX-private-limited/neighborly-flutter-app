// import '../../domain/entities/pinned_message_entity.dart';

// class PinnedMessageModel extends PinnedMessageEntity {
//   const PinnedMessageModel({
//     required super.id,
//     required super.groupId,
//     required super.name,
//     required super.Userpicture,
//     required super.userId,
//     required super.message,
//     required super.readBy,
//     super.mediaLink,
//     super.parentMessageId,
//     required super.cheers,
//     required super.boos,
//     required super.isPinned,
//     required super.sendAt,
//     required super.createdAt,
//     required super.updatedAt,
//   });

//   /// Convert JSON to Model
//   factory PinnedMessageModel.fromJson(Map<String, dynamic> json) {
//     return PinnedMessageModel(
//       id: json["_id"] ?? "",
//       groupId: json["groupId"] ?? "",
//       name: json["name"] ?? "",
//       userId: json["userid"] ?? "",
//       Userpicture: json["userid"] ?? "",
//       message: json["message"] ?? "",
//       readBy: List<String>.from(json["readBy"] ?? []),
//       mediaLink: json["mediaLink"],
//       parentMessageId: json["parentMessageId"],
//       cheers: json["cheers"] ?? 0,
//       boos: json["boos"] ?? 0,
//       isPinned: json["isPinned"] ?? false,
//       sendAt: DateTime.parse(json["sendAt"]),
//       createdAt: DateTime.parse(json["createdAt"]),
//       updatedAt: DateTime.parse(json["updatedAt"]),
//     );
//   }

//   /// Convert Model to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "groupId": groupId,
//       "name": name,
//       "userid": userId,
//       "message": message,
//       "readBy": readBy,
//       "mediaLink": mediaLink,
//       "parentMessageId": parentMessageId,
//       "cheers": cheers,
//       "boos": boos,
//       "isPinned": isPinned,
//       "sendAt": sendAt.toIso8601String(),
//       "createdAt": createdAt.toIso8601String(),
//       "updatedAt": updatedAt.toIso8601String(),
//     };
//   }

//   /// Convert JSON List to Model List
//   static List<PinnedMessageModel> fromJsonList(List<dynamic> jsonList) {
//     return jsonList.map((json) => PinnedMessageModel.fromJson(json)).toList();
//   }
// }

import '../../domain/entities/pinned_message_entity.dart';

class PinnedMessageModel extends PinnedMessageEntity {
  const PinnedMessageModel({
    required super.id,
    required super.groupId,
    required super.name,
    required super.userId,
    required super.message,
    required super.readBy,
    super.mediaLink,
    super.parentMessageId,
    required super.cheers,
    required super.boos,
    required super.isPinned,
    required super.sendAt,
    required super.createdAt,
    required super.updatedAt,
    required super.userpicture,
  });

  /// Convert JSON to Model
  factory PinnedMessageModel.fromJson(Map<String, dynamic> json) {
    return PinnedMessageModel(
      id: json["_id"] ?? "",
      groupId: json["groupId"] ?? "",
      name: json["userid"]?["username"] ?? "",
      userId: json["userid"]?["_id"] ?? "",
      userpicture: json["userid"]?["picture"] ?? "",
      message: json["message"] ?? "",
      readBy: List<String>.from(json["readBy"] ?? []),
      mediaLink: json["mediaLink"],
      parentMessageId: json["parentMessageId"],
      cheers: json["cheers"] ?? 0,
      boos: json["boos"] ?? 0,
      isPinned: json["isPinned"] ?? false,
      sendAt: DateTime.parse(json["sendAt"]),
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  /// Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "groupId": groupId,
      "name": name,
      "userid": {
        "_id": userId,
        "picture": userpicture,
      },
      "message": message,
      "readBy": readBy,
      "mediaLink": mediaLink,
      "parentMessageId": parentMessageId,
      "cheers": cheers,
      "boos": boos,
      "isPinned": isPinned,
      "sendAt": sendAt.toIso8601String(),
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  /// Convert JSON List to Model List
  static List<PinnedMessageModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PinnedMessageModel.fromJson(json)).toList();
  }
}

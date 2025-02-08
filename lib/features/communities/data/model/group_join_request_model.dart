import '../../domain/entities/group_join_request_entity.dart';

class GroupJoinRequestModel extends GroupJoinRequestEntity {
  const GroupJoinRequestModel({
    required super.id,
    required super.groupId,
    required super.userId,
    required super.username,
    required super.userpic,
    required super.email,
    required super.status,
    required super.requestedAt,
    super.resolvedAt,
    super.resolvedBy,
    required super.message,
  }) : super();

  /// **Factory method to convert JSON to Model**
  factory GroupJoinRequestModel.fromJson(Map<String, dynamic> json) {
    return GroupJoinRequestModel(
      id: json["_id"] ?? "",
      groupId: json["groupId"] ?? "",
      userId: json["userId"]["_id"] ?? "",
      username: json["userId"]["username"] ?? "",
      userpic: json["userId"]["picture"] ?? "",
      email: json["userId"]["email"] ?? "",
      status: json["status"] ?? "",
      requestedAt: DateTime.parse(json["requestedAt"]),
      resolvedAt: json["resolvedAt"] != null
          ? DateTime.parse(json["resolvedAt"])
          : null,
      resolvedBy: json["resolvedBy"],
      message: json["message"] ?? "",
    );
  }

  /// **Method to convert Model to JSON**
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "groupId": groupId,
      "userId": {
        "_id": userId,
        "username": username,
        "email": email,
      },
      "status": status,
      "requestedAt": requestedAt.toIso8601String(),
      "resolvedAt": resolvedAt?.toIso8601String(),
      "resolvedBy": resolvedBy,
      "message": message,
    };
  }
}

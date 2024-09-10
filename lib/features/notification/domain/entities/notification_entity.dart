import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String triggerType; // awar|boos|cheer|comment
  final String title;
  final String message;

  final String? postId;
  final String? eventId;
  final String? messageId;
  final String? commentId;
  final String? groupId;
  final String? notificationImage;
  final String? userId;
  final String? userName;

  final String date;
  final String status;

  NotificationEntity({
    required this.id,
    required this.triggerType,
    required this.title,
    required this.message,
    this.postId,
    this.eventId,
    this.messageId,
    this.commentId,
    this.groupId,
    this.notificationImage,
    this.userId,
    this.userName,
    required this.date,
    required this.status,
  });

  /* 
  {
    "_id": "ObjectId",
    "userId": "String",
    "title": "String",
    "message": "String",
    "triggerType": "String",
    "data": {
      "postId": "String",
      "eventId": "String",
      "messageId": "String",
      "commentId": "String",
      "groupId": "String",
      "notificationImage": "String",
      "userId": "String",
      "userName": "String"
    },
    "timestamp": "ISODate",
    "status": "String"
}
  */

  @override
  List<Object?> get props => [id];
}

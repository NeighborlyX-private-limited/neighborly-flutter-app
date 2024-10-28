import 'dart:convert';

import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.date,
    super.postId,
    super.eventId,
    super.messageId,
    super.commentId,
    super.groupId,
    super.notificationImage,
    super.userId,
    super.userName,
    required super.triggerType,
    required super.title,
    required super.message,
    required super.status,
    required super.posttype,
  });

  @override
  String toString() {
    return 'NotificationModel(id: $id, triggerType: $triggerType, title: $title, message: $message, postId: $postId, eventId: $eventId, messageId: $messageId, commentId: $commentId, groupId: $groupId, notificationImage: $notificationImage, userId: $userId, userName: $userName, date: $date, status: $status, posttype: $posttype)';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'triggerType': triggerType,
      'title': title,
      'message': message,
      'postId': postId,
      'eventId': eventId,
      'messageId': messageId,
      'commentId': commentId,
      'groupId': groupId,
      'notificationImage': notificationImage,
      'userId': userId,
      'userName': userName,
      'date': date,
      'status': status,
      'posttype': posttype
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['_id'] ?? '',
      triggerType: map['triggerType'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      postId: map['data'] != null ? map['data']['postId'] ?? '' : '',
      eventId: map['data'] != null ? map['data']['eventId'] ?? '' : '',
      messageId: map['data'] != null ? map['data']['messageId'] ?? '' : '',
      commentId: map['data'] != null ? map['data']['commentId'] ?? '' : '',
      groupId: map['data'] != null ? map['data']['groupId'] ?? '' : '',
      notificationImage:
          map['data'] != null ? map['data']['notificationImage'] ?? '' : '',
      userId: map['data'] != null ? map['data']['userId'] ?? '' : '',
      userName: map['data'] != null ? map['data']['userName'] ?? '' : '',
      date: map['date'] ?? '',
      status: map['status'] ?? '',
      posttype: map['data'] != null ? map['data']['type'] ?? '' : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));

  static List<NotificationModel> fromJsonList(List<dynamic> json) {
    var list = <NotificationModel>[];

    if (json.isNotEmpty) {
      list = json
          .map<NotificationModel>(
              (jsomItem) => NotificationModel.fromMap(jsomItem))
          .toList();
    }

    return list;
  }
}

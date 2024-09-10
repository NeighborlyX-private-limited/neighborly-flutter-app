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
  });

  @override
  String toString() {
    return 'NotificationModel(id: $id, triggerType: $triggerType, title: $title, message: $message, postId: $postId, eventId: $eventId, messageId: $messageId, commentId: $commentId, groupId: $groupId, notificationImage: $notificationImage, userId: $userId, userName: $userName, date: $date, status: $status)';
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
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      triggerType: map['triggerType'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      postId: map['data']['postId'].toString(),
      eventId: map['data']['eventId'],
      messageId: map['data']['messageId'],
      commentId: map['data']['commentId'],
      groupId: map['data']['groupId'],
      notificationImage: map['data']['notificationImage'],
      userId: map['data']['userId'],
      userName: map['data']['userName'],
      date: map['date'] ?? '',
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));

  static List<NotificationModel> fromJsonList(List<dynamic> json) {
    var list = <NotificationModel>[];
    // print('list: ${json}');

    if (json.isNotEmpty) {
      list = json
          .map<NotificationModel>(
              (jsomItem) => NotificationModel.fromMap(jsomItem))
          .toList();
    }

    return list;
  }
}

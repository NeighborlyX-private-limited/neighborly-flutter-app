import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String triggerType;
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
  final String timestamp;
  final String status;
  final String posttype;

  const NotificationEntity({
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
    required this.timestamp,
    required this.status,
    required this.posttype,
  });

  @override
  List<Object?> get props => [id];
}

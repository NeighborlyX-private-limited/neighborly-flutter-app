// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../../chat/data/model/chat_room_model.dart';
import '../../data/model/notification_model.dart';

class NotificationTileWidget extends StatelessWidget {
  final NotificationModel notification;

  NotificationTileWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  List<Widget> listWidgets = [];

  Widget leftAvatar() {
    print('notification.user=${notification.notificationImage}');
    if (notification.notificationImage == null)
      return SizedBox(width: 30, height: 30);

    return UserAvatarStyledWidget(
      avatarUrl: notification.notificationImage!,
      avatarSize: 23,
      avatarBorderSize: 0,
    );
  }

  // Widget rightAvatar() {
  //   if (notification.notificationImage == null) return SizedBox(width: 30, height: 30);

  //   return UserAvatarSquareWidget(
  //     imageUrl: notification.notificationImage,
  //     size: 50,
  //     borderRadius: 10,
  //   );
  // }

  String timeAgoArea(String lastMessageDate) {
    if (lastMessageDate == '') return lastMessageDate;

    DateFormat format = DateFormat("yyyy-MM-dd");
    DateFormat dateFormatSimple = DateFormat('dd/MM/yyyy');
    DateTime dateTime = format.parse(lastMessageDate);
    String timeAgo = timeago.format(dateTime);

    if (isDateWithinLastMonth(dateTime)) {
      return timeAgo;
    } else {
      return dateFormatSimple.format(dateTime);
    }
  }

  bool isDateWithinLastMonth(DateTime date) {
    DateTime now = DateTime.now();
    DateTime oneMonthAgo = DateTime(
        now.year, now.month - 1, now.day, now.hour, now.minute, now.second);

    return date.isAfter(oneMonthAgo);
  }

  void buildMainArea(BuildContext context) {
    // if (notification.messageId != null)

    if (notification.messageId != null) {
      listWidgets.add(GestureDetector(
        onTap: () {
          print('GOTO: /userProfileScreen/${notification.userId}');
          // context.push('/userProfileScreen/${notification.userId}');
        },
        child: Text(
          notification.userName ?? 'user',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
    }

    listWidgets.add(Text(notification.message));

    // if(notification.action ==)

    listWidgets.add(Text(timeAgoArea(notification.date)));
  }

  @override
  Widget build(BuildContext context) {
    buildMainArea(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      child: Row(
        children: [
          leftAvatar(),
          //
          //
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                // if (notification.postId != null) {
                //   context.push('/userProfileScreen/${notification.userId}');
                // }

                if (notification.postId != null) {
                  // context.push('/post-detail/${notification.postId}/true/${notification.userId}');
                  print(
                      '/post-detail/${notification.postId}/true/${notification.userId}');
                }

                if (notification.eventId != null) {
                  // context.push('/events/detail/:eventId/${notification.eventId}');
                  print('/events/detail/:eventId/${notification.eventId}');
                }

                if (notification.groupId != null) {
                  // context.push('/groups/${notification.groupId}');
                  print('/groups/${notification.groupId}');
                }

                if (notification.messageId != null) {
                  context.push(
                    '/chat/private/${notification.notificationImage}',
                    extra: ChatRoomModel(
                        id: notification.messageId!,
                        name: notification.userName ?? '.-.',
                        avatarUrl: notification.notificationImage!,
                        lastMessage: '',
                        lastMessageDate: '',
                        isMuted: false,
                        isGroup: false,
                        unreadCount: 1),
                  );
                }
              },
              child: Wrap(
                runSpacing: 4,
                spacing: 5,
                children: listWidgets.map((e) => e).toList(),
              ),
            ),
          )),
          //
          //
          // rightAvatar(),
        ],
      ),
    );
  }
}

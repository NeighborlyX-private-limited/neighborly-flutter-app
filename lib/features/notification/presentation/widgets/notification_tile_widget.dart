// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../data/model/notification_model.dart';
import '../../../notification/data/data_sources/notification_remote_data_source/notification_remote_data_source_impl.dart';

class NotificationTileWidget extends StatelessWidget {
  final NotificationModel notification;

  NotificationTileWidget({
    super.key,
    required this.notification,
  });

  List<Widget> listWidgets = [];

  Widget leftAvatar() {
    return UserAvatarStyledWidget(
      avatarUrl: notification.notificationImage == null ||
              notification.notificationImage == ''
          ? "https://img.freepik.com/fotos-gratis/especialista-em-seguranca-cibernetica-a-trabalhar-com-tecnologia-em-luzes-de-neon_23-2151645661.jpg?t=st=1722573533~exp=1722577133~hmac=fc9a6c66bed1aef3fad7541423c49fa69ea858159e8d3d6903039c7edf5dde65&w=360"
          : notification.notificationImage!,
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

    //listWidgets.add(Text(timeAgoArea('2024-10-31T19:30:15.359Z')));
  }

  Color tileColor = Color(0xFFF0F0F0);
  @override
  Widget build(BuildContext context) {
    buildMainArea(context);
    return Container(
      color: notification.status == "unread" ? Color(0xFFF0F0F0) : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      width: double.infinity,
      child: Row(
        children: [
          leftAvatar(),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () async {
                if (notification.status == "unread") {
                  await updateNotificationStatus(notification.id);
                }

                print(notification);
                bool ispost = notification.posttype == 'post';
                print('notification ${notification.posttype}');
                print('notification ${notification.userId}');
                String commentid = '0';
                if (notification.title == 'You’ve Got a Comment!') {
                  commentid = notification.commentId ?? '0';
                }
                if (notification.postId != null) {
                  context.push(
                      '/post-detail/${notification.postId}/${ispost.toString()}/${notification.userId}/$commentid');
                  print(
                      '/post-detail/${notification.postId}/${ispost.toString()}/${notification.userId}/0');
                }

                /*
                TODO: Vinay here you have to add navigation for profile. Check with bharat whether we will get profile notification or not
                only then its required to implment 
                */

                // if (notification.eventId != null) {
                //   // context.push('/events/detail/:eventId/${notification.eventId}');
                //   print('/events/detail/:eventId/${notification.eventId}');
                // }

                // if (notification.groupId != null) {
                //   // context.push('/groups/${notification.groupId}');
                //   print('/groups/${notification.groupId}');
                // }

                // if (notification.messageId != null) {
                //   context.push(
                //     '/chat/private/${notification.notificationImage}',
                //     extra: ChatRoomModel(
                //         id: notification.messageId!,
                //         name: notification.userName ?? '.-.',
                //         avatarUrl: notification.notificationImage!,
                //         lastMessage: '',
                //         lastMessageDate: '',
                //         isMuted: false,
                //         isGroup: false,
                //         unreadCount: 1),
                //   );
                // }
              },
              child: Wrap(
                runSpacing: 4,
                spacing: 5,
                children: listWidgets.map((e) => e).toList(),
              ),
            ),
          )),
          Text(
            formatTimeDifference(notification.timestamp),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../data/model/notification_model.dart';

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

  void buildMainArea(BuildContext context) {
    if (notification.messageId != null) {
      listWidgets.add(
        GestureDetector(
          onTap: () {},
          child: Text(
            notification.userName ?? 'user',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    listWidgets.add(Text(notification.message));
  }

  @override
  Widget build(BuildContext context) {
    buildMainArea(context);
    return Container(
      color: notification.status == "unread"
          ? Color(0xFFF0F0F0)
          : AppColors.whiteColor,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: double.infinity,
      child: Row(
        children: [
          leftAvatar(),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () {
                // SPECIFIC COMMENT SCREEN REDIRECTION
                if (notification.triggerType == 'AwardTrigger' &&
                    (notification.postId == null ||
                        notification.postId == '') &&
                    notification.commentId != null) {
                  context.push(
                      '/post-detail-of-specific-comment/${notification.commentId}');
                }
                // GROUP DETAIL SCREEN REDIRECTION
                else if (notification.triggerType == 'GroupTrigger') {
                  context.push('/group-details/${notification.groupId}');
                }
                // GROUP CHAT SCREEN REDIRECTION
                else if (notification.triggerType == 'MessageTrigger') {
                  context.push('/group-chat/${notification.groupId}');
                }
                // POST DETAIL SCREEN REDIRECTION
                else if (notification.triggerType == 'PostTrigger' ||
                    notification.triggerType == 'CommentTrigger' ||
                    notification.triggerType == 'AwardTrigger' ||
                    notification.triggerType == 'ReplyTrigger') {
                  context.push('/post-detail/${notification.postId}');
                }
                // POST DETAIL SCREEN REDIRECTION
                else if (notification.postId != null) {
                  context.push('/post-detail/${notification.postId}');
                }
              },
              child: Wrap(
                runSpacing: 4,
                spacing: 5,
                children: listWidgets.map((e) => e).toList(),
              ),
            ),
          )),
          Text(
            getTimeAgo(notification.timestamp),
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

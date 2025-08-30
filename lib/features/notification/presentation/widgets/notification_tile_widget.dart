// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../data/model/notification_model.dart';

class NotificationTileWidget extends StatelessWidget {
  final NotificationModel notification;
  final List<String> iconArray = [];

  NotificationTileWidget({
    super.key,
    required this.notification,
  });

  List<Widget> listWidgets = [];

  Widget leftAvatar() {
    print('what is icon: ${notification.icon}');
    print('type: ${notification.triggerType}');
    String assetPath;
    switch (notification.triggerType) {
      case 'CommentTrigger':
        assetPath = 'assets/image/comment_notification.png';
        break;
      case 'GroupTrigger':
        assetPath = 'assets/image/group_notification.png';
        break;
      case 'PostTrigger':
        assetPath = 'assets/image/new_post_notification.png';
        break;
      case 'ReplyTrigger':
        assetPath = 'assets/image/reply_notification.png';
        break;

      default:
        assetPath = 'assets/image/comment_notification.png';
    }
    print('path: $assetPath');
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        //border: Border.all(color: AppColors.lightGreyColor),
      ),
      //clipBehavior: Clip.antiAlias, // Ensures smooth edges
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: notification.icon != null
            ? Image.network(notification.icon!)
            : Image.asset(
                notification.icon ?? assetPath,
                fit: BoxFit.cover, // Makes it fill the circle
                alignment: Alignment.center, // Centers the image
              ),
      ),
    );

    // return UserAvatarStyledWidget(
    //   avatarUrl: assetPath,
    //   avatarSize: 23,
    //   avatarBorderSize: 0,
    // );
  }

  void buildMainArea(BuildContext context) {
    if (notification.messageId != null) {
      listWidgets.add(
        GestureDetector(
          onTap: () {},
          child: Text(
            '${notification.title} ',
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

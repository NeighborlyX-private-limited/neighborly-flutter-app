import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/constants/app_images.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/svg_icon.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../data/model/chat_room_model.dart';

class ChatTileWidget extends StatelessWidget {
  final ChatRoomModel room;
  final Function(ChatRoomModel) onTap;

  const ChatTileWidget({
    super.key,
    required this.room,
    required this.onTap,
  });
  // MESSAGE UNREAD BUBBLE
  Widget unreadCounter(int value) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Container(
        constraints: BoxConstraints(minWidth: 24),
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '$value',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(room);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        color: AppColors.whiteColor,
        child: Row(
          children: [
            UserAvatarStyledWidget(
              avatarUrl: room.avatarUrl,
              avatarSize: 22,
              avatarBorderSize: 0,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: bodyBlackTextStyle,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTimeAgo(room.lastMessageDate),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: smallGreyTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.lastMessage == ''
                              ? 'No message so far'
                              : room.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: mediumGreyTextStyle.copyWith(
                            color: AppColors.lightGreyColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 65,
                      ),
                      Visibility(
                        visible: room.isMuted,
                        child: CircularSvgImage(
                          assetPath: AppImages.muteIcon,
                          color: AppColors.lightGreyColor,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

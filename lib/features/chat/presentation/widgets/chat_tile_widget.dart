import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/theme/colors.dart';
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

  Widget unreadCounter(int value) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Container(
        constraints: BoxConstraints(minWidth: 23),
        height: 23,
        // width: 23,
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

  bool isDateWithinLastMonth(DateTime date) {
    DateTime now = DateTime.now();
    DateTime oneMonthAgo = DateTime(
        now.year, now.month - 1, now.day, now.hour, now.minute, now.second);

    return date.isAfter(oneMonthAgo);
  }

  String timeAgoArea(String lastMessageDate) {
    if (lastMessageDate == '') return lastMessageDate;
     DateTime parsedDate = DateTime.parse(lastMessageDate);

    // Format the date as "YYYY-MM-DD HH:mm:ss"
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat dateFormatSimple = DateFormat('dd/MM/yyyy');
    DateTime dateTime = format.parse(formattedDate);
    String timeAgo = timeago.format(dateTime);

    if (isDateWithinLastMonth(dateTime)) {
      return timeAgo;
    } else {
      return dateFormatSimple.format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    // DateTime lastMessageDate = room.lastMessageDate == '' ? DateTime.now() : DateUtilsHelper.dateFormatter(room.lastMessageDate);

    return InkWell(
      onTap: () {
        onTap(room);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: [
            
            UserAvatarStyledWidget(
              avatarUrl: room.avatarUrl,
              avatarSize: 22,
              avatarBorderSize: 0,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
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
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        timeAgoArea(room.lastMessageDate),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: room.unreadCount > 0
                              ? AppColors.primaryColor
                              : Colors.grey,
                        ),
                      ),
                      if (room.unreadCount > 0)
                        unreadCounter(room.unreadCount),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.lastMessage == ''
                              ? 'no message so far'
                              : room.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black45),
                        ),
                      ),
                      const SizedBox(
                        width: 65,
                      ),
                      Visibility(
                        visible: room.isMuted,
                        child: SvgPicture.asset(
                          'assets/mute_filled.svg',
                          width: 20,
                          height: 20,
                          colorFilter:
                              ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                        ),
                      )
                    ],
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}

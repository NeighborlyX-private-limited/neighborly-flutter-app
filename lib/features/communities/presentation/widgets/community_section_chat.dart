import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../../chat/data/model/chat_room_model.dart';

class CommunitySectionChat extends StatefulWidget {
  final CommunityModel community;
  const CommunitySectionChat({
    super.key,
    required this.community,
  });

  @override
  State<CommunitySectionChat> createState() => _CommunitySectionChatState();
}

class _CommunitySectionChatState extends State<CommunitySectionChat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.whiteColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 8,
              color: const Color.fromARGB(255, 239, 239, 252),
            ),
            TileChat(
              name: widget.community.name,
              avatarUrl: widget.community.avatarUrl,
              lastMessage: widget.community.lastMessage,
              lastMessageTime: formatTimeDifference(
                widget.community.lastMessageTime,
              ),
              onTap: () {
                context.push(
                  '/group-chat/${widget.community.id}',
                  extra: {
                    'chatModel': ChatRoomModel(
                      id: widget.community.id,
                      name: widget.community.name,
                      avatarUrl: widget.community.avatarUrl,
                      lastMessage: widget.community.lastMessage,
                      lastMessageDate: formatTimeDifference(
                        widget.community.lastMessageTime,
                      ),
                      isMuted: widget.community.isMuted,
                      isJoined: widget.community.isJoined,
                      isGroup: true,
                      unreadCount: 0,
                    ),
                    'membersList': widget.community.users,
                    'adminsList': widget.community.admins,
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TileChat extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String lastMessageTime;
  final VoidCallback onTap;

  const TileChat({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // COMMUNITY ICON

                UserAvatarStyledWidget(
                  avatarUrl: avatarUrl,
                  avatarSize: 18,
                  avatarBorderSize: 0,
                ),
                const SizedBox(width: 15),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // GROUP NAME
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      // LAST MESSAGE
                      Text(
                        lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                //LAST MESSAGE TIME
                Text(
                  lastMessageTime,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

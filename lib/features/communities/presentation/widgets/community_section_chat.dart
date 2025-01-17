import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/theme/colors.dart';
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
    double space = 6;
    return Container(
      width: double.infinity,
      color: AppColors.whiteColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: space),
            TileChat(
              name: widget.community.name,
              avatarUrl: widget.community.avatarUrl,
              lastMessage: "This is the last message",
              lastMessageTime: DateTime.now().toIso8601String(),
              onTap: () {
                context.push(
                  '/chat/group/${widget.community.id}',
                  extra: ChatRoomModel(
                    id: widget.community.id,
                    name: widget.community.name,
                    avatarUrl: widget.community.avatarUrl,
                    lastMessage: '',
                    lastMessageDate: DateTime.now().toIso8601String(),
                    isMuted: widget.community.isMuted,
                    isGroup: true,
                    unreadCount: 0,
                  ),
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
                // Avatar
                UserAvatarStyledWidget(
                  avatarUrl: avatarUrl,
                  avatarSize: 18,
                  avatarBorderSize: 0,
                ),
                const SizedBox(width: 15),

                // Name, Last Message, and Time
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chat Name
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

                      // Last Message
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

                // Time
                Text(
                  _formatTime(lastMessageTime),
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

  // Helper function to format time
  String _formatTime(String isoTime) {
    final dateTime = DateTime.parse(isoTime);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    } else {
      return "${dateTime.hour}:${dateTime.minute}";
    }
  }
}

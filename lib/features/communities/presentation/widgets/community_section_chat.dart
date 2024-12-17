import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../../chat/data/model/chat_room_model.dart';

class CommunitySectionChat extends StatelessWidget {
  final CommunityModel community;
  const CommunitySectionChat({
    super.key,
    required this.community,
  });

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
              name: community.name,
              avatarUrl: community.avatarUrl,
              onTap: () {
                context.push(
                  '/chat/group/${community.id}',
                  extra: ChatRoomModel(
                    id: community.id,
                    name: community.name,
                    avatarUrl: community.avatarUrl,
                    lastMessage: '',
                    lastMessageDate: DateTime.now().toIso8601String(),
                    isMuted: false,
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
  final VoidCallback onTap;
  const TileChat({
    super.key,
    required this.name,
    required this.avatarUrl,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserAvatarStyledWidget(
                    avatarUrl: avatarUrl,
                    avatarSize: 18,
                    avatarBorderSize: 0,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 50,
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

// class MembersList extends StatefulWidget {
//   final String name;
//   final String avatarUrl;

//   const MembersList({
//     Key? key,
//     required this.name,
//     required this.avatarUrl,
//   }) : super(key: key);

//   @override
//   State<MembersList> createState() => _MembersListState();
// }

// class _MembersListState extends State<MembersList> {

//   @override
//   Widget build(BuildContext context) {
//     final bool hasMembers = (widget.members.length + widget.admins.length) > 0;

//     return Container(
//       padding: EdgeInsets.all(15),
//       width: double.infinity,
//       color: Colors.white,
//       child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           UserAvatarStyledWidget(
//             avatarUrl: user.avatarUrl,
//             avatarSize: 18,
//             avatarBorderSize: 0,
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             flex: 50,
//             child: Text(
//               user.name,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ),

//         ],
//       ),
//     )
//     );
//   }
// }

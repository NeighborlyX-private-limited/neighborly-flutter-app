import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';

class CommunitySectionAbout extends StatelessWidget {
  final CommunityModel community;
  const CommunitySectionAbout({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.whiteColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DescriptionArea(description: community.description),
            Divider(),
            TextAndIconArea(
              title: 'Karma',
              text: '${community.karma}',
              svgPath: 'assets/karma.svg',
            ),
            TextAndIconArea(
              title: 'Radius',
              text: '${community.radius} miles',
              icon: Icons.pin_drop_outlined,
            ),
            Divider(),
            MembersList(
              members: community.users,
              admins: community.admins,
            ),
          ],
        ),
      ),
    );
  }
}

///description area
class DescriptionArea extends StatelessWidget {
  final String description;
  const DescriptionArea({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Group Description',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          ReadMoreText(
            description,
            trimLines: 2,
            style: TextStyle(fontSize: 14, height: 1.3),
            trimMode: TrimMode.Line,
            trimCollapsedText: ' See more',
            trimExpandedText: ' See less',
            moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.blue,
            ),
            lessStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

///text and icon area
class TextAndIconArea extends StatelessWidget {
  final String title;
  final String text;
  final IconData? icon;
  final double? iconSize;
  final String? svgPath;
  const TextAndIconArea({
    super.key,
    required this.title,
    required this.text,
    this.icon = Icons.abc,
    this.svgPath = '',
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              svgPath != ''
                  ? SvgPicture.asset(
                      svgPath!,
                      width: iconSize,
                    )
                  : Icon(
                      icon,
                      size: iconSize,
                    ),
              const SizedBox(width: 5),
              Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

///member and admin list area
class MembersList extends StatefulWidget {
  final List<UserSimpleModel> members;
  final List<UserSimpleModel> admins;

  const MembersList({
    super.key,
    required this.members,
    required this.admins,
  });

  @override
  State<MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  bool showAll = false;

  Widget isAdminBubble() {
    return Container(
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.lightBackgroundColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          'Admin',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
        ),
      ),
    );
  }

  Widget userTile(UserSimpleModel user, bool isAdmin) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserAvatarStyledWidget(
            avatarUrl: user.avatarUrl,
            avatarSize: 18,
            avatarBorderSize: 0,
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 50,
            child: Text(
              user.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (isAdmin) ...[
            const SizedBox(width: 5),
            Expanded(
              flex: 20,
              child: isAdminBubble(),
            ),
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasMembers = (widget.members.length + widget.admins.length) > 0;

    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Members list',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          if (hasMembers == false)
            Text(
              'No Members',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          if (hasMembers == true) ...[
            ...widget.admins.map((adm) => userTile(adm, true)),
            ...widget.members
                .take(showAll == true ? widget.members.length : 5)
                .map((user) => userTile(user, false)),
            showAll == false && widget.members.length > 5
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showAll = !showAll;
                        });
                      },
                      child: Text(
                        'View All Members',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ],
      ),
    );
  }
}

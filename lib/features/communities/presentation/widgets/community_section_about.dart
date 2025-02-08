import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            Container(
              height: 8,
              color: const Color.fromARGB(255, 239, 239, 252),
            ),
            DescriptionArea(description: community.description),
            Container(
              height: 8,
              color: const Color.fromARGB(255, 239, 239, 252),
            ),
            TextAndIconArea(
              title: AppLocalizations.of(context)!.karma,
              text: '${community.karma}',
              svgPath: 'assets/karma.svg',
            ),
            Container(
              height: 8,
              color: const Color.fromARGB(255, 239, 239, 252),
            ),
            TextAndIconArea(
              title: AppLocalizations.of(context)!.radius,
              text:
                  '${community.radius} ${AppLocalizations.of(context)!.miles}',
              icon: Icons.pin_drop_outlined,
            ),
            Container(
              height: 8,
              color: const Color.fromARGB(255, 239, 239, 252),
            ),
            MembersList(
              members: community.users,
              admins: community.admins,
            ),
            Container(
              height: 8,
              color: const Color.fromARGB(255, 239, 239, 252),
            ),
          ],
        ),
      ),
    );
  }
}

/// description area
class DescriptionArea extends StatelessWidget {
  final String description;
  const DescriptionArea({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.group_Description,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Linkify(
            options: LinkifyOptions(
              looseUrl: true,
            ),
            onOpen: (link) async {
              if (await canLaunchUrl(Uri.parse(link.url))) {
                await launchUrl(Uri.parse(link.url),
                    mode: LaunchMode.externalApplication);
              } else {
                throw "Could not launch ${link.url}";
              }
            },
            text: description,
            style: const TextStyle(fontSize: 16),
            linkStyle: const TextStyle(
              color: AppColors.primaryColor,
            ),
          )
          // ReadMoreText(
          //   description,
          //   trimLines: 2,
          //   style: TextStyle(fontSize: 14, height: 1.3),
          //   trimMode: TrimMode.Line,
          //   trimCollapsedText: AppLocalizations.of(context)!.see_more,
          //   trimExpandedText: AppLocalizations.of(context)!.see_less,
          //   moreStyle: TextStyle(
          //     fontSize: 14,
          //     fontWeight: FontWeight.normal,
          //     color: Colors.blue,
          //   ),
          //   lessStyle: TextStyle(
          //     fontSize: 14,
          //     fontWeight: FontWeight.normal,
          //     color: Colors.blue,
          //   ),
          // ),
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          AppLocalizations.of(context)!.admin,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
        ),
      ),
    );
  }

  bool checkIsAdmin(UserSimpleModel user) {
    bool isAdmin = widget.admins.any((adm) => adm.id == user.id);
    return isAdmin;
  }

  Widget userTile(UserSimpleModel user, bool isAdmin) {
    isAdmin = checkIsAdmin(user);
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
            AppLocalizations.of(context)!.member_list,
            // 'Members list',
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
              AppLocalizations.of(context)!.no_Members,
              //  'No Members',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          if (hasMembers == true) ...[
            //...widget.admins.map((adm) => userTile(adm, true)),
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
                        AppLocalizations.of(context)!.view_All_Members,
                        //  'View All Members',
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

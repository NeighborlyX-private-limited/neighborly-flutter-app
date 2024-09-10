import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/community_model.dart';

class CommunityAdminSetScreen extends StatelessWidget {
  final CommunityModel community;

  const CommunityAdminSetScreen({
    Key? key,
    required this.community,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'General',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              //
              //
              const SizedBox(height: 5),
              MenuIconItem(
                title: 'Member list',
                svgPath: 'assets/menu_members.svg',
                iconSize: 25,
                onTap: () {
                  context.push('/groups/admin/members');
                },
              ),
              //
              //
              const SizedBox(height: 5),
              MenuIconItem(
                title: 'Community Icon',
                svgPath: 'assets/menu_icon.svg',
                iconSize: 25,
                onTap: () {
                  context.push('/groups/admin/icon');
                },
              ),
              //
              //
              const SizedBox(height: 5),
              MenuIconItem(
                title: 'Description',
                svgPath: 'assets/menu_description.svg',
                iconSize: 25,
                onTap: () {
                  context.push('/groups/admin/description');
                },
              ),
              //
              //
              const SizedBox(height: 5),
              MenuIconItem(
                title: 'Location',
                svgPath: 'assets/menu_location.svg',
                iconSize: 25,
                onTap: () {
                  context.push('/groups/admin/location');
                },
              ),
              //
              //
              const SizedBox(height: 5),
              MenuIconItem(
                title: 'Radius',
                svgPath: 'assets/menu_location_.svg',
                iconSize: 25,
                onTap: () {
                  context.push('/groups/admin/radius');
                },
              ),
              //
              //
              const SizedBox(height: 5),
              MenuIconItem(
                title: 'Community Type',
                svgPath: 'assets/menu_type.svg',
                iconSize: 25,
                onTap: () {
                  context.push('/groups/admin/type');
                },
              ),
              //
              //
              const SizedBox(height: 5),
              MenuIconItem(
                title: 'Blocked users',
                svgPath: 'assets/menu_block.svg',
                iconSize: 25,
                onTap: () {
                  print('Tapped');
                  context.push('/groups/admin/blocked');
                },
              ),
              //
              //
              const SizedBox(
                height: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ########################################################################
// ########################################################################
// ########################################################################

class MenuIconItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final double? iconSize;
  final String? svgPath;
  final VoidCallback onTap;
  const MenuIconItem({
    Key? key,
    required this.title,
    this.icon = Icons.abc,
    this.iconSize = 20,
    this.svgPath = '',
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: InkWell(
        onTap: onTap,
        child: Row(
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
            const SizedBox(width: 10),
            Text(
              '${title}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 18,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

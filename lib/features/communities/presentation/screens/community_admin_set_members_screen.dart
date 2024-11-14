import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/menu_icon_widget.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../bloc/community_detail_cubit.dart';

class CommunityAdminMembersUsersScreen extends StatefulWidget {
  const CommunityAdminMembersUsersScreen({
    super.key,
  });

  @override
  State<CommunityAdminMembersUsersScreen> createState() =>
      _CommunityAdminMembersUsersScreenState();
}

class _CommunityAdminMembersUsersScreenState
    extends State<CommunityAdminMembersUsersScreen> {
  late CommunityDetailsCubit communityCubit;
  late List<UserSimpleModel> members;
  late List<UserSimpleModel> admins;

  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);

    members = communityCubit.state.community?.users != null
        ? [...communityCubit.state.community!.users]
        : [];
    admins = communityCubit.state.community?.admins != null
        ? [...communityCubit.state.community!.admins]
        : [];
  }

  void removeUser(BuildContext context, String communityId, String userId) {
    communityCubit.unblockUser(communityId, userId);

    setState(() {
      members = members.where((element) => element.id != userId).toList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User removed'),
        ),
      );
    });
  }

  void makeAdmin(BuildContext context, String communityId, String userId) {
    communityCubit.makeAdmin(communityId, userId);
    var newAdmin = members.firstWhere((element) => element.id == userId);

    print('newAdmin=$newAdmin');

    setState(() {
      members = members.where((element) => element.id != userId).toList();
      admins = [newAdmin, ...admins];
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'User transformed. \nWith great power comes great responsabilities'),
        ),
      );
    });
  }

  Future<dynamic> bottomSheetConfirm(BuildContext context, String userId) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // String? userId = ShardPrefHelper.getUserID();
        return Container(
          color: Colors.white,
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you make this person Admin?',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50), // Ajuste o raio conforme necessário
                        ),
                        // padding: EdgeInsets.all(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.black, fontSize: 18, height: 0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        communityCubit.leaveCommunity();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff635BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50), // Ajuste o raio conforme necessário
                        ),
                        // padding: EdgeInsets.all(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                              color: Colors.white, fontSize: 18, height: 0.3),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> bottomSheetMenu(BuildContext context, String userId) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // String? userId = ShardPrefHelper.getUserID();
        return Container(
          color: Colors.white,
          height: 150,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MenuIconItem(
                  title: 'Make Admin',
                  svgPath: 'assets/menu_make_admin.svg',
                  iconSize: 25,
                  onTap: () {
                    Navigator.pop(context);
                    bottomSheetConfirm(context, userId);
                  }),
              MenuIconItem(
                  title: 'Remove from community',
                  svgPath: 'assets/menu_remove.svg',
                  iconSize: 25,
                  textColor: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    removeUser(context,
                        communityCubit.state.community?.id ?? '', userId);
                  }),
            ],
          ),
        );
      },
    );
  }

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

  Widget userTile(BuildContext context, UserSimpleModel user, bool isAdmin) {
    return GestureDetector(
      onTap: () {
        bottomSheetMenu(context, user.id);
      },
      child: Padding(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasMembers = members.isNotEmpty || admins.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
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
          'Members list',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (hasMembers == false)
              Expanded(
                child: Center(
                  child: Text(
                    'No Members',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            //
            //
            ...admins.map((adm) => userTile(context, adm, true)),
            ...members.map((adm) => userTile(context, adm, false)),
            //
            //
          ],
        ),
      ),
    );
  }
}

// ########################################################################
// ########################################################################
// ########################################################################

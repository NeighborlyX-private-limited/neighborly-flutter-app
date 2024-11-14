import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../bloc/community_detail_cubit.dart';

class CommunityAdminBlockedUsersScreen extends StatefulWidget {
  const CommunityAdminBlockedUsersScreen({
    super.key,
  });

  @override
  State<CommunityAdminBlockedUsersScreen> createState() =>
      _CommunityAdminBlockedUsersScreenState();
}

class _CommunityAdminBlockedUsersScreenState
    extends State<CommunityAdminBlockedUsersScreen> {
  late CommunityDetailsCubit communityCubit;
  late List<UserSimpleModel> blockedMembers;

  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);

    blockedMembers = communityCubit.state.community?.blockList != null
        ? [...communityCubit.state.community!.blockList]
        : [];
  }

  void removeUser(BuildContext context, String communityId, String userId) {
    communityCubit.unblockUser(communityId, userId);

    setState(() {
      blockedMembers =
          blockedMembers.where((element) => element.id != userId).toList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User unblocked'),
        ),
      );
    });
  }

  Future<dynamic> bottomSheet(BuildContext context, String userId) {
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
                'Are you sure you whant to Unlock this person?',
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
                        removeUser(context,
                            communityCubit.state.community?.id ?? '', userId);
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

  Widget userTile(BuildContext context, UserSimpleModel user, bool isAdmin) {
    return GestureDetector(
      onTap: () {
        bottomSheet(context, user.id);
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
            // if (isAdmin) ...[
            //   const SizedBox(width: 5),
            //   Expanded(
            //     flex: 20,
            //     child: isAdminBubble(),
            //   ),
            // ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasMembers = blockedMembers.isNotEmpty;

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
          'Blocked User',
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
            ...blockedMembers.map((adm) => userTile(context, adm, true)),
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

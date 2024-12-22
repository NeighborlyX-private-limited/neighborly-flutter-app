import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/constants/status.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/add_remove_user_in_group_bloc.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/join_group_bloc.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/make_remove_admin_bloc.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/update_block_user_bloc.dart';
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
  late String communityId;
  String myUserId = '';

  ///init state method
  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    communityId = communityCubit.state.community?.id ?? '';
    members = communityCubit.state.community?.users != null
        ? [...communityCubit.state.community!.users]
        : [];
    admins = communityCubit.state.community?.admins != null
        ? [...communityCubit.state.community!.admins]
        : [];
    getuserId();
  }

  ///get user id
  void getuserId() {
    myUserId = ShardPrefHelper.getUserID() ?? '';
    setState(() {});
  }

  ///make admin confirm bottom sheet
  Future<dynamic> bottomSheetMakeAdminConfirm(
    BuildContext context,
    String userId,
  ) {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 150,
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
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            height: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 40,
                    child:
                        BlocConsumer<MakeRemoveAdminBloc, MakeRemoveAdminState>(
                      listener: (context, state) {
                        ///failure state
                        if (state is MakeRemoveAdminFailureState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                            ),
                          );
                        }

                        ///success state
                        if (state is MakeAdminSuccessState) {
                          communityCubit.getCommunityDetail(communityId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Admin made'),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        ///loading state
                        if (state is MakeRemoveAdminLoadingState) {
                          return CircularProgressIndicator(
                            color: AppColors.whiteColor,
                          );
                        }
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            BlocProvider.of<MakeRemoveAdminBloc>(context)
                                .add(MakeAdminButtonPressedEvent(
                              communityId: communityId,
                              userId: userId,
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff635BFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 0.3,
                              ),
                            ),
                          ),
                        );
                      },
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

  ///remove admin confirm bottom sheet
  Future<dynamic> bottomSheetRemoveAdminConfirm(
    BuildContext context,
    String userId,
  ) {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 180,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to remove this person from Admin post?',
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
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            height: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 40,
                    child:
                        BlocConsumer<MakeRemoveAdminBloc, MakeRemoveAdminState>(
                      listener: (context, state) {
                        /// failure state
                        if (state is MakeRemoveAdminFailureState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                            ),
                          );
                        }

                        /// success state
                        if (state is RemoveAdminSuccessState) {
                          communityCubit.getCommunityDetail(communityId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Admin remove'),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        ///loading state
                        if (state is MakeRemoveAdminLoadingState) {
                          return CircularProgressIndicator(
                            color: AppColors.whiteColor,
                          );
                        }
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            BlocProvider.of<MakeRemoveAdminBloc>(context)
                                .add(RemoveAdminButtonPressedEvent(
                              communityId: communityId,
                              userId: userId,
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff635BFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 0.3,
                              ),
                            ),
                          ),
                        );
                      },
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

  ///remove user confirm bottom sheet
  Future<dynamic> bottomSheetConfirmRemove(
    BuildContext context,
    String userId,
  ) {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 140,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to remove this person from community?',
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
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            height: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 40,
                    child: BlocConsumer<AddRemoveUserInGroupBloc,
                        AddRemoveUserInGroupState>(
                      ///failure state
                      listener: (context, state) {
                        if (state is AddRemoveUserInGroupFailureState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                            ),
                          );
                        }

                        ///success state
                        if (state is RemoveUserInGroupSuccessState) {
                          communityCubit.getCommunityDetail(communityId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User removed'),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        ///loading state
                        if (state is AddRemoveUserInGroupLoadingState) {
                          return CircularProgressIndicator(
                            color: AppColors.whiteColor,
                          );
                        }
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            BlocProvider.of<AddRemoveUserInGroupBloc>(context)
                                .add(RemoveUserInGroupButtonPressedEvent(
                              communityId: communityId,
                              userId: userId,
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff635BFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 0.3,
                              ),
                            ),
                          ),
                        );
                      },
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

  ///leave community confirm bottom sheet
  Future<dynamic> bottomSheetLeaveConfirm(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 140,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to leave this community?',
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
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            height: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 40,
                    child: BlocConsumer<JoinGroupBloc, JoinGroupState>(
                      listener: (context, state) {
                        ///failure state
                        if (state is JoinGroupFailureState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                            ),
                          );
                        }

                        ///success state
                        if (state is LeaveGroupSuccessState) {
                          communityCubit.getCommunityDetail(communityId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Group leaved'),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        ///loading state
                        if (state is JoinGroupLoadingState) {
                          return CircularProgressIndicator(
                            color: AppColors.whiteColor,
                          );
                        }
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            BlocProvider.of<JoinGroupBloc>(context)
                                .add(LeaveGroupButtonPressedEvent(
                              communityId: communityId,
                            ));

                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff635BFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 0.3,
                              ),
                            ),
                          ),
                        );
                      },
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

  ///block user confirm bottom sheet
  Future<dynamic> bottomSheetBlockConfirm(
    BuildContext context,
    String userId,
  ) {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 140,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to block this user?',
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
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            height: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 40,
                    child:
                        BlocConsumer<UpdateBlockUserBloc, UpdateBlockUserState>(
                      listener: (context, state) {
                        ///failure state
                        if (state is UpdateBlockUserFailureState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                            ),
                          );
                        }

                        ///success state
                        if (state is UpdateBlockSuccessState) {
                          communityCubit.getCommunityDetail(communityId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        ///loading state
                        if (state is UpdateBlockUserLoadingState) {
                          return CircularProgressIndicator(
                            color: AppColors.whiteColor,
                          );
                        }
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            BlocProvider.of<UpdateBlockUserBloc>(context)
                                .add(UpdateBlockUserButtonPressedEvent(
                              communityId: communityId,
                              userId: userId,
                              isBlock: true,
                            ));

                            // Navigator.pop(context);
                            // Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff635BFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Block',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 0.3,
                              ),
                            ),
                          ),
                        );
                      },
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

  /// make admin, remove admin, remove from community, bloc user bottomsheet
  Future<dynamic> bottomSheetMenu(
    BuildContext context,
    String userId,
    bool isAdmin,
  ) {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              myUserId != userId && isAdmin
                  ? MenuIconItem(
                      title: 'Remove Admin',
                      svgPath: 'assets/menu_make_admin.svg',
                      iconSize: 25,
                      onTap: () {
                        Navigator.pop(context);
                        bottomSheetRemoveAdminConfirm(context, userId);
                      })
                  : SizedBox(),
              myUserId != userId && !isAdmin
                  ? MenuIconItem(
                      title: 'Make Admin',
                      svgPath: 'assets/menu_make_admin.svg',
                      iconSize: 25,
                      onTap: () {
                        Navigator.pop(context);
                        bottomSheetMakeAdminConfirm(context, userId);
                      })
                  : SizedBox(),
              myUserId != userId
                  ? MenuIconItem(
                      title: 'Remove from community',
                      svgPath: 'assets/menu_remove.svg',
                      iconSize: 25,
                      textColor: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                        bottomSheetConfirmRemove(context, userId);
                      })
                  : MenuIconItem(
                      title: 'Leave community',
                      svgPath: 'assets/menu_remove.svg',
                      iconSize: 25,
                      textColor: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                        bottomSheetLeaveConfirm(context);
                      }),
              myUserId != userId
                  ? MenuIconItem(
                      title: 'Block user',
                      svgPath: 'assets/menu_make_admin.svg',
                      iconSize: 25,
                      onTap: () {
                        Navigator.pop(context);
                        bottomSheetBlockConfirm(context, userId);
                      })
                  : SizedBox(),
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

  ///user/ admin list tile
  Widget userTile(BuildContext context, UserSimpleModel user, bool isAdmin) {
    return GestureDetector(
      onTap: () {
        bottomSheetMenu(context, user.id, isAdmin);
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

  /// build method
  @override
  Widget build(BuildContext context) {
    final bool hasMembers = members.isNotEmpty || admins.isNotEmpty;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
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
      body: SingleChildScrollView(
        child: BlocBuilder<CommunityDetailsCubit, CommunityDetailsState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state.status == Status.success) {
              communityId = communityCubit.state.community?.id ?? '';
              members = communityCubit.state.community?.users != null
                  ? [...communityCubit.state.community!.users]
                  : [];
              admins = communityCubit.state.community?.admins != null
                  ? [...communityCubit.state.community!.admins]
                  : [];
              final adminSet = admins.toSet();
              members = members
                  .where((member) => !adminSet.contains(member))
                  .toList();
              return Column(
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
                  ...admins.map((admin) => userTile(context, admin, true)),
                  ...members.map((member) => userTile(context, member, false)),
                ],
              );
            }
            return Center(
              child: Text(state.errorMessage ?? 'something went wrong'),
            );
          },
        ),
      ),
    );
  }
}

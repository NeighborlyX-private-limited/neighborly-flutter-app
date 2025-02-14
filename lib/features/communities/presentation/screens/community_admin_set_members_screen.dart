import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/constants/status.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/add_remove_user_in_group_bloc.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/join_group_bloc.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/make_remove_admin_bloc.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/update_block_user_bloc.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/menu_icon_widget.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../bloc/communities_main_cubit.dart';
import '../bloc/community_detail_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  // INIT STATE
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

  // GET CURRENT USER ID
  void getuserId() {
    myUserId = ShardPrefHelper.getUserID() ?? '';
    setState(() {});
  }

  // REFRESH CALL
  Future<void> _onRefresh() async {
    communityCubit.getCommunityDetail(communityId);
  }

// CHECK USER IS AN ADMIN
  bool isUserAnAdmin(String userId) {
    return admins.any((admin) => admin.id == userId);
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.member_list,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocConsumer<CommunityDetailsCubit, CommunityDetailsState>(
          listener: (context, state) {
            // FAILURE STATE
            if (state.status == Status.failure) {
              showSnackBar(
                context: context,
                message: 'oops something went wrong',
              );
            }
            // SUCCESS STATE
            if (state.status == Status.success) {
              members = communityCubit.state.community?.users != null
                  ? [...communityCubit.state.community!.users]
                  : [];
              admins = communityCubit.state.community?.admins != null
                  ? [...communityCubit.state.community!.admins]
                  : [];
            }
          },
          builder: (context, state) {
            // LOADING STATE
            if (state.status == Status.loading) {
              return CustomCircularIndicator();
            }
            // SUCCESS STATE
            if (state.status == Status.success) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      bottomSheetMenu(
                        context,
                        members[index].id,
                      );
                    },
                    child: userTile(
                      context,
                      members[index],
                    ),
                  );
                },
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

// ADMIN BUBBLE
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

  // USER TILE WIDGET
  Widget userTile(BuildContext context, UserSimpleModel user) {
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
          if (isUserAnAdmin(user.id)) ...[
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

  // MENU BOTTOM SHEET
  Future<dynamic> bottomSheetMenu(
    BuildContext context,
    String userId,
  ) {
    bool isAdmin = isUserAnAdmin(userId);
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // MAKE ADMIN
              myUserId != userId && isAdmin
                  ? MenuIconItem(
                      title: AppLocalizations.of(context)!.remove_Admin,
                      svgPath: 'assets/menu_make_admin.svg',
                      iconSize: 25,
                      onTap: () {
                        Navigator.pop(context);
                        bottomSheetRemoveAdminConfirm(context, userId);
                      })
                  : SizedBox(),
              // REMOVE ADMIN
              myUserId != userId && !isAdmin
                  ? MenuIconItem(
                      title: AppLocalizations.of(context)!.make_Admin,
                      svgPath: 'assets/menu_make_admin.svg',
                      iconSize: 25,
                      onTap: () {
                        Navigator.pop(context);
                        bottomSheetMakeAdminConfirm(context, userId);
                      })
                  : SizedBox(),
              // REMOVE FROM COMMUNITY
              myUserId != userId
                  ? MenuIconItem(
                      title:
                          AppLocalizations.of(context)!.remove_from_community,
                      svgPath: 'assets/menu_remove.svg',
                      iconSize: 25,
                      textColor: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                        bottomSheetConfirmRemove(context, userId);
                      })
                  : MenuIconItem(
                      title: AppLocalizations.of(context)!.leave_Community,
                      svgPath: 'assets/menu_remove.svg',
                      iconSize: 25,
                      textColor: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                        bottomSheetLeaveConfirm(context);
                      }),
              myUserId != userId
                  ? MenuIconItem(
                      title: AppLocalizations.of(context)!.block_user,
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

  // REMOVE ADMIN BOTTOM  SHEET
  Future<dynamic> bottomSheetRemoveAdminConfirm(
    BuildContext context,
    String userId,
  ) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .are_you_sure_you_want_to_remove_this_person_from_Admin_post,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
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
                          AppLocalizations.of(context)!.cancel,
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
                        // FAILURE STATE
                        if (state is MakeRemoveAdminFailureState) {
                          Navigator.pop(context);
                          showSnackBar(context: context, message: state.error);
                        }

                        // SUCCESS STATE
                        if (state is RemoveAdminSuccessState) {
                          Navigator.pop(context);
                          _onRefresh();
                        }
                      },
                      builder: (context, state) {
                        // LOADING STATE
                        if (state is MakeRemoveAdminLoadingState) {
                          return CustomCircularIndicator();
                        }
                        return ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<MakeRemoveAdminBloc>(context).add(
                              RemoveAdminButtonPressedEvent(
                                communityId: communityId,
                                userId: userId,
                              ),
                            );
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
                              AppLocalizations.of(context)!.yes,
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

  // MAKE ADMIN BOTTOM SHEET
  Future<dynamic> bottomSheetMakeAdminConfirm(
    BuildContext context,
    String userId,
  ) {
    return showModalBottomSheet(
      useRootNavigator: true,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .are_you_sure_you_make_this_person_Admin,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
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
                          AppLocalizations.of(context)!.cancel,
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
                        // FAILURE STATE
                        if (state is MakeRemoveAdminFailureState) {
                          Navigator.pop(context);
                          showSnackBar(context: context, message: state.error);
                        }

                        // SUCCESS STATE
                        if (state is MakeAdminSuccessState) {
                          Navigator.pop(context);
                          _onRefresh();
                        }
                      },
                      builder: (context, state) {
                        // LOADING STATE
                        if (state is MakeRemoveAdminLoadingState) {
                          return CustomCircularIndicator();
                        }
                        return ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<MakeRemoveAdminBloc>(context).add(
                              MakeAdminButtonPressedEvent(
                                communityId: communityId,
                                userId: userId,
                              ),
                            );
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
                              AppLocalizations.of(context)!.yes,
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

  // LEAVE GROUP BOTTOM SHEET
  Future<dynamic> bottomSheetLeaveConfirm(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      useRootNavigator: true,
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
                AppLocalizations.of(context)!
                    .are_you_sure_you_want_to_leave_this_community,
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
                          AppLocalizations.of(context)!.cancel,
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
                        // FAILURE STATE
                        if (state is JoinGroupFailureState) {
                          Navigator.pop(context);
                          showSnackBar(context: context, message: state.error);
                        }

                        // SUCCESS STATE
                        if (state is LeaveGroupSuccessState) {
                          Navigator.pop(context);
                          BlocProvider.of<CommunityMainCubit>(context).init();
                          context.go('/groups');
                        }
                      },
                      builder: (context, state) {
                        // LOADING STATE
                        if (state is JoinGroupLoadingState) {
                          return CustomCircularIndicator();
                        }
                        return ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<JoinGroupBloc>(context)
                                .add(LeaveGroupButtonPressedEvent(
                              communityId: communityId,
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
                              AppLocalizations.of(context)!.yes,
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

// REMOVE USER FROM GROUP
  Future<dynamic> bottomSheetConfirmRemove(
    BuildContext context,
    String userId,
  ) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .are_you_sure_you_want_to_remove_this_person_from_community,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
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
                          AppLocalizations.of(context)!.cancel,
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
                      // FAILURE STATE
                      listener: (context, state) {
                        if (state is AddRemoveUserInGroupFailureState) {
                          Navigator.pop(context);
                          showSnackBar(context: context, message: state.error);
                        }

                        // SUCCESS STATE
                        if (state is RemoveUserInGroupSuccessState) {
                          Navigator.pop(context);
                          _onRefresh();
                          showSnackBar(
                            context: context,
                            message: AppLocalizations.of(context)!.user_removed,
                          );
                        }
                      },
                      builder: (context, state) {
                        // LOADING STATE
                        if (state is AddRemoveUserInGroupLoadingState) {
                          return CustomCircularIndicator();
                        }
                        return ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AddRemoveUserInGroupBloc>(context)
                                .add(RemoveUserInGroupButtonPressedEvent(
                              communityId: communityId,
                              userId: userId,
                              isRemove: true,
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
                              AppLocalizations.of(context)!.yes,
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

  // BLOCK USER FROM GROUP
  Future<dynamic> bottomSheetBlockConfirm(
    BuildContext context,
    String userId,
  ) {
    return showModalBottomSheet(
      useRootNavigator: true,
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
                AppLocalizations.of(context)!
                    .are_you_sure_you_want_to_block_this_user,
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
                          AppLocalizations.of(context)!.cancel,
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
                        // FAILURE STATE
                        if (state is UpdateBlockUserFailureState) {
                          Navigator.pop(context);
                          showSnackBar(context: context, message: state.error);
                        }

                        // SUCCESS
                        if (state is UpdateBlockSuccessState) {
                          Navigator.pop(context);
                          _onRefresh();
                          showSnackBar(
                            context: context,
                            message: state.message,
                          );
                        }
                      },
                      builder: (context, state) {
                        // LOADING STATE
                        if (state is UpdateBlockUserLoadingState) {
                          return CustomCircularIndicator();
                        }
                        return ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<UpdateBlockUserBloc>(context)
                                .add(UpdateBlockUserButtonPressedEvent(
                              communityId: communityId,
                              userId: userId,
                              isBlock: true,
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
                              AppLocalizations.of(context)!.block,
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
}

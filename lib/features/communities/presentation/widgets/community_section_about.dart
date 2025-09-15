import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/indicator/custom_circular_progress_indicator.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../../../l10n/app_localizations.dart';

import '../bloc/bloc/add_remove_user_in_group_bloc.dart';
import '../bloc/bloc/join_group_bloc.dart';
import '../bloc/bloc/make_remove_admin_bloc.dart';
import '../bloc/communities_main_cubit.dart';
import '../bloc/community_detail_cubit.dart';

class CommunitySectionAbout extends StatefulWidget {
  final CommunityModel community;
  const CommunitySectionAbout({
    super.key,
    required this.community,
  });

  @override
  State<CommunitySectionAbout> createState() => _CommunitySectionAboutState();
}

class _CommunitySectionAboutState extends State<CommunitySectionAbout> {
  late CommunityDetailsCubit communityCubit;
  late CommunityModel? cacheCommunity;

// INIT STATE
  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    cacheCommunity = communityCubit.state.community;
  }

// BUILD
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommunityDetailsCubit, CommunityDetailsState>(
      listener: (BuildContext context, CommunityDetailsState state) {
        // FAILURE STATE
        if (state.status == Status.failure) {
          showSnackBar(
            context: context,
            message: 'oops something went wrong',
          );
        }
        // FAILURE STATE
        if (state.status == Status.success) {
          cacheCommunity = state.community;
        }
      },
      builder: (context, state) {
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
                // COMMUNITY DESCRIPTION
                DescriptionArea(description: cacheCommunity!.description),
                Container(
                  height: 8,
                  color: const Color.fromARGB(255, 239, 239, 252),
                ),
                // COMMUNITY KARMA SCORE
                TextAndIconArea(
                  title: AppLocalizations.of(context)!.karma,
                  text: '${cacheCommunity?.karma}',
                  svgPath: 'assets/karma.svg',
                ),
                Container(
                  height: 8,
                  color: const Color.fromARGB(255, 239, 239, 252),
                ),
                // COMMUNITY RADIUS
                TextAndIconArea(
                  title: AppLocalizations.of(context)!.radius,
                  text:
                      '${cacheCommunity?.radius} ${AppLocalizations.of(context)!.miles}',
                  icon: Icons.pin_drop_outlined,
                ),
                Container(
                  height: 8,
                  color: const Color.fromARGB(255, 239, 239, 252),
                ),
                // COMMUNITY MEMBERS LIST
                MembersList(
                  members: cacheCommunity!.users,
                  admins: cacheCommunity!.admins,
                  communityId: cacheCommunity!.id,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// COMMUNITY DESCRIPTION WIDGET
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
        ],
      ),
    );
  }
}

// COMMON WIDGET FOR ICON AND TEXT
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

// MEMBERS LIST
class MembersList extends StatefulWidget {
  final List<UserSimpleModel> members;
  final List<UserSimpleModel> admins;
  final String communityId;

  const MembersList({
    super.key,
    required this.members,
    required this.admins,
    required this.communityId,
  });

  @override
  State<MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  bool showAll = false;
// CHECK IF USER IS AN ADMIN
  bool checkIsAdmin(String userId) {
    bool isAdmin = widget.admins.any((adm) => adm.id == userId);
    return isAdmin;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasMembers = widget.members.isNotEmpty;
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.member_list,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          // NO MEMBERS
          if (hasMembers == false)
            Text(
              AppLocalizations.of(context)!.no_Members,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          // COMMUNITY HAS SOME MEMBERS
          if (hasMembers == true) ...[
            ...widget.members
                .take(showAll == true ? widget.members.length : 5)
                .map(
                  (user) => userTile(
                    user,
                  ),
                ),
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

// USER LIST
  Widget userTile(UserSimpleModel user) {
    bool isAdmin = checkIsAdmin(user.id);
    String myUserId = ShardPrefHelper.getUserID() ?? '';
    bool isCurrentUserAdmin = checkIsAdmin(myUserId);
    return GestureDetector(
      onLongPress: () {
        if (isCurrentUserAdmin) {
          showMembersOptions(
            context: context,
            isAdmin: isAdmin,
            userId: user.id,
          );
        }
      },
      onTap: () {
        context.push('/userProfileScreen/${user.id}');
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

  void showMembersOptions({
    required BuildContext context,
    required bool isAdmin,
    required String userId,
    // required VoidCallback onRemoveUser,
    // required VoidCallback onRemoveAdmin,
    // required VoidCallback onMakeAdmin,
  }) {
    String myUserId = ShardPrefHelper.getUserID() ?? '';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            if (!isAdmin)
              ListTile(
                leading: SvgPicture.asset(
                  'assets/menu_make_admin.svg',
                  width: 24,
                ),
                title: Text('Make admin'),
                onTap: () {
                  Navigator.pop(context);
                  bottomSheetMakeAdminConfirm(context, userId);
                },
              ),
            if (isAdmin && myUserId != userId)
              ListTile(
                leading: SvgPicture.asset(
                  'assets/menu_make_admin.svg',
                  width: 24,
                ),
                title: Text('Remove as admin'),
                onTap: () {
                  Navigator.pop(context);
                  bottomSheetRemoveAdminConfirm(context, userId);
                },
              ),
            myUserId == userId
                ? ListTile(
                    leading: Icon(Icons.remove_circle),
                    title: Text('Leave community'),
                    onTap: () {
                      Navigator.pop(context);
                      bottomSheetLeaveConfirm(context);
                    },
                  )
                : ListTile(
                    leading: Icon(Icons.remove_circle),
                    title: Text('Remove from community'),
                    onTap: () {
                      Navigator.pop(context);
                      bottomSheetConfirmRemove(context, userId);
                    },
                  ),
          ],
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
                              communityId: widget.communityId,
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

                          // _onRefresh();
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
                              communityId: widget.communityId,
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
                          // _onRefresh();
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
                                communityId: widget.communityId,
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
                          // _onRefresh();
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
                                communityId: widget.communityId,
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
}

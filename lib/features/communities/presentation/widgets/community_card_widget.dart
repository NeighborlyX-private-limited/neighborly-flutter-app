import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/get_user_groups_bloc.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/communities_main_cubit.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/community_detail_cubit.dart';
import 'package:neighborly_flutter_app/features/event/presentation/screens/event_detail_screen.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/widgets/stacked_avatar_indicator_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/join_group_bloc.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/community_detail_cubit.dart';
import '../../../../core/theme/colors.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/screens/community_details_screen.dart';
import 'package:neighborly_flutter_app/core/constants/status.dart';

class CommunityCardWidget extends StatefulWidget {
  final CommunityModel community;

  const CommunityCardWidget({
    super.key,
    required this.community,
  });

  @override
  State<CommunityCardWidget> createState() => _CommunityCardWidgetState();
}

class _CommunityCardWidgetState extends State<CommunityCardWidget> {
  late CommunityMainCubit communityMainCubit;
  late CommunityDetailsCubit communityCubit;
  late CommunityModel? communityCache;

  String? userId;

  // bool isJoining = false;
  int groupMemberCount = 0;

  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    communityMainCubit = BlocProvider.of<CommunityMainCubit>(context);

    calculateGroupMemberCount();
    getUserId();
  }

  /// calculate totla group member including admins
  void calculateGroupMemberCount() {
    groupMemberCount = {
      ...widget.community.admins,
      ...widget.community.users,
    }.length;
    setState(() {});
  }

  /// get user id
  void getUserId() async {
    userId = ShardPrefHelper.getUserID();
    setState(() {});
  }

  ///color parser
  Color parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('0xFF$hexColor'));
  }

  void openCommunity(BuildContext context) async {
    final result = await context.push<bool>(
      '/groups/${widget.community.id}',
    );

    if (result == true) {
      communityMainCubit.init();
    }
  }

  ///leave group bottom sheet
  Future<dynamic> leaveGroupBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: AppColors.whiteColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.leave_Community,
                // 'Leave Community?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!
                    .are_you_sure_you_want_to_leave_this_community,
                // 'Are you sure you want to leave this community?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        // 'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Confirm Button
                  Expanded(
                    child: BlocConsumer<JoinGroupBloc, JoinGroupState>(
                      listener: (context, state) {
                        /// failure state
                        if (state is JoinGroupFailureState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .something_went_wrong),
                            ),
                          );
                        }

                        /// success state
                        if (state is LeaveGroupSuccessState) {
                          communityMainCubit =
                              BlocProvider.of<CommunityMainCubit>(context);
                          communityMainCubit.init();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!
                                    .group_leaved_successfully,
                                // 'Group leaved successfully'
                              ),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        ///loading state
                        if (state is JoinGroupLoadingState) {
                          return CircularProgressIndicator();
                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            BlocProvider.of<JoinGroupBloc>(context).add(
                                LeaveGroupButtonPressedEvent(
                                    communityId: widget.community.id));
                          },
                          child: Text(
                            AppLocalizations.of(context)!.leave,
                            // 'Leave',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// join group bottom sheet
  Future<dynamic> joinGroupBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: AppColors.whiteColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.join_Community,
                // 'Join Community?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!
                    .are_you_sure_you_want_to_join_this_community,
                // 'Are you sure you want to join this community?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        // 'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Confirm Button
                  Expanded(
                    child: BlocConsumer<JoinGroupBloc, JoinGroupState>(
                      listener: (context, state) {
                        /// failure state
                        if (state is JoinGroupFailureState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!
                                    .something_went_wrong,
                              ),
                            ),
                          );
                        }

                        /// success state
                        if (state is JoinGroupSuccessState) {
                          communityMainCubit =
                              BlocProvider.of<CommunityMainCubit>(context);
                          communityMainCubit.init();
                          // communityDetailCubit
                          //     .getCommunityDetail(widget.community.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!
                                    .group_joined_successfully,
                                // 'Group joined successfully'
                              ),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        ///loading state
                        if (state is JoinGroupLoadingState) {
                          return CircularProgressIndicator();
                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            BlocProvider.of<JoinGroupBloc>(context)
                                .add(JoinGroupButtonPressedEvent(
                              communityId: widget.community.id,
                            ));
                          },
                          child: Text(
                            AppLocalizations.of(context)!.join,
                            // 'Join',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isColor = widget.community.avatarUrl.length > 1 &&
        widget.community.avatarUrl.length < 8;

    return GestureDetector(
      onTap: () {
        openCommunity(context);
      },
      child: Card(
        elevation: 1,
        child: Container(
          height: 160,
          width: 125,
          decoration: BoxDecoration(
            color: isColor
                ? parseColor(widget.community.avatarUrl)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            image: isColor
                ? null
                : DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      widget.community.avatarUrl[0].contains('#')
                          ? widget.community.avatarUrl.replaceFirst('#', '')
                          : widget.community.avatarUrl,
                    ),
                  ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      height: 19,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.community.isPublic
                                  ? Icons.public
                                  : Icons.lock_person_outlined,
                              color: Colors.white,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              widget.community.isPublic
                                  ? AppLocalizations.of(context)!.public
                                  : AppLocalizations.of(context)!.private,
                              style: TextStyle(
                                height: 0.5,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.community.displayName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.community.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StackedAvatarIndicator(
                              avatarUrls: [
                                ...{
                                  ...widget.community.users
                                      .map((e) => e.avatarUrl),
                                  ...widget.community.admins
                                      .map((e) => e.avatarUrl),
                                }
                              ],
                              showOnly: 3,
                              avatarSize: 22,
                              onTap: () {},
                            ),
                            // StackedAvatarIndicator(
                            //   avatarUrls: [
                            //     ...(widget.community.users
                            //         .map((e) => e.avatarUrl)
                            //         .toList()),
                            //     ...(widget.community.admins
                            //         .map((e) => e.avatarUrl)
                            //         .toList())
                            //   ],
                            //   showOnly: 3,
                            //   avatarSize: 22,
                            //   onTap: () {},
                            // ),
                            Expanded(
                              child: groupMemberCount > 1000
                                  ? Text(
                                      '${groupMemberCount}k+ ${AppLocalizations.of(context)!.members}',
                                      // '${groupMemberCount}k+ Members',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    )
                                  : groupMemberCount > 1
                                      ? Text(
                                          '${groupMemberCount} ${AppLocalizations.of(context)!.members}',
                                          // '$groupMemberCount Members',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        )
                                      : Text(
                                          '${groupMemberCount} ${AppLocalizations.of(context)!.member}',
                                          // '$groupMemberCount Member',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                            onTap: () {
                              widget.community.isJoined
                                  ? leaveGroupBottomSheet(context)
                                  : joinGroupBottomSheet(context);
                            },
                            child: Container(
                              height: 35,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xff635BFF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  widget.community.isJoined
                                      ? AppLocalizations.of(context)!.leave
                                      : AppLocalizations.of(context)!.join,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

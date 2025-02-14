import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/communities_main_cubit.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/community_detail_cubit.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/widgets/stacked_avatar_indicator_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/join_group_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/bloc/get_user_groups_bloc.dart';

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

  String? userId;
  int groupMemberCount = 0;
  //INIT STATE
  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    communityMainCubit = BlocProvider.of<CommunityMainCubit>(context);
    calculateGroupMemberCount();
    getUserId();
  }

  // CALCULATE TOTAL GROUP MEMBERS
  void calculateGroupMemberCount() {
    groupMemberCount = widget.community.users.length;
  }

  // GET CURRENT USER ID
  void getUserId() async {
    userId = ShardPrefHelper.getUserID();
  }

  // Converts a hex color string (e.g., "#FF5733") into a Flutter `Color` object.
  Color parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('0xFF$hexColor'));
  }

  // GO TO THE COMMUNITY DETAILS SCREEN AND WAIT FOR RESULT TRUE OR FALSE
  void openCommunity(BuildContext context) async {
    if (widget.community.isPublic || widget.community.isJoined) {
      await context.push<bool>(
        '/group-details/${widget.community.id}',
      );

      communityMainCubit.init();
      if (context.mounted) {
        BlocProvider.of<GetUserGroupsBloc>(context).add(
          GetUserGroupsButtonPressedEvent(),
        );
      }
    }
  }

// BUILD
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    //  GROUP PUBLIC OR PRIVATE BUBBLE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                      ),
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.community.isPublic
                                ? Icons.public
                                : Icons.lock_person_outlined,
                            color: Colors.white,
                            size: 16,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // COMMUNITY NAME
                    Text(
                      widget.community.name,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // COMMUNITY MEMBERS DP'S
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StackedAvatarIndicator(
                          avatarUrls: [
                            ...widget.community.users.map((e) => e.avatarUrl),
                          ],
                          showOnly: 3,
                          avatarSize: 22,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        // COMMUNITY MEMBERS COUNT
                        groupMemberCount > 1000
                            ? Text(
                                '${groupMemberCount}k+ ${AppLocalizations.of(context)!.members}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              )
                            : groupMemberCount > 1
                                ? Text(
                                    '$groupMemberCount ${AppLocalizations.of(context)!.members}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  )
                                : Text(
                                    '$groupMemberCount ${AppLocalizations.of(context)!.member}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // IF USER IS NOT JOINED AND NOT REQUESTED TO JOIN THE GROUP
                    // SHOW JOIN BUTTON
                    if (!widget.community.isJoined &&
                        !widget.community.requestStatus)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            joinGroupBottomSheet(context);
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
                                AppLocalizations.of(context)!.join,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // IF USER IS JOINED AND NOT AN ADMIN
                    // SHOW LEAVE BUTTON
                    if (widget.community.isJoined && !widget.community.isAdmin)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            leaveGroupBottomSheet(context);
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
                                AppLocalizations.of(context)!.leave,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // IF COMMUNITY ID PRIVATE AND USER IS NOT JOINED AND ALREADY REQUESTED TO JOIN THE GROUP
                    // SHOW PENDING BUTTON
                    if (!widget.community.isPublic &&
                        !widget.community.isJoined &&
                        widget.community.requestStatus)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.inActivePrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Requested',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // JOIN GROUP BOTTOM SHEET
  Future<dynamic> joinGroupBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useRootNavigator: true,
      backgroundColor: AppColors.whiteColor,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.join_Community,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!
                    .are_you_sure_you_want_to_join_this_community,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CANCEL BUTTON
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
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // CONFIRM BUTTON
                  Expanded(
                    child: BlocConsumer<JoinGroupBloc, JoinGroupState>(
                      listener: (context, state) {
                        // FAILURE STATE
                        if (state is JoinGroupFailureState) {
                          if (mounted) {
                            Navigator.pop(context);
                            showSnackBar(
                              context: context,
                              message: AppLocalizations.of(context)!
                                  .something_went_wrong,
                            );
                          }
                        }

                        // SUCCESS STATE
                        if (state is JoinGroupSuccessState) {
                          Navigator.pop(context);
                          communityMainCubit.init();
                          showSnackBar(
                            context: context,
                            message: AppLocalizations.of(context)!
                                .group_joined_successfully,
                          );
                        }
                      },
                      builder: (context, state) {
                        // LOADING STATE
                        if (state is JoinGroupLoadingState) {
                          return CustomCircularIndicator();
                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            BlocProvider.of<JoinGroupBloc>(context).add(
                              JoinGroupButtonPressedEvent(
                                communityId: widget.community.id,
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.join,
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

  // LEAVE GROUP BOTTOM SHEET
  Future<dynamic> leaveGroupBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.leave_Community,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!
                    .are_you_sure_you_want_to_leave_this_community,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CANCEL BUTTON
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
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // CONFIRM BUTTON
                  Expanded(
                    child: BlocConsumer<JoinGroupBloc, JoinGroupState>(
                      listener: (context, state) {
                        // FAILURE STATE
                        if (state is JoinGroupFailureState) {
                          if (mounted) {
                            Navigator.pop(context);
                            showSnackBar(
                              context: context,
                              message: AppLocalizations.of(context)!
                                  .something_went_wrong,
                            );
                          }
                        }

                        // SUCCESS STATE
                        if (state is LeaveGroupSuccessState) {
                          Navigator.pop(context);
                          communityMainCubit.init();
                          if (mounted) {
                            showSnackBar(
                              context: context,
                              message: AppLocalizations.of(context)!
                                  .group_leaved_successfully,
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        // LOADING STATE
                        if (state is JoinGroupLoadingState) {
                          return CustomCircularIndicator();
                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            BlocProvider.of<JoinGroupBloc>(context)
                                .add(LeaveGroupButtonPressedEvent(
                              communityId: widget.community.id,
                            ));
                          },
                          child: Text(
                            AppLocalizations.of(context)!.leave,
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
}

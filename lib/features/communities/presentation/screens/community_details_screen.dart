import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/join_group_bloc.dart';
import 'package:share_it/share_it.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/appbat_button.dart';
import '../../../../core/widgets/menu_icon_widget.dart';
import '../../../../core/widgets/stacked_avatar_indicator_widget.dart';

import '../../../posts/presentation/bloc/report_post_bloc/report_post_bloc.dart';
import '../bloc/bloc/update_mute_group_bloc.dart';
import '../bloc/community_detail_cubit.dart';
import '../widgets/community_details_sheemer.dart';
import '../widgets/community_section_about.dart';
import '../widgets/community_section_chat.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommunityDetailsScreen extends StatefulWidget {
  final String communityId;

  const CommunityDetailsScreen({
    super.key,
    required this.communityId,
  });

  @override
  State<CommunityDetailsScreen> createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late CommunityDetailsCubit communityDetailCubit;
  String? userId;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    communityDetailCubit = BlocProvider.of<CommunityDetailsCubit>(context);

    _onRefresh();
    getCurrentUserId();
  }

  // GET CURRENT USER ID
  void getCurrentUserId() async {
    userId = ShardPrefHelper.getUserID();
  }

  // NEARBY AND MY GROUP TAB REFRESH
  Future<void> _onRefresh() async {
    communityDetailCubit.getCommunityDetail(widget.communityId);
  }

  // RETURN COLOR CODE
  Color parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('0xFF$hexColor'));
  }

  // DISPOSE
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // REPORT CONFIRMATION SHEET
  // Future<dynamic> reportConfirmationBottomSheet(BuildContext context) async {
  //   return showModalBottomSheet(
  //     useRootNavigator: true,
  //     backgroundColor: AppColors.whiteColor,
  //     showDragHandle: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       Future.delayed(const Duration(seconds: 3), () {});
  //       if (mounted) {
  //         Navigator.pop(context);
  //       }
  //       return Container(
  //         color: Colors.white,
  //         height: 240,
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Image.asset('assets/report_confirmation.png'),
  //             Text(
  //               AppLocalizations.of(context)!.thanks_for_letting_us_know,
  //               style: onboardingHeading2Style,
  //             ),
  //             Text(
  //               textAlign: TextAlign.center,
  //               AppLocalizations.of(context)!
  //                   .we_appreciate_your_help_in_keeping_our_community_safe_and_respectful_Our_team_will_review_the_content_shortly,
  //               style: blackonboardingBody1Style,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // // PICK REPORT REASON
  // Future<dynamic> reportReasonBottomSheet(BuildContext context) async {
  //   return showModalBottomSheet(
  //     useRootNavigator: true,
  //     backgroundColor: AppColors.whiteColor,
  //     showDragHandle: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SingleChildScrollView(
  //         child: Container(
  //           color: Colors.white,
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Center(
  //                 child: Text(
  //                   AppLocalizations.of(context)!.reason_to_Report,
  //                   style: onboardingHeading2Style,
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   ...kReportReasons.map(
  //                     (reason) => InkWell(
  //                       onTap: () async {
  //                         Navigator.of(context).pop();
  //                         communityDetailCubit.reportCommunity(reason);
  //                         await reportConfirmationBottomSheet(context);
  //                       },
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         children: [
  //                           Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Text(
  //                               reason,
  //                               style: blackonboardingBody1Style,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
      },
      builder: (context, state) {
        // LOADING STATE
        if (state.status == Status.loading) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.whiteColor,
              appBar: AppBar(
                backgroundColor: AppColors.whiteColor,
              ),
              body: const CommunityDetailsSheemer(),
            ),
          );
        }
        // SUCCESS STATE
        if (state.status == Status.success) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              Navigator.of(context).pop(true);
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: AppColors.whiteColor,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: Container(
                    margin: EdgeInsets.all(9.0),
                    height: 40,
                    width: 40,
                    child: AppbatButton(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      icon: Icons.chevron_left_rounded,
                      iconSize: 30,
                    ),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // SHARE BUTTON
                        AppbatButton(
                          onTap: () {
                            String link =
                                'Hey, check this community: https://prod.neighborly.in/group-details/${widget.communityId}';
                            ShareIt.text(
                              content: link,
                              androidSheetTitle: 'Share',
                            );
                          },
                          icon: Icons.share,
                          iconSize: 20,
                        ),
                        const SizedBox(width: 10),

                        // MENU BUTTON
                        AppbatButton(
                          onTap: () {
                            if ((state.community?.isAdmin ?? false) &&
                                (state.community?.isJoined ?? false)) {
                              context.push(
                                '/group-admin',
                                extra: state.community,
                              );
                            } else {
                              if (state.community?.isJoined ?? false) {
                                userBottomSheetMenu(
                                  context: context,
                                  community: state.community,
                                );
                              } else {
                                joinGroupBottomSheet(context);
                              }
                            }
                          },
                          icon: Icons.more_vert_outlined,
                          iconSize: 25,
                        ),
                        const SizedBox(width: 10),
                      ],
                    )
                  ],
                ),
                body: Column(
                  children: [
                    topElement(state.community?.avatarUrl ?? ''),
                    titleArea(
                      community: state.community!,
                      onJoinLeavePressed: () {
                        if (state.community?.isJoined ?? false) {
                          leaveGroupBottomSheet(context);
                        } else {
                          joinGroupBottomSheet(context);
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0, right: 5),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: AppColors.primaryColor,
                          labelColor: Colors.black,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          unselectedLabelColor: Colors.grey,
                          unselectedLabelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          tabs: [
                            Tab(
                              child:
                                  tabTitle(AppLocalizations.of(context)!.about),
                            ),
                            Tab(
                              child:
                                  tabTitle(AppLocalizations.of(context)!.chat),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // GROUP ABOUT SECTION
                          RefreshIndicator(
                            onRefresh: _onRefresh,
                            child: ListView(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              children: [
                                CommunitySectionAbout(
                                  community: state.community!,
                                ),
                              ],
                            ),
                          ),

                          // GROUP CHAT SECTION
                          RefreshIndicator(
                            onRefresh: _onRefresh,
                            child: ListView(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              children: [
                                CommunitySectionChat(
                                  community: state.community!,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold();
      },
    );
  }

  // TAB BAR DESIGN
  Widget tabTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }

  // GROUP ICON WIDGET
  Widget topElement(String avatarUrl) {
    bool isColor = avatarUrl.length < 9;
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      decoration: BoxDecoration(
        color: isColor ? parseColor(avatarUrl) : Colors.transparent,
        image: isColor
            ? null
            : DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  avatarUrl.contains('#')
                      ? avatarUrl.replaceFirst('#', '')
                      : avatarUrl,
                ),
              ),
      ),
    );
  }

// TITLE AREA
  Widget titleArea({
    required CommunityModel? community,
    required VoidCallback onJoinLeavePressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GROUP DISPLAY NAME
          Text(
            community!.displayName,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          // GROUP NAME
          Text(
            community.name,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: AppColors.greyColor,
            ),
          ),
          Row(
            children: [
              StackedAvatarIndicator(
                avatarUrls: community.users.map((e) => e.avatarUrl).toList(),
                showOnly: 4,
                avatarSize: 14,
                radius: 9,
              ),
              Expanded(
                child: community.users.length > 1000
                    ? Text(
                        '${community.users.length}k+ Members',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      )
                    : community.users.length > 1
                        ? Text(
                            '${community.users.length} Members',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          )
                        : Text(
                            '${community.users.length} Member',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
              ),
              community.isJoined
                  ? ElevatedButton(
                      onPressed: () {
                        if ((community.isAdmin) && (community.isJoined)) {
                          context.push(
                            '/group-admin',
                            extra: community,
                          );
                        } else {
                          if (community.isJoined) {
                            userBottomSheetMenu(
                              context: context,
                              community: community,
                            );
                          } else {
                            joinGroupBottomSheet(context);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.settings,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 18,
                          height: 0.3,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        onJoinLeavePressed();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        community.isJoined
                            ? AppLocalizations.of(context)!.leave
                            : AppLocalizations.of(context)!.join,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 18,
                          height: 0.3,
                        ),
                      ),
                    ),
            ],
          ),
          Row(
            children: [
              Icon(
                community.isPublic ? Icons.public : Icons.lock_person_outlined,
                color: Colors.black,
                size: 15,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                community.isPublic
                    ? AppLocalizations.of(context)!.public
                    : AppLocalizations.of(context)!.private,
                style: TextStyle(
                  height: 0.5,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // MENU BOTTOM  SHEET
  Future<dynamic> userBottomSheetMenu({
    required BuildContext context,
    required CommunityModel? community,
  }) {
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
              // LEAVE GROUP OPTION
              MenuIconItem(
                title:
                    '${AppLocalizations.of(context)!.leave} ${community?.name}',
                svgPath: 'assets/menu_leave.svg',
                iconSize: 25,
                onTap: () {
                  Navigator.pop(context);
                  leaveGroupBottomSheet(context);
                },
              ),

              // MUTE-UNMUTE OPTION
              BlocConsumer<UpdateMuteGroupBloc, UpdateMuteGroupState>(
                listener: (context, state) {
                  // FAILURE STATE
                  if (state is UpdateMuteGroupFailureState) {
                    Navigator.pop(context);
                    showSnackBar(
                      context: context,
                      message: 'oops something went wrong',
                    );
                  }

                  // SUCCESS STATE
                  if (state is UpdateMuteGroupSuccessState) {
                    Navigator.pop(context);
                    _onRefresh();

                    String msg = !(community?.isMuted ?? false)
                        ? AppLocalizations.of(context)!.group_unmuted
                        : AppLocalizations.of(context)!.group_muted;
                    showSnackBar(
                      context: context,
                      message: msg,
                    );
                  }
                },
                builder: (context, state) {
                  // LOADING STATE
                  if (state is UpdateMuteGroupLoadingState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomCircularIndicator(),
                      ],
                    );
                  }
                  return MenuIconItem(
                    title: !(community?.isMuted ?? false)
                        ? AppLocalizations.of(context)!.unmute
                        : AppLocalizations.of(context)!.mute,
                    svgPath: !(community?.isMuted ?? false)
                        ? 'assets/menu_unmute.svg'
                        : 'assets/menu_mute.svg',
                    iconSize: 25,
                    onTap: () {
                      BlocProvider.of<UpdateMuteGroupBloc>(context).add(
                        UpdateMuteGroupButtonPressedEvent(
                          communityId: community?.id ?? '',
                          isMute: !(community?.isMuted ?? false),
                        ),
                      );
                    },
                  );
                },
              ),

              // GROUP REPORT OPTION
              // NOTE: REPORT IS NOT WORKING FOR GROUPS NEED TO CHECK
              MenuIconItem(
                title: AppLocalizations.of(context)!.report,
                svgPath: 'assets/menu_flag.svg',
                iconSize: 20,
                textColor: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  reportReasonBottomSheet(
                    context,
                    community?.id ?? '',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // REPORT REASON BOTTOM SHEET
  Future<dynamic> reportReasonBottomSheet(
    BuildContext context,
    String communityId,
  ) {
    // LIST OF REPORT REASON
    List<String> reportReasons = [
      AppLocalizations.of(context)!.inappropriate_content,
      AppLocalizations.of(context)!.spam,
      AppLocalizations.of(context)!.harassment_or_hate_speech,
      AppLocalizations.of(context)!.violence_or_dangerous_organizations,
      AppLocalizations.of(context)!.intellectual_property_violation,
    ];

    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocConsumer<ReportPostBloc, ReportPostState>(
          listener: (context, state) {
            // REPORT POST SUCCESS STATE
            if (state is ReportPostSuccessState) {
              Navigator.of(context).pop();
              reportConfirmationBottomSheet(context);
            }

            // REPORT POST FAILURE STATE
            else if (state is ReportPostFailureState) {
              Navigator.of(context).pop();
              showSnackBar(context: context, message: state.error);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // REPORT POST LOADING STATE
                    state is ReportPostLoadingState
                        ? const CustomCircularIndicator()
                        : Center(
                            child: Text(
                              AppLocalizations.of(context)!.reason_to_report,
                              style: onboardingHeading2Style,
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'group',
                                postId: communityId,
                                reason: reportReasons[0],
                              ),
                            );
                      },
                      leading: Icon(
                        Icons.circle,
                        size: 8,
                        color: AppColors.blackColor,
                      ),
                      title: Text(
                        reportReasons[0],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'group',
                                postId: communityId,
                                reason: reportReasons[1],
                              ),
                            );
                      },
                      leading: Icon(
                        Icons.circle,
                        size: 8,
                        color: AppColors.blackColor,
                      ),
                      title: Text(
                        reportReasons[1],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'group',
                                postId: communityId,
                                reason: reportReasons[2],
                              ),
                            );
                      },
                      leading: Icon(
                        Icons.circle,
                        size: 8,
                        color: AppColors.blackColor,
                      ),
                      title: Text(
                        reportReasons[2],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'group',
                                postId: communityId,
                                reason: reportReasons[3],
                              ),
                            );
                      },
                      leading: Icon(
                        Icons.circle,
                        size: 8,
                        color: AppColors.blackColor,
                      ),
                      title: Text(
                        reportReasons[3],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'group',
                                postId: communityId,
                                reason: reportReasons[4],
                              ),
                            );
                      },
                      leading: Icon(
                        Icons.circle,
                        size: 8,
                        color: AppColors.blackColor,
                      ),
                      title: Text(
                        reportReasons[4],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// REPORT POST CONFIRMATION BOTTOM SHEET
  Future<dynamic> reportConfirmationBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          if (context.mounted) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        });
        return Container(
          color: AppColors.whiteColor,
          height: 240,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/report_confirmation.png'),
              Text(
                AppLocalizations.of(context)!.thanks_for_letting_us_know,
                style: onboardingHeading2Style,
                textAlign: TextAlign.center,
              ),
              Text(
                AppLocalizations.of(context)!
                    .we_appreciate_your_help_in_keeping_our_community_safe_and_respectful_our_team_will_review_the_content_shortly,
                style: blackonboardingBody1Style,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  // JOIN GROUP BOTTOM SHEET
  Future<dynamic> joinGroupBottomSheet(BuildContext context) async {
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
                          Navigator.pop(context);
                          showSnackBar(context: context, message: state.error);
                        }

                        // SUCCESS STATE
                        if (state is JoinGroupSuccessState) {
                          Navigator.pop(context);
                          _onRefresh();
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
                                communityId: widget.communityId,
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

  // LEAVE COMMUNITY BOTTOM SHEET
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
                          Navigator.pop(context);
                          showSnackBar(context: context, message: state.error);
                        }

                        // SUCCESS STATE
                        if (state is LeaveGroupSuccessState) {
                          Navigator.pop(context);
                          Navigator.pop(context, true);
                          _onRefresh();
                          showSnackBar(
                            context: context,
                            message: AppLocalizations.of(context)!
                                .group_leaved_successfully,
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
                              LeaveGroupButtonPressedEvent(
                                communityId: widget.communityId,
                              ),
                            );
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

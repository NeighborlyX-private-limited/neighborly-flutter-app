import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/join_group_bloc.dart';
import 'package:share_it/share_it.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/appbat_button.dart';
import '../../../../core/widgets/menu_icon_widget.dart';
import '../../../../core/widgets/stacked_avatar_indicator_widget.dart';
import '../bloc/community_detail_cubit.dart';
import '../widgets/community_details_sheemer.dart';
import '../widgets/community_section_about.dart';
import '../widgets/community_section_chat.dart';

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
  late CommunityModel? communityCache;
  late bool isJoined;
  late bool isAdmin;
  String? userId;

  /// init method
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    communityDetailCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    communityDetailCubit.getCommunityDetail(widget.communityId);
    getUserId();
  }

  ///on refresh
  Future<void> _onRefresh() async {
    communityDetailCubit.getCommunityDetail(widget.communityId);
  }

  ///get user id
  void getUserId() async {
    userId = ShardPrefHelper.getUserID();
    setState(() {});
  }

  ///dispose method
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// color parser
  Color parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('0xFF$hexColor'));
  }

  /// group image
  Widget topElement(String avatarUrl) {
    bool isColor = avatarUrl.length > 1 && avatarUrl.length < 8;
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

  /// title area
  Widget titleArea({
    required String displayName,
    required String title,
    required int userCount,
    required List<UserSimpleModel> users,
    required bool isPublic,
    required bool isJoined,
    required VoidCallback onJoinLeavePressed,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///group display name
                Text(
                  displayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),

                ///group title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColors.greyColor,
                  ),
                ),
                const SizedBox(height: 5),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///StackedAvatarIndicator
                    StackedAvatarIndicator(
                      avatarUrls: users.map((e) => e.avatarUrl).toList(),
                      showOnly: 4,
                      avatarSize: 14,
                      radius: 9,
                      onTap: () {},
                    ),

                    /// member count
                    Expanded(
                      child: userCount > 1000
                          ? Text(
                              '${userCount}k+ Members',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            )
                          : userCount > 1
                              ? Text(
                                  '$userCount Members',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                )
                              : Text(
                                  '$userCount Member',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                /// is public or private
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      isPublic ? Icons.public : Icons.lock_person_outlined,
                      color: Colors.black,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      isPublic ? 'Public' : 'Private',
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
          ),
          ElevatedButton(
            onPressed: () {
              onJoinLeavePressed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                isJoined ? 'Leave' : 'Join',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 18,
                  height: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// tab bar area
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

  /// bottom sheet to leave group confirmation
  Future<dynamic> bottomSheetLeaveConfirm(BuildContext context, String userId) {
    return showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: AppColors.whiteColor,
      context: context,
      builder: (BuildContext context) {
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
                          borderRadius: BorderRadius.circular(50),
                        ),
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
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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

  ///bottom sheet to mute.unmute group, join group, report group, leave group
  Future<dynamic> bottomSheetMenu(
    BuildContext context,
    String userId,
    String communityName,
    bool isMuted,
  ) {
    return showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: AppColors.whiteColor,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.25,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// leave button
              // MenuIconItem(
              //   title: 'Leave $communityName',
              //   svgPath: 'assets/menu_leave.svg',
              //   iconSize: 25,
              //   onTap: () {
              //     Navigator.pop(context);
              //     bottomSheetLeaveConfirm(context, userId);
              //   },
              // ),

              ///mute .unmute group
              // MenuIconItem(
              //   title: isMuted ? 'Unmute' : 'Mute',
              //   svgPath:
              //       isMuted ? 'assets/menu_unmute.svg' : 'assets/menu_mute.svg',
              //   iconSize: 25,
              //   onTap: () {
              //     communityDetailCubit.toggleMute();
              //     Navigator.pop(context);
              //   },
              // ),

              ///report button
              MenuIconItem(
                title: 'Report',
                svgPath: 'assets/menu_flag.svg',
                iconSize: 20,
                textColor: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  reportReasonBottomSheet(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ///report Confirmation BottomSheet
  Future<dynamic> reportConfirmationBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 240,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/report_confirmation.png'),
              Text(
                'Thanks for letting us know',
                style: onboardingHeading2Style,
              ),
              Text(
                textAlign: TextAlign.center,
                'We appreciate your help in keeping our community safe and respectful. Our team will review the content shortly.',
                style: blackonboardingBody1Style,
              ),
            ],
          ),
        );
      },
    );
  }

  ///report Reason BottomSheet
  Future<dynamic> reportReasonBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Reason to Report',
                    style: onboardingHeading2Style,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...kReportReasons.map(
                      (reason) => InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          communityDetailCubit.reportCommunity(reason);
                          await reportConfirmationBottomSheet(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                reason,
                                style: blackonboardingBody1Style,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        ///back arraow button
        leading: Container(
          margin: EdgeInsets.all(9.0),
          height: 40,
          width: 40,
          child: AppbatButton(
            onTap: () {
              Navigator.pop(context);
            },
            icon: Icons.chevron_left_rounded,
            iconSize: 30,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ///share button
              AppbatButton(
                onTap: () {
                  String message =
                      'Hey, check this community: ${communityCache?.name}';
                  ShareIt.text(
                    content: message,
                    androidSheetTitle: 'Look this event',
                  );
                },
                icon: Icons.share,
                iconSize: 20,
              ),
              const SizedBox(width: 10),

              ///menu button
              AppbatButton(
                onTap: () {
                  if (isAdmin && isJoined) {
                    context.push(
                      '/groups/admin',
                      extra: communityCache,
                    );
                  } else {
                    if (isJoined) {
                      bottomSheetMenu(
                        context,
                        '',
                        communityCache?.name ?? '',
                        communityCache?.isMuted ?? false,
                      );
                    } else {
                      ///define action when a user is not an admin nor group member
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
      body: RefreshIndicator(
        ///refresh is not working i have to check it.
        onRefresh: _onRefresh,
        child: BlocConsumer<CommunityDetailsCubit, CommunityDetailsState>(
          bloc: communityDetailCubit,
          listener: (BuildContext context, CommunityDetailsState state) {
            if (state.status == Status.loading) {}
            if (state.status == Status.success) {}
            if (state.status == Status.failure) {}
          },
          builder: (context, state) {
            ///loadinng state
            if (state.status == Status.loading) {
              return const CommunityDetailsSheemer();
            }

            ///failure state
            if (state.status == Status.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Something went wrong'),
              );
            }
            if (state.status == Status.success) {
              isAdmin = state.community?.isAdmin ?? false;
              isJoined = state.community?.isJoined ?? false;
              communityCache = state.community;
              return Column(
                children: [
                  topElement(state.community!.avatarUrl),
                  titleArea(
                    displayName: state.community?.displayName ?? '',
                    title: state.community?.name ?? '',
                    isPublic: state.community?.isPublic ?? false,
                    isJoined: isJoined,
                    userCount: (state.community?.users.length ?? 0) +
                        (state.community?.admins.length ?? 0),
                    users: [
                      ...(state.community?.users ?? []),
                      ...(state.community?.admins ?? [])
                    ],
                    onJoinLeavePressed: () {
                      if (state.community?.isJoined ?? false) {
                        showModalBottomSheet(
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
                                    'Leave Community?',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Are you sure you want to leave this community?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            'Cancel',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      // Confirm Button
                                      Expanded(
                                        child: BlocConsumer<JoinGroupBloc,
                                            JoinGroupState>(
                                          listener: (context, state) {
                                            /// failure state
                                            if (state
                                                is JoinGroupFailureState) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Error: ${state.error}'),
                                                ),
                                              );
                                            }

                                            /// success state
                                            if (state
                                                is LeaveGroupSuccessState) {
                                              communityDetailCubit
                                                  .getCommunityDetail(
                                                      widget.communityId);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text('Group leave'),
                                                ),
                                              );
                                            }
                                          },
                                          builder: (context, state) {
                                            ///loading state
                                            if (state
                                                is JoinGroupLoadingState) {
                                              return CircularProgressIndicator();
                                            }
                                            return ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primaryColor,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                BlocProvider.of<JoinGroupBloc>(
                                                        context)
                                                    .add(
                                                        LeaveGroupButtonPressedEvent(
                                                  communityId:
                                                      widget.communityId,
                                                ));
                                              },
                                              child: Text(
                                                'Leave',
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
                      } else {
                        showModalBottomSheet(
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
                                    'Join Community?',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Are you sure you want to join this community?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            'Cancel',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      // Confirm Button
                                      Expanded(
                                        child: BlocConsumer<JoinGroupBloc,
                                            JoinGroupState>(
                                          listener: (context, state) {
                                            /// failure state
                                            if (state
                                                is JoinGroupFailureState) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Error: ${state.error}'),
                                                ),
                                              );
                                            }

                                            /// success state
                                            if (state
                                                is JoinGroupSuccessState) {
                                              communityDetailCubit
                                                  .getCommunityDetail(
                                                      widget.communityId);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text('Group join'),
                                                ),
                                              );
                                            }
                                          },
                                          builder: (context, state) {
                                            ///loading state
                                            if (state
                                                is JoinGroupLoadingState) {
                                              return CircularProgressIndicator();
                                            }
                                            return ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primaryColor,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                BlocProvider.of<JoinGroupBloc>(
                                                        context)
                                                    .add(
                                                        JoinGroupButtonPressedEvent(
                                                  communityId:
                                                      widget.communityId,
                                                ));
                                              },
                                              child: Text(
                                                'Join',
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
                    },
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, right: 5),
                      child: TabBar(
                        indicatorColor: AppColors.primaryColor,
                        unselectedLabelColor: Colors.grey,
                        unselectedLabelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        controller: _tabController,
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        tabs: [
                          Tab(
                            child: tabTitle('About'),
                          ),
                          Tab(
                            child: tabTitle('Chat'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        CommunitySectionAbout(
                          community: state.community!,
                        ),

                        // CommunitySectionPosts(
                        //     isLoading: false,
                        //     isEmpty: (state.status != Status.loading && state.posts.isEmpty),
                        //     posts: state.posts,
                        //     onReport: (postId) {
                        //       print('postId=$postId');
                        //     },
                        //     onDelete: (postId) {
                        //       print('postId=$postId');
                        //     },
                        //     onTap: (postId) {
                        //       print('postId=$postId');
                        //     },
                        //     onReact: (postId) {
                        //       print('postId=$postId');
                        //     }),
                        //

                        ///  chat section
                        CommunitySectionChat(community: state.community!),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Center(
              child: Text(state.errorMessage ?? 'Something went wrong'),
            );
          },
        ),
      ),
    );
  }
}

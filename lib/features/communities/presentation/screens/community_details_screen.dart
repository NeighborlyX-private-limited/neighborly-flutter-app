import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  late var communityDetailCubit;
  late bool isJoined;
  late bool isAdmin;
  late CommunityModel? communityCache;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    communityDetailCubit = BlocProvider.of<CommunityDetailsCubit>(context);

    communityDetailCubit.init(widget.communityId);
    isAdmin = false;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget topElement(String avatarUrl) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(avatarUrl),
        ),
      ),
    );
  }

  Widget titleArea(
      {required String title,
      required num userCount,
      required List<UserSimpleModel> users,
      required bool isPublic}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              // color: Colors.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  //
                  //

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // width: 200,
                        // color: Colors.green,
                        child: StackedAvatarIndicator(
                          avatarUrls: users.map((e) => e.avatarUrl).toList(),
                          showOnly: 4,
                          avatarSize: 14,
                          radius: 9,
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${userCount}k+ Members',
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
                  //
                  //
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
                  //
                  //
                ],
              ),
            ),
          ),
          //
          //
          ElevatedButton(
            onPressed: () {
              // Lógica ao clicar no botão
              // context.go('/groups/create');
              if (isJoined) {
                bottomSheetMenu(context, '', communityCache?.name ?? '',
                    communityCache?.isMuted ?? false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isJoined ? Colors.white : AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    50), // Ajuste o raio conforme necessário
              ),
              // padding: EdgeInsets.all(15)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                isJoined ? 'Joined' : 'Join',
                style: TextStyle(
                    color: isJoined ? AppColors.primaryColor : Colors.white,
                    fontSize: 18,
                    height: 0.3),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget tabTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          // color: Colors.black,
        ),
      ),
    );
  }

  Future<dynamic> bottomSheetLeaveConfirm(BuildContext context, String userId) {
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
                        print(' leaving ');

                        // TODO - insert cubit leave action
                        communityDetailCubit.leaveCommunity();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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

  Future<dynamic> bottomSheetMenu(
      BuildContext context, String userId, String communityName, bool isMuted) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // String? userId = ShardPrefHelper.getUserID();
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.25,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MenuIconItem(
                  title: 'Leave $communityName',
                  svgPath: 'assets/menu_leave.svg',
                  iconSize: 25,
                  onTap: () {
                    Navigator.pop(context);
                    bottomSheetLeaveConfirm(context, userId);
                  }),
              MenuIconItem(
                  title: isMuted ? 'Unmute' : 'Mute',
                  svgPath: isMuted
                      ? 'assets/menu_unmute.svg'
                      : 'assets/menu_mute.svg',
                  iconSize: 25,
                  onTap: () {
                    communityDetailCubit.toggleMute();
                    Navigator.pop(context);
                  }),
              MenuIconItem(
                  title: 'Report',
                  svgPath: 'assets/menu_flag.svg',
                  iconSize: 20,
                  textColor: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    reportReasonBottomSheet(context);
                  }),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> reportConfirmationBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
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
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
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

  Future<dynamic> reportReasonBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
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
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xffB8B8B8),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
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
                    ...kReportReasons
                        .map(
                          (e) => InkWell(
                            onTap: () async {
                              print('...on Select the report reason');
                              Navigator.of(context).pop();
                              communityDetailCubit.reportCommunity(e);
                              await reportConfirmationBottomSheet(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    e,
                                    style: blackonboardingBody1Style,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        ,
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(9.0),
          height: 40,
          width: 40,
          child: AppbatButton(
            onTap: () {
              Navigator.pop(context);
            },
            // icon: LineIcons.angleLeft,
            icon: Icons.chevron_left_rounded,
            iconSize: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
        // title: const Text('community create'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppbatButton(
                onTap: () {
                  String message = '''
                  Hey, check this community:   ${communityCache?.name} 
                  ''';
                  // Lógica ao clicar no botão
                  // context.go('/groups/create');
                  ShareIt.text(
                      content: message, androidSheetTitle: 'Look this event');

                  // TODO: remove this, only for presentation/test porpouse
                  context.push('/groups/admin', extra: communityCache);
                },
                icon: Icons.share,
                iconSize: 20,
              ),
              const SizedBox(width: 10),
              AppbatButton(
                onTap: () {
                  print('...TAP menu settings');

                  if (isAdmin) {
                    context.push('/groups/admin', extra: communityCache);
                  } else {
                    if (isJoined) {
                      bottomSheetMenu(context, '', communityCache?.name ?? '',
                          communityCache?.isMuted ?? false);
                    }
                  }
                },
                // icon: LineIcons.verticalEllipsis,
                icon: Icons.more_vert_outlined,
                iconSize: 25,
              ),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
      body: BlocBuilder<CommunityDetailsCubit, CommunityDetailsState>(
        bloc: communityDetailCubit,
        builder: (context, state) {
          isJoined = state.community?.isJoined ?? false;
          communityCache = state.community;

          if (state.status == Status.loading) {
            return const CommunityDetailsSheemer();
          }

          // print('... community${state.community}');
          print('... isMuted${state.community?.isMuted}');

          return Column(
            children: [
              //
              topElement(state.community!.avatarUrl),
              //
              //
              titleArea(
                title: state.community?.name ?? '...',
                userCount: state.community?.users.length ?? 0,
                users: state.community?.users ?? [],
                isPublic: state.community?.isPublic ?? false,
              ),
              //
              //
              const SizedBox(height: 15),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
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

                    // labelColor: AppColors.primaryColor.withOpacity(0.8),
                    controller: _tabController,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    // labelPadding: EdgeInsets.only(left: 0, right: 20),
                    tabs: [
                      Tab(child: tabTitle('About')),
                      // Tab(child: tabTitle('Feed')),
                      Tab(child: tabTitle('Chat')),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    //
                    // section ABOUT
                    CommunitySectionAbout(
                      community: state.community!,
                    ),
                    //
                    //
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
                    //  section CHAT
                    CommunitySectionChat(community: state.community!),
                    //
                    //
                  ],
                ),
              ),
              //
              //
            ],
          );
        },
      ),
    );
  }
}

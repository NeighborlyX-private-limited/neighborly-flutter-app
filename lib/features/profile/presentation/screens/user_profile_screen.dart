import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/report_post_bloc/report_post_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_user_info_bloc/get_user_info_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/comments_section.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/groups_section.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/posts_section.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/profile_sheemer_widget.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchProfile() {
    BlocProvider.of<GetUserInfoBloc>(context)
        .add(GetUserInfoButtonPressedEvent(userId: widget.userId));
    print('user id: ${widget.userId}');
  }

  @override
  Widget build(BuildContext context) {
    void showBottomSheet() {
      bottomSheet(context);
    }

    return Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          child: BlocBuilder<GetUserInfoBloc, GetUserInfoState>(
              builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: InkWell(
                  child: const Icon(Icons.arrow_back_ios, size: 15),
                  onTap: () => context.pop(),
                ),
                title: BlocBuilder<GetUserInfoBloc, GetUserInfoState>(
                  builder: (context, state) {
                    if (state is GetUserInfoSuccessState) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          state.profile.username,
                          style: onboardingHeading2Style,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      showBottomSheet();
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      size: 25,
                    ),
                  ),
                ],
              ),
              body: BlocBuilder<GetUserInfoBloc, GetUserInfoState>(
                builder: (context, state) {
                  if (state is GetUserInfoLoadingState) {
                    return const ProfileShimmerWidget();
                  } else if (state is GetUserInfoSuccessState) {
                    return Column(
                      children: [
                        // Profile image
                        Center(
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              state.profile.picture,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          state.profile.username,
                          style: greyonboardingBody1Style,
                        ),
                        const SizedBox(height: 10),
                        state.profile.bio != null
                            ? Text(
                                state.profile.bio!,
                                style: mediumGreyTextStyleBlack,
                              )
                            : const SizedBox(),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  state.profile.postCount.toString(),
                                  style: onboardingBlackBody2Style,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Post',
                                  style: mediumGreyTextStyleBlack,
                                ),
                              ],
                            ),
                            const SizedBox(width: 55),
                            Column(
                              children: [
                                Text(
                                  state.profile.karma.toString(),
                                  style: onboardingBlackBody2Style,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Karma',
                                  style: mediumGreyTextStyleBlack,
                                ),
                              ],
                            ),
                            const SizedBox(width: 55),
                            Column(
                              children: [
                                Text(
                                  state.profile.awardsCount.toString(),
                                  style: onboardingBlackBody2Style,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Awards',
                                  style: mediumGreyTextStyleBlack,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: TabBar(
                              indicatorColor: AppColors.primaryColor,
                              labelColor:
                                  AppColors.primaryColor.withOpacity(0.8),
                              controller: _tabController,
                              tabs: const [
                                Tab(text: 'Posts'),
                                Tab(text: 'Comments'),
                                Tab(text: 'Communities'),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              PostSection(
                                userId: widget.userId,
                              ),
                              CommentSection(
                                userId: widget.userId,
                              ),
                              GroupSection(
                                userId: widget.userId,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is GetUserInfoFailureState) {
                    return Center(
                      child: Text(state.error),
                    );
                  }
                  return const SizedBox();
                },
              ),
            );
          }),
        ));
  }

  Future<void> bottomSheet(BuildContext context) {
    void showReportReasonBottomSheet() {
      reportReasonBottomSheet(context);
    }

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: 160,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
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
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/react4.svg'),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Share this profile',
                      style: onboardingBodyStyle,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              InkWell(
                onTap: () {
                  showReportReasonBottomSheet();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/report_flag.png'),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Report',
                      style: redOnboardingBody1Style,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/block.svg'),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Block',
                      style: redOnboardingBody1Style,
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> reportReasonBottomSheet(BuildContext context) {
    void showReportConfirmationBottomSheet() {
      reportConfirmationBottomSheet(context);
    }

    List<String> reportReasons = [
      'Inappropriate content',
      'Spam',
      'Harassment or hate speech',
      'Violence or dangerous organizations',
      'Intellectual property violation',
    ];
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<ReportPostBloc, ReportPostState>(
          listener: (context, state) {
            if (state is ReportPostSuccessState) {
              Navigator.pop(context);
              Navigator.pop(context);
              showReportConfirmationBottomSheet();
            } else if (state is ReportPostFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                    state is ReportPostLoadingState
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Center(
                            child: Text(
                              'Reason to Report',
                              style: onboardingHeading2Style,
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         context.read<ReportPostBloc>().add(
                    //             ReportButtonPressedEvent(
                    //                 type: 'post',
                    //                 postId: post.id,
                    //                 reason: reportReasons[0]));
                    //       },
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             reportReasons[0],
                    //             style: blackonboardingBody1Style,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       height: 10,
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         context.read<ReportPostBloc>().add(
                    //             ReportButtonPressedEvent(
                    //                 type: 'post',
                    //                 postId: post.id,
                    //                 reason: reportReasons[1]));
                    //       },
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             reportReasons[1],
                    //             style: blackonboardingBody1Style,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       height: 10,
                    //     ),
                    //     InkWell(
                    //       onTap: () => context.read<ReportPostBloc>().add(
                    //           ReportButtonPressedEvent(
                    //               type: 'post',
                    //               postId: post.id,
                    //               reason: reportReasons[2])),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             reportReasons[2],
                    //             style: blackonboardingBody1Style,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       height: 10,
                    //     ),
                    //     InkWell(
                    //       onTap: () => context.read<ReportPostBloc>().add(
                    //           ReportButtonPressedEvent(
                    //               type: 'post',
                    //               postId: post.id,
                    //               reason: reportReasons[3])),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             reportReasons[3],
                    //             style: blackonboardingBody1Style,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       height: 10,
                    //     ),
                    //     InkWell(
                    //       onTap: () => context.read<ReportPostBloc>().add(
                    //           ReportButtonPressedEvent(
                    //               type: 'post',
                    //               postId: post.id,
                    //               reason: reportReasons[4])),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             reportReasons[4],
                    //             style: blackonboardingBody1Style,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<dynamic> reportConfirmationBottomSheet(BuildContext context) {
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
}

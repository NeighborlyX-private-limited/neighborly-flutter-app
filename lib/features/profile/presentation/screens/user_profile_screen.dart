// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:share_it/share_it.dart';

// import '../../../../core/theme/colors.dart';
// import '../../../../core/theme/text_style.dart';
// import '../bloc/get_user_info_bloc/get_user_info_bloc.dart';
// import '../widgets/comments_section.dart';
// import '../widgets/groups_section.dart';
// import '../widgets/posts_section.dart';
// import '../widgets/profile_sheemer_widget.dart';

// class UserProfileScreen extends StatefulWidget {
//   final String userId;
//   const UserProfileScreen({super.key, required this.userId});

//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _fetchProfile();

//     print('... INIT UserProfileScreen userId=${widget.userId}');
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _fetchProfile() {
//     BlocProvider.of<GetUserInfoBloc>(context)
//         .add(GetUserInfoButtonPressedEvent(userId: widget.userId));
//   }

//   @override
//   Widget build(BuildContext context) {
//     void showBottomSheet() {
//       bottomSheet(context);
//     }

//     String checkStringInList(String str) {
//       switch (str) {
//         case 'Local Legend':
//           return 'assets/Local_Legend.svg';
//         case 'Sunflower':
//           return 'assets/Sunflower.svg';
//         case 'Streetlight':
//           return 'assets/Streetlight.svg';
//         case 'Park Bench':
//           return 'assets/Park_Bench.svg';
//         case 'Map':
//           return 'assets/Map.svg';
//         default:
//           return 'assets/react7.svg';
//       }
//     }

//     return Directionality(
//         textDirection: TextDirection.ltr,
//         child: SafeArea(
//           child: BlocBuilder<GetUserInfoBloc, GetUserInfoState>(
//               builder: (context, state) {
//             return Scaffold(
//               backgroundColor: Colors.white,
//               appBar: AppBar(
//                 backgroundColor: Colors.white,
//                 leading: InkWell(
//                   child: const Icon(Icons.arrow_back_ios, size: 15),
//                   onTap: () => context.pop(),
//                 ),
//                 title: BlocBuilder<GetUserInfoBloc, GetUserInfoState>(
//                   builder: (context, state) {
//                     if (state is GetUserInfoSuccessState) {
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           state.profile.username,
//                           style: onboardingHeading2Style,
//                         ),
//                       );
//                     }
//                     return const SizedBox();
//                   },
//                 ),
//                 actions: [
//                   IconButton(
//                     onPressed: () {
//                       showBottomSheet();
//                     },
//                     icon: const Icon(
//                       Icons.more_vert,
//                       size: 25,
//                     ),
//                   ),
//                 ],
//               ),
//               body: BlocBuilder<GetUserInfoBloc, GetUserInfoState>(
//                 builder: (context, state) {
//                   if (state is GetUserInfoLoadingState) {
//                     return const ProfileShimmerWidget();
//                   } else if (state is GetUserInfoSuccessState) {
//                     return Column(
//                       children: [
//                         // Profile image
//                         Center(
//                           child: Stack(
//                             children: [
//                               ClipOval(
//                                 child: Container(
//                                   width: 90,
//                                   height: 90,
//                                   decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Image.network(
//                                     state.profile.picture,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 0,
//                                 right: 0,
//                                 child: Container(
//                                   width: 24,
//                                   height: 24,
//                                   decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.white,
//                                   ),
//                                   child: SvgPicture.asset(
//                                     checkStringInList(
//                                         state.profile?.mostProminentAward ?? ''),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           state.profile.username,
//                           style: greyonboardingBody1Style,
//                         ),
//                         const SizedBox(height: 2),
//                         state.profile.mostProminentAward != null
//                             ? Text(
//                                 state.profile.mostProminentAward!,
//                                 style: itallicMediumGreyTextStyleBlack,
//                               )
//                             : const SizedBox(),
//                         const SizedBox(height: 2),
//                         state.profile.bio != null
//                             ? Text(
//                                 state.profile.bio!,
//                                 style: mediumGreyTextStyleBlack,
//                               )
//                             : const SizedBox(),
//                         const SizedBox(height: 15),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Column(
//                               children: [
//                                 Text(
//                                   state.profile.postCount.toString(),
//                                   style: onboardingBlackBody2Style,
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Text(
//                                   'Post',
//                                   style: mediumGreyTextStyleBlack,
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(width: 55),
//                             Column(
//                               children: [
//                                 Text(
//                                   state.profile.karma.toString(),
//                                   style: onboardingBlackBody2Style,
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Text(
//                                   'Karma',
//                                   style: mediumGreyTextStyleBlack,
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(width: 55),
//                             Column(
//                               children: [
//                                 Text(
//                                   state.profile.awardsCount.toString(),
//                                   style: onboardingBlackBody2Style,
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Text(
//                                   'Awards',
//                                   style: mediumGreyTextStyleBlack,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 15),
//                         Container(
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 5, right: 5),
//                             child: TabBar(
//                               indicatorColor: AppColors.primaryColor,
//                               labelColor:
//                                   AppColors.primaryColor.withOpacity(0.8),
//                               controller: _tabController,
//                               tabs: const [
//                                 Tab(text: 'Posts'),
//                                 Tab(text: 'Comments'),
//                                 Tab(text: 'Communities'),
//                               ],
//                             ),
//                           ),
//                         ),

//                         Expanded(
//                           child: TabBarView(
//                             controller: _tabController,
//                             children: [
//                               PostSection(
//                                 userId: widget.userId,
//                               ),
//                               CommentSection(
//                                 userId: widget.userId,
//                               ),
//                               GroupSection(
//                                 userId: widget.userId,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   } else if (state is GetUserInfoFailureState) {
//                     return Center(
//                       child: Text(state.error),
//                     );
//                   }
//                   return const SizedBox();
//                 },
//               ),
//             );
//           }),
//         ));
//   }

//   Future<void> bottomSheet(BuildContext context) {
//     return showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           height: 160,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
//               InkWell(
//                 onTap: () {
//                   String link = 'https://prod.neighborly.in/userProfileScreen/${widget.userId}';
//                   ShareIt.text(
//                       content: '$link',
//                       androidSheetTitle: 'Cool Person');
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SvgPicture.asset('assets/react4.svg'),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       'Share this profile',
//                       style: onboardingBodyStyle,
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
//               InkWell(
//                 onTap: () {},
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SvgPicture.asset('assets/block.svg'),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       'Block',
//                       style: redOnboardingBody1Style,
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_it/share_it.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../bloc/get_user_info_bloc/get_user_info_bloc.dart';
import '../widgets/comments_section.dart';
import '../widgets/groups_section.dart';
import '../widgets/posts_section.dart';
import '../widgets/profile_sheemer_widget.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isTabBarVisible = false;

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
  }

  String checkStringInList(String str) {
    switch (str) {
      case 'Local Legend':
        return 'assets/Local_Legend.svg';
      case 'Sunflower':
        return 'assets/Sunflower.svg';
      case 'Streetlight':
        return 'assets/Streetlight.svg';
      case 'Park Bench':
        return 'assets/Park_Bench.svg';
      case 'Map':
        return 'assets/Map.svg';
      default:
        return 'assets/react7.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder<GetUserInfoBloc, GetUserInfoState>(
            builder: (context, state) {
              if (state is GetUserInfoLoadingState) {
                return const ProfileShimmerWidget();
              } else if (state is GetUserInfoSuccessState) {
                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    _isTabBarVisible = innerBoxIsScrolled;
                    return <Widget>[
                      SliverAppBar(
                        pinned: true,
                        floating: true,
                        backgroundColor: Colors.white,
                        expandedHeight: 300.0,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                        title: _isTabBarVisible
                            ? Text(
                                state.profile.username,
                                style: onboardingHeading2Style,
                              )
                            : Text(
                                'Profile',
                                style: onboardingHeading2Style,
                              ),
                        actions: [
                          IconButton(
                            onPressed: () {
                              _showBottomSheet(context);
                            },
                            icon: const Icon(
                              Icons.more_vert,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(
                            children: [
                              const SizedBox(height: 50),
                              Center(
                                child: Stack(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        width: 90,
                                        height: 90,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.network(
                                          state.profile.picture,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: SvgPicture.asset(
                                          checkStringInList(state
                                                  .profile.mostProminentAward ??
                                              'Map'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                state.profile.username,
                                style: greyonboardingBody1Style,
                              ),
                              const SizedBox(height: 2),
                              state.profile.mostProminentAward != null
                                  ? Text(
                                      state.profile.mostProminentAward!,
                                      style: itallicMediumGreyTextStyleBlack,
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: 2),
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
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            indicatorColor: AppColors.primaryColor,
                            labelColor: AppColors.primaryColor.withOpacity(0.8),
                            controller: _tabController,
                            tabs: const [
                              Tab(text: 'Posts'),
                              Tab(text: 'Comments'),
                              Tab(text: 'Communities'),
                            ],
                          ),
                        ),
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      PostSection(userId: widget.userId),
                      CommentSection(userId: widget.userId),
                      GroupSection(userId: widget.userId),
                    ],
                  ),
                );
              } else if (state is GetUserInfoFailureState) {
                return Center(
                  child: Text(state.error),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
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
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  String link =
                      'https://prod.neighborly.in/userProfileScreen/${widget.userId}';
                  ShareIt.text(
                      content: '$link', androidSheetTitle: 'Cool Person');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/react4.svg'),
                    const SizedBox(width: 10),
                    Text('Share this profile', style: onboardingBodyStyle),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/block.svg'),
                    const SizedBox(width: 10),
                    Text('Block', style: redOnboardingBody1Style),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

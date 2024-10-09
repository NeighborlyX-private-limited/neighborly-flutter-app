// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';

// import '../../../../core/theme/colors.dart';
// import '../../../../core/theme/text_style.dart';
// import '../bloc/get_my_comments_bloc/get_my_comments_bloc.dart';
// import '../bloc/get_my_groups_bloc/get_my_groups_bloc.dart';
// import '../bloc/get_my_posts_bloc/get_my_posts_bloc.dart';
// import '../bloc/get_profile_bloc/get_profile_bloc.dart';
// import '../widgets/comments_section.dart';
// import '../widgets/groups_section.dart';
// import '../widgets/posts_section.dart';
// import '../widgets/profile_sheemer_widget.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _fetchProfile();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _fetchProfile() {
//     BlocProvider.of<GetProfileBloc>(context)
//         .add(GetProfileButtonPressedEvent());
//     BlocProvider.of<GetMyPostsBloc>(context)
//         .add(GetMyPostsButtonPressedEvent());
//     BlocProvider.of<GetMyCommentsBloc>(context)
//         .add(GetMyCommentsButtonPressedEvent());
//     BlocProvider.of<GetMyGroupsBloc>(context)
//         .add(GetMyGroupsButtonPressedEvent());
//   }

//   String checkStringInList(String str) {
//     switch (str) {
//       case 'Local Legend':
//         return 'assets/Local_Legend.svg';
//       case 'Sunflower':
//         return 'assets/Sunflower.svg';
//       case 'Streetlight':
//         return 'assets/Streetlight.svg';
//       case 'Park Bench':
//         return 'assets/Park_Bench.svg';
//       case 'Map':
//         return 'assets/Map.svg';
//       default:
//         return 'assets/react7.png';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             title: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Profile',
//                 style: onboardingHeading2Style,
//               ),
//             ),
//             actions: [
//               BlocBuilder<GetProfileBloc, GetProfileState>(
//                 builder: (context, state) {
//                   if (state is GetProfileSuccessState) {
//                     return IconButton(
//                       onPressed: () {
//                         context.push(
//                             '/settingsScreen/${state.profile.karma.toString()}/${state.profile.findMe}');
//                       },
//                       icon: const Icon(
//                         Icons.settings_outlined,
//                         size: 25,
//                       ),
//                     );
//                   } else {
//                     return const SizedBox();
//                   }
//                 },
//               ),
//             ],
//           ),
//           body: BlocBuilder<GetProfileBloc, GetProfileState>(
//             builder: (context, state) {
//               if (state is GetProfileLoadingState) {
//                 return const ProfileShimmerWidget();
//               } else if (state is GetProfileSuccessState) {
//                 return Column(
//                   children: [
//                     Center(
//                       child: Stack(
//                         children: [
//                           ClipOval(
//                             child: Container(
//                               width: 90,
//                               height: 90,
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Image.network(
//                                 state.profile.picture,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             right: 0,
//                             child: Container(
//                               width: 24,
//                               height: 24,
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                               ),
//                               child: SvgPicture.asset(
//                                 checkStringInList(
//                                     state.profile.mostProminentAward ?? 'Map'),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       state.profile.username,
//                       style: greyonboardingBody1Style,
//                     ),
//                     const SizedBox(height: 2),
//                     state.profile.mostProminentAward != null
//                         ? Text(
//                             state.profile.mostProminentAward!,
//                             style: itallicMediumGreyTextStyleBlack,
//                           )
//                         : const SizedBox(),
//                     const SizedBox(height: 2),
//                     state.profile.bio != null
//                         ? Text(
//                             state.profile.bio!,
//                             style: mediumGreyTextStyleBlack,
//                           )
//                         : const SizedBox(),
//                     const SizedBox(height: 15),
//                     Center(
//                       child: SizedBox(
//                         width: 250,
//                         child: Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Column(
//                                 children: [
//                                   Text(
//                                     state.profile.postCount.toString(),
//                                     style: onboardingBlackBody2Style,
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Text(
//                                     'Post',
//                                     style: mediumGreyTextStyleBlack,
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(width: 55),
//                               Column(
//                                 children: [
//                                   Text(
//                                     state.profile.karma.toString(),
//                                     style: onboardingBlackBody2Style,
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Text(
//                                     'Karma',
//                                     style: mediumGreyTextStyleBlack,
//                                   ),
//                                 ],
//                               ),
//                               state.profile.awardsCount != 0
//                                   ? const SizedBox(width: 55)
//                                   : const SizedBox(),
//                               state.profile.awardsCount != 0
//                                   ? Column(
//                                       children: [
//                                         Text(
//                                           state.profile.awardsCount.toString(),
//                                           style: onboardingBlackBody2Style,
//                                         ),
//                                         const SizedBox(height: 5),
//                                         Text(
//                                           'Awards',
//                                           style: mediumGreyTextStyleBlack,
//                                         ),
//                                       ],
//                                     )
//                                   : const SizedBox(),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Container(
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 5, right: 5),
//                         child: TabBar(
//                           indicatorColor: AppColors.primaryColor,
//                           labelColor: AppColors.primaryColor.withOpacity(0.8),
//                           controller: _tabController,
//                           tabs: const [
//                             Tab(text: 'Posts'),
//                             Tab(text: 'Comments'),
//                             //  Tab(text: 'Communities'),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TabBarView(
//                         controller: _tabController,
//                         children: const [
//                           PostSection(),
//                           CommentSection(),
//                           // GroupSection(),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               } else if (state is GetProfileFailureState) {
//                 if (state.error.contains('Invalid Token')) {
//                   context.go('/loginScreen');
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(state.error)),
//                   );
//                 }
//               }
//               return const SizedBox();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../bloc/get_my_comments_bloc/get_my_comments_bloc.dart';
import '../bloc/get_my_groups_bloc/get_my_groups_bloc.dart';
import '../bloc/get_my_posts_bloc/get_my_posts_bloc.dart';
import '../bloc/get_profile_bloc/get_profile_bloc.dart';
import '../widgets/comments_section.dart';
import '../widgets/groups_section.dart';
import '../widgets/posts_section.dart';
import '../widgets/profile_sheemer_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isTabBarVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchProfile() {
    BlocProvider.of<GetProfileBloc>(context)
        .add(GetProfileButtonPressedEvent());
    BlocProvider.of<GetMyPostsBloc>(context)
        .add(GetMyPostsButtonPressedEvent());
    BlocProvider.of<GetMyCommentsBloc>(context)
        .add(GetMyCommentsButtonPressedEvent());
    BlocProvider.of<GetMyGroupsBloc>(context)
        .add(GetMyGroupsButtonPressedEvent());
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
        return 'assets/react7.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder<GetProfileBloc, GetProfileState>(
            builder: (context, state) {
              if (state is GetProfileLoadingState) {
                return const ProfileShimmerWidget();
              } else if (state is GetProfileSuccessState) {
                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    _isTabBarVisible =
                        innerBoxIsScrolled; // Detect scroll position
                    return <Widget>[
                      SliverAppBar(
                        pinned: true,
                        backgroundColor: Colors.white,
                        expandedHeight: 280.0,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            // Navigate to the home screen using GoRouter
                            context.go('/home/false');
                          },
                        ),
                        title: _isTabBarVisible
                            ? Text(
                                state.profile.username[0].toUpperCase() +
                                    state.profile.username.substring(1),
                                style: onboardingHeading2Style.copyWith(),
                              )
                            // ? Text(
                            //     state.profile.username.to,
                            //     style: onboardingHeading2Style.copyWith(),
                            //   )
                            : Text(
                                'Profile',
                                style: onboardingHeading2Style.copyWith(),
                              ),
                        actions: [
                          // if (!_isTabBarVisible)
                          IconButton(
                            onPressed: () {
                              context.push(
                                  '/settingsScreen/${state.profile.karma.toString()}/${state.profile.findMe}');
                            },
                            icon: const Icon(
                              Icons.settings_outlined,
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
                                        child: CachedNetworkImage(
                                          imageUrl: state.profile.picture,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Center(
                                            child: SizedBox(
                                              height: 26,
                                              width: 26,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.blue,
                                              ),
                                            ), // Show loading indicator
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons
                                                  .error), // Show error icon if image fails to load
                                        ),
                                        // child: Image.network(
                                        //   state.profile.picture,
                                        //   fit: BoxFit.cover,
                                        // ),
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
                              Center(
                                child: SizedBox(
                                  width: 250,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              state.profile.postCount
                                                  .toString(),
                                              style: onboardingBlackBody2Style,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Posts',
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
                                        // state.profile.awardsCount != 0
                                        //     ? const SizedBox(width: 55)
                                        //     : const SizedBox(),
                                        // state.profile.awardsCount != 0
                                        // ?
                                        Column(
                                          children: [
                                            Text(
                                              state.profile.awardsCount
                                                  .toString(),
                                              style: onboardingBlackBody2Style,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Awards',
                                              style: mediumGreyTextStyleBlack,
                                            ),
                                          ],
                                        )
                                        // : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
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
                            ],
                          ),
                        ),
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: const [
                      PostSection(),
                      CommentSection(),
                    ],
                  ),
                );
              } else if (state is GetProfileFailureState) {
                if (state.error.contains('Invalid Token')) {
                  context.go('/loginScreen');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              }
              return const SizedBox();
            },
          ),
        ),
      ),
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

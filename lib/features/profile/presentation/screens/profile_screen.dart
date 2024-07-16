import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_profile_bloc/get_profile_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/comments_section.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/groups_section.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/posts_section.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/profile_sheemer_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
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
    BlocProvider.of<GetProfileBloc>(context)
        .add(GetProfileButtonPressedEvent());
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
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Profile',
                style: onboardingHeading2Style,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.push('/settingsScreen');
                },
                icon: const Icon(
                  Icons.settings_outlined,
                  size: 25,
                ),
              ),
            ],
          ),
          body: BlocBuilder<GetProfileBloc, GetProfileState>(
            builder: (context, state) {
              if (state is GetProfileLoadingState) {
                return const ProfileShimmerWidget();
              } else if (state is GetProfileSuccessState) {
                return Column(
                  children: [
                    // Profile image
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
                                checkStringInList(
                                    state.profile.mostProminentAward ?? 'Map'),
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
                          labelColor: AppColors.primaryColor.withOpacity(0.8),
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
                        children: const [
                          PostSection(),
                          CommentSection(),
                          GroupSection(),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (state is GetProfileFailureState) {
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
}

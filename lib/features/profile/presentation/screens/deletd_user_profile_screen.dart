import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';

class DeletedUserProfileScreen extends StatefulWidget {
  const DeletedUserProfileScreen({super.key});

  @override
  State<DeletedUserProfileScreen> createState() =>
      _DeletedUserProfileScreenState();
}

class _DeletedUserProfileScreenState extends State<DeletedUserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isTabBarVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) {
              _isTabBarVisible = innerBoxIsScrolled;
              return <Widget>[
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.white,
                  expandedHeight: 300.0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      context.go('/home/Home');
                    },
                  ),
                  title: Text(
                    'Profile',
                    style: onboardingHeading2Style.copyWith(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      children: [
                        const SizedBox(height: 50),
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/deleted_user.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Neighborly user',
                            style: greyonboardingBody1Style,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Boo! Looks like this profile is no longer with us.',
                          style: mediumGreyTextStyleBlack,
                        ),
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
                                        '0',
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
                                        '0',
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
                                        '0',
                                        style: onboardingBlackBody2Style,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Awards',
                                        style: mediumGreyTextStyleBlack,
                                      ),
                                    ],
                                  )
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
                Center(
                  child: Text('No posts to haunt this profile!'),
                ),
                Center(
                  child: Text('Comments have drifted away!'),
                ),
              ],
            ),
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

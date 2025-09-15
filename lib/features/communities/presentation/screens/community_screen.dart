import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/constants/app_images.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/get_user_groups_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/widgets/somthing_went_wrong.dart';
import '../../../../core/widgets/svg_icon.dart';
import '../bloc/communities_main_cubit.dart';
import '../widgets/community_card_widget.dart';
import '../widgets/community_sheemer.dart';
import '../../../../l10n/app_localizations.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({
    super.key,
  });

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late CommunityMainCubit communityMainCubit;
  late TabController _tabController;

  int _currentIndex = 0;
  bool isLocationDenied = false;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    communityMainCubit = BlocProvider.of<CommunityMainCubit>(context);
    fetchLocationAndUpdate();
    _tabController.addListener(() {
      if (_tabController.index != _currentIndex &&
          !_tabController.indexIsChanging) {
        _currentIndex = _tabController.index;
        _onTabChanged(_currentIndex);
      }
    });
  }

  // LISTEN WHEN TAB IS CHANGE
  _onTabChanged(int tabIndex) {
    if (tabIndex == 0) {
      communityMainCubit.init();
    } else {
      BlocProvider.of<GetUserGroupsBloc>(context).add(
        GetUserGroupsButtonPressedEvent(),
      );
    }
  }

  // REFRESH NEARBY TAB
  Future<void> _onNearbyTabRefresh() async {
    communityMainCubit.init();
  }

  // REFRESH MY TAB
  Future<void> _onMyTabRefresh() async {
    BlocProvider.of<GetUserGroupsBloc>(context).add(
      GetUserGroupsButtonPressedEvent(),
    );
  }

  Future<void> fetchLocationAndUpdate() async {
    final hasPermission = await _handleLocationPermission();
    print('What is Location Permisssion: $hasPermission');
    if (!hasPermission) {
      bool isLocationOn = ShardPrefHelper.getIsCurrentLocationOn() ?? true;

      if (!isLocationOn) {
        print('Try to featch others citys post');
        _onNearbyTabRefresh();
      } else {
        setState(() {
          isLocationDenied = true;
        });
        if (mounted) {
          showSnackBar(
            context: context,
            message: AppLocalizations.of(context)!
                .location_permissions_are_permanently_denied_we_cannot_request_permissions,
          );
        }
      }
    } else {
      bool isLocationOn = ShardPrefHelper.getIsCurrentLocationOn() ?? true;
      print('Is location on:$isLocationOn');
      if (isLocationOn) {
        try {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          var city = placemarks[0].locality ?? '';
          await ShardPrefHelper.setLat(position.latitude);
          await ShardPrefHelper.setLng(position.longitude);
          await ShardPrefHelper.setCity(city);
          await ShardPrefHelper.setIsCurrentLocationOn(true);

          _onNearbyTabRefresh();
        } catch (e) {
          bool isLocationOn = ShardPrefHelper.getIsCurrentLocationOn() ?? true;
          print('Is Location On : $isLocationOn');

          if (!isLocationOn) {
            print('Try to featch post with other city');
            _onNearbyTabRefresh();
          } else {
            setState(() {
              isLocationDenied = true;
            });
            if (mounted) {
              showSnackBar(
                context: context,
                message: e.toString(),
              );
            }
          }
        }
      } else {
        _onNearbyTabRefresh();
      }
    }
  }

  // ASK LOCATION PERMISSION
  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;
    var checkPushPermission = await Permission.notification.isDenied;
    if (checkPushPermission) {
      await Permission.notification.request();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      // DENIED
      if (permission == LocationPermission.denied) {
        if (mounted) {
          showSnackBar(
            context: context,
            message:
                AppLocalizations.of(context)!.location_permissions_are_denied,
          );
        }
        return false;
      }
    }

    // FOREVER DENIED
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        showSnackBar(
          context: context,
          message: AppLocalizations.of(context)!
              .location_permissions_are_permanently_denied_we_cannot_request_permissions,
        );
      }
      return false;
    }

    // GRANTED
    return true;
  }

  // DISPOSE
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

// BUILD
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        print('back button press');
        context.go('/home');
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              // APP LOGO
              SvgPicture.asset(
                'assets/logo.svg',
                width: 24,
                height: 24,
              ),
            ],
          ),
          actions: [
            // CHAT BUTTON
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () {
                  context.push('/chat');
                },
                child: CircularSvgImage(
                  assetPath: AppImages.chatIcon,
                ),
              ),
            ),
          ],
        ),
        // BODY AREA
        body: Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
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
                    color: Colors.grey,
                  ),
                  tabAlignment: TabAlignment.center,
                  tabs: [
                    Tab(
                      child: tabTitle(
                        AppLocalizations.of(context)!.nearby_Groups,
                      ),
                    ),
                    Tab(
                      child: tabTitle(
                        AppLocalizations.of(context)!.my_Groups,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // NEARBY GROUPS TAB
                  RefreshIndicator(
                    onRefresh: _onNearbyTabRefresh,
                    child: BlocConsumer<CommunityMainCubit, CommunityMainState>(
                      listener: (context, state) {
                        // FAILURE STATE
                        if (state.status == Status.failure) {
                          if (mounted) {
                            showSnackBar(
                              context: context,
                              message: state.failure?.message ??
                                  'oops something went wrong',
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        // LOADING STATE
                        if (state.status == Status.loading) {
                          return const CommunityMainSheemer();
                        }

                        // FAILURE STATE
                        if (state.status == Status.failure) {
                          return SomethingWentWrong(
                            imagePath: 'assets/something_went_wrong.svg',
                            title: "oops something went wrong",
                            message: "We could not featch nearby groups.",
                            buttonText: AppLocalizations.of(context)!.retry,
                            onButtonPressed: () {
                              communityMainCubit.init();
                            },
                          );
                        }

                        // SUCCESS STATE
                        if (state.status == Status.success) {
                          // COMMUNITY IS NOT EMPTY
                          if (state.communities.isNotEmpty) {
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                int crossAxisCount = 2;
                                if (constraints.maxWidth >= 600) {
                                  crossAxisCount = 3;
                                } else if (constraints.maxWidth >= 900) {
                                  crossAxisCount = 4;
                                }
                                return Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                    color: AppColors.whiteColor,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 5),
                                        Expanded(
                                          child: GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: crossAxisCount,
                                              crossAxisSpacing: 10.0,
                                              mainAxisSpacing: 10.0,
                                              childAspectRatio: 1 / 1.5,
                                            ),
                                            itemCount: state.communities.length,
                                            itemBuilder: (context, index) {
                                              return CommunityCardWidget(
                                                community:
                                                    state.communities[index],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          // NO COMMUNITY
                          if (state.communities.isEmpty) {
                            return SomethingWentWrong(
                              imagePath: AppImages.emptyCommunity,
                              title: 'No Community Yet',
                              message:
                                  'Be the first to create a group and start connecting!',
                              buttonText: 'Start a Community',
                              onButtonPressed: () {
                                context.push('/group-create');
                              },
                            );
                          }
                        }

                        return SizedBox.shrink();
                      },
                    ),
                  ),

                  // MY GROUPS TAB
                  RefreshIndicator(
                    onRefresh: _onMyTabRefresh,
                    child: BlocConsumer<GetUserGroupsBloc, GetUserGroupsState>(
                      listener: (context, state) {
                        // FAILURE STATE
                        if (state is GetUserGroupsFailureState) {
                          if (context.mounted) {
                            showSnackBar(
                              context: context,
                              message: state.error,
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        // LOADING STATE
                        if (state is GetUserGroupsLoadingState) {
                          return const CommunityMainSheemer();
                        }
                        // SUCCESS STATE
                        if (state is GetUserGroupsSuccessState) {
                          // COMMUNITY IS NOT EMPTY
                          if (state.communities.isNotEmpty) {
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                int crossAxisCount = 2;
                                if (constraints.maxWidth >= 600) {
                                  crossAxisCount = 3;
                                } else if (constraints.maxWidth >= 900) {
                                  crossAxisCount = 4;
                                }
                                return Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                    color: AppColors.whiteColor,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 5),
                                        Expanded(
                                          child: GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: crossAxisCount,
                                              crossAxisSpacing: 10.0,
                                              mainAxisSpacing: 10.0,
                                              childAspectRatio: 1 / 1.5,
                                            ),
                                            itemCount: state.communities.length,
                                            itemBuilder: (context, index) {
                                              return CommunityCardWidget(
                                                community:
                                                    state.communities[index],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          // COMMUNITY IS EMPTY
                          if (state.communities.isEmpty) {
                            return SomethingWentWrong(
                              imagePath: AppImages.emptyCommunity,
                              title: 'No Community Groups Yet',
                              message:
                                  'Be the first to create a group and start connecting!',
                              buttonText: 'Start a Community',
                              onButtonPressed: () {
                                context.push('/group-create');
                              },
                            );
                          }
                        }

                        return SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB BAR WIDGET
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
}

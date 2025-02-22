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
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/home_dropdown_city.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_event.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_state.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/widgets/somthing_went_wrong.dart';
import '../bloc/communities_main_cubit.dart';
import '../widgets/community_card_widget.dart';
import '../widgets/community_sheemer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  // late String _selectedCity;
  int _currentIndex = 0;
  // bool isHome = true;
  bool isLocationDenied = false;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    communityMainCubit = BlocProvider.of<CommunityMainCubit>(context);
    fetchLocationAndUpdate();
    // _onNearbyTabRefresh();
    _tabController.addListener(() {
      if (_tabController.index != _currentIndex &&
          !_tabController.indexIsChanging) {
        _currentIndex = _tabController.index;
        _onTabChanged(_currentIndex);
      }
    });
  }

  // REFRESH NEARBY TAB
  Future<void> _onNearbyTabRefresh() async {
    // setIsHome();
    fetchLocationAndUpdate();
    // setCityHomeName();
    // setCityCurrentName();
    // _selectedCity = ShardPrefHelper.getHomeCity() ?? 'New Delhi';
    // if (_selectedCity.toLowerCase() == 'delhi') {
    //   _selectedCity = 'New Delhi';
    // }

    communityMainCubit.init();
    BlocProvider.of<GetUserGroupsBloc>(context).add(
      GetUserGroupsButtonPressedEvent(),
    );
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

  // CHECK IF USER IS USING  CURRENT LOCATION
  // isHome IS TRUE WHEN HE IS NOT USING THEIR CURRENT LOCATION
  // setIsHome() {
  //   var isLocationOn = ShardPrefHelper.getIsLocationOn();
  //   setState(() {
  //     isHome = isLocationOn ? false : true;
  //   });
  // }

  // FEATCH THE CURRENT LOCATION AND UPDATE IT.
  // Future<void> fetchLocationAndUpdate() async {
  //   final hasPermission = await _handleLocationPermission();
  //   if (!hasPermission) return;

  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     ShardPrefHelper.setLocation(
  //       [
  //         position.latitude,
  //         position.longitude,
  //       ],
  //     );
  //   } catch (e) {
  //     if (mounted) {
  //       showSnackBar(context: context, message: e.toString());
  //     }
  //   }
  // }
  Future<void> fetchLocationAndUpdate() async {
    final hasPermission = await _handleLocationPermission();
    print('what is permisssion: $hasPermission');
    if (!hasPermission) {
      bool isLocationOn = ShardPrefHelper.getCurrent() ?? true;

      setState(() {
        isLocationDenied = true;
      });
      if (!isLocationOn) {
        print('try to featch post with other city');
        communityMainCubit.init();
        BlocProvider.of<GetUserGroupsBloc>(context).add(
          GetUserGroupsButtonPressedEvent(),
        );
        // _fetchPosts();
      }
    } else {
      bool isLocationOn = ShardPrefHelper.getCurrent() ?? true;
      print('what is location on:$isLocationOn');
      if (isLocationOn) {
        try {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          await ShardPrefHelper.setLat(position.latitude);
          await ShardPrefHelper.setLng(position.longitude);
          await ShardPrefHelper.setCurrent(true);
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          var city = placemarks[0].locality ?? '';
          await ShardPrefHelper.setCity(city);
          communityMainCubit.init();
          BlocProvider.of<GetUserGroupsBloc>(context).add(
            GetUserGroupsButtonPressedEvent(),
          );
        } catch (e) {
          bool isLocationOn = ShardPrefHelper.getCurrent() ?? true;
          print('isLocationOn : $isLocationOn');
          setState(() {
            isLocationDenied = true;
          });
          if (!isLocationOn) {
            print('try to featch post with other city');
            communityMainCubit.init();
            BlocProvider.of<GetUserGroupsBloc>(context).add(
              GetUserGroupsButtonPressedEvent(),
            );
          } else {
            if (mounted) {
              showSnackBar(
                context: context,
                message: e.toString(),
              );
            }
          }
        }
      }
      communityMainCubit.init();
      BlocProvider.of<GetUserGroupsBloc>(context).add(
        GetUserGroupsButtonPressedEvent(),
      );
    }
  }

  //CHECK LOCATION PERMISSION IS ON
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

  // SET HOME CITY NAME
  // setCityHomeName() async {
  //   List<double> homeLocation = ShardPrefHelper.getHomeLocation();
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //     homeLocation[0],
  //     homeLocation[1],
  //   );
  //   var city = placemarks[0].locality ?? 'New Delhi';
  //   if (city.toLowerCase() == 'delhi') {
  //     city = 'New Delhi';
  //   }
  //   ShardPrefHelper.setHomeCity(city);
  // }

  // SET CURRENT LOCATION CITY NAME
  // setCityCurrentName() async {
  //   List<double> location = ShardPrefHelper.getLocation();
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //     location[0],
  //     location[1],
  //   );
  //   var city = placemarks[0].locality ?? 'New Delhi';
  //   ShardPrefHelper.setCurrentCity(city);
  // }

  // DISPOSE
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // HANDLE THE LOCATION TOGGLE BUTTON
  // void handleToggle(bool value) async {
  //   if (mounted) {
  //     setState(() {
  //       isHome = value;
  //     });
  //   }
  //   if (!isHome) {
  //     fetchLocationAndUpdate();
  //     setCityHomeName();
  //     setCityCurrentName();
  //   }
  //   _selectedCity = ShardPrefHelper.getHomeCity() ?? 'New Delhi';
  //   if (_selectedCity.toLowerCase() == 'delhi') {
  //     _selectedCity = 'New Delhi';
  //   }
  //   setState(() {});
  //   communityMainCubit.init();
  // }

// BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // APP LOGO
            SvgPicture.asset(
              'assets/logo.svg',
              width: 30,
              height: 34,
            ),
            const SizedBox(width: 10),

            // LOCATION BUTTON
            // Flexible(
            //   child: Container(
            //     height: 40,
            //     width: 160,
            //     decoration: BoxDecoration(
            //       color: AppColors.inActivePrimaryColor,
            //       borderRadius: BorderRadius.circular(100),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(
            //           Icons.location_on,
            //           size: 16,
            //           color: isHome
            //               ? AppColors.primaryColor
            //               : AppColors.blackColor,
            //         ),

            //         // HOME BUTTON
            //         InkWell(
            //           onTap: () {
            //             ShardPrefHelper.setIsLocationOn(false);
            //             handleToggle(true);
            //           },
            //           child: SizedBox(
            //             height: 35,
            //             width: 60,
            //             child: Center(
            //               child: Text(
            //                 _selectedCity,
            //                 style: TextStyle(
            //                   fontWeight:
            //                       isHome ? FontWeight.w900 : FontWeight.normal,
            //                   fontSize: 16,
            //                   color: isHome
            //                       ? AppColors.primaryColor
            //                       : AppColors.blackColor,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),

            //         SizedBox(
            //           width: 5,
            //         ),

            //         // CITY DROPDOWN
            //         BlocListener<CityBloc, CityState>(
            //           listener: (context, state) {
            //             // SUCCESS STATE
            //             if (state is CityUpdatedState) {
            //               ShardPrefHelper.setIsLocationOn(false);
            //               handleToggle(true);
            //             }

            //             // FAILURE STATE
            //             else if (state is CityErrorState) {
            //               if (mounted) {
            //                 showSnackBar(
            //                   context: context,
            //                   message: state.errorMessage,
            //                 );
            //               }
            //             }
            //           },
            //           child: HomeDropdownCity(
            //             selectCity: _selectedCity,
            //             onChanged: (String? newValue) {
            //               if (newValue != null) {
            //                 context
            //                     .read<CityBloc>()
            //                     .add(UpdateCityEvent(newValue));
            //               }
            //             },
            //           ),
            //         ),

            //         Container(
            //           height: 25,
            //           width: 1,
            //           color: AppColors.blackColor,
            //         ),
            //         SizedBox(
            //           width: 5,
            //         ),

            //         // CURRENT LOCATION BUTTON
            //         InkWell(
            //           onTap: () {
            //             ShardPrefHelper.setIsLocationOn(true);
            //             handleToggle(false);
            //           },
            //           child: Container(
            //             height: 35,
            //             width: 35,
            //             decoration: BoxDecoration(
            //               shape: BoxShape.circle,
            //               color: isHome
            //                   ? AppColors.inActivePrimaryColor
            //                   : AppColors.primaryColor,
            //             ),
            //             child: Center(
            //               child: SvgPicture.asset(
            //                 'assets/location.svg',
            //                 height: 25,
            //                 width: 25,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
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
              child: SvgPicture.asset(
                'assets/chat.svg',
                fit: BoxFit.contain,
                width: 24,
                height: 24,
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
                  onRefresh: _onNearbyTabRefresh,
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

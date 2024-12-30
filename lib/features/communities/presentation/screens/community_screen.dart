import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/get_user_groups_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/home_dropdown_city.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_event.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_state.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/status.dart';
import '../bloc/communities_main_cubit.dart';
import '../widgets/community_card_widget.dart';
import '../widgets/community_sheemer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late CommunityMainCubit communityMainCubit;
  bool isHome = true;
  late String _selectedCity;
  late TabController _tabController;
  int _currentIndex = 0;

  ///init state method
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Listen for tab changes
    _tabController.addListener(() {
      // Trigger the API call when the tab changes
      if (_tabController.index != _currentIndex &&
          !_tabController.indexIsChanging) {
        _currentIndex = _tabController.index;
        _onTabChanged(_currentIndex);
      }
    });
    setIsHome();
    fetchLocationAndUpdate();
    setCityHomeName();
    setCityCurrentName();
    _selectedCity = ShardPrefHelper.getHomeCity() ?? 'New Delhi';
    if (_selectedCity.toLowerCase() == 'delhi') {
      _selectedCity = 'New Delhi';
    }
    communityMainCubit = BlocProvider.of<CommunityMainCubit>(context);
    communityMainCubit.init();
  }

  _onTabChanged(int tabIndex) {
    if (tabIndex == 0) {
      communityMainCubit.init();
    } else {
      BlocProvider.of<GetUserGroupsBloc>(context)
          .add(GetUserGroupsButtonPressedEvent());
    }
  }

  ///dispose method
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// set the location of  user whether their home location is on or current location in
  setIsHome() {
    var isLocationOn = ShardPrefHelper.getIsLocationOn();
    setState(() {
      isHome = isLocationOn ? false : true;
    });
  }

  /// fetch the user location and upldate it.
  Future<void> fetchLocationAndUpdate() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      ShardPrefHelper.setLocation(
        [position.latitude, position.longitude],
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  /// location permission checker
  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;
    var checkPushPermission = await Permission.notification.isDenied;
    if (checkPushPermission) {
      await Permission.notification.request();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      /// if location is denied
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.location_permissions_are_denied,
              ),
            ),
          );
        }
        return false;
      }
    }

    /// if location is forever denied
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!
                  .location_permissions_are_permanently_denied_we_cannot_request_permissions,
            ),
          ),
        );
      }
      return false;
    }

    /// if location is granted
    return true;
  }

  /// set home location city name
  setCityHomeName() async {
    List<double> homeLocation = ShardPrefHelper.getHomeLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      homeLocation[0],
      homeLocation[1],
    );
    var city = placemarks[0].locality ?? 'New Delhi';
    if (city.toLowerCase() == 'delhi') {
      city = 'New Delhi';
    }
    ShardPrefHelper.setHomeCity(city);
  }

  /// set current location city name
  setCityCurrentName() async {
    List<double> location = ShardPrefHelper.getLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location[0],
      location[1],
    );
    var city = placemarks[0].locality ?? 'New Delhi';
    ShardPrefHelper.setCurrentCity(city);
  }

  /// refersh the home screen
  Future<void> _onRefresh() async {
    setIsHome();
    fetchLocationAndUpdate();
    setCityHomeName();
    setCityCurrentName();
    _selectedCity = ShardPrefHelper.getHomeCity() ?? 'New Delhi';
    if (_selectedCity.toLowerCase() == 'delhi') {
      _selectedCity = 'New Delhi';
    }
    setState(() {});
    communityMainCubit.init();
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

  /// handle location toggle
  void handleToggle(bool value) async {
    if (mounted) {
      setState(() {
        isHome = value;
      });
    }
    if (!isHome) {
      fetchLocationAndUpdate();
      setCityHomeName();
      setCityCurrentName();
    }
    _selectedCity = ShardPrefHelper.getHomeCity() ?? 'New Delhi';
    if (_selectedCity.toLowerCase() == 'delhi') {
      _selectedCity = 'New Delhi';
    }
    setState(() {});
    communityMainCubit.init();
  }

  /// Refresh based on the current tab
  Future<void> _onRefres() async {
    BlocProvider.of<GetUserGroupsBloc>(context)
        .add(GetUserGroupsButtonPressedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          title: Row(
            children: [
              ///app logo
              SvgPicture.asset(
                'assets/logo.svg',
                width: 30,
                height: 34,
              ),
              const SizedBox(width: 10),

              ///toggle button
              Flexible(
                child: Container(
                  height: 40,
                  width: 160,
                  decoration: BoxDecoration(
                    color: AppColors.inActivePrimaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: isHome
                            ? AppColors.primaryColor
                            : AppColors.blackColor,
                      ),

                      /// Home Button
                      InkWell(
                        onTap: () {
                          ShardPrefHelper.setIsLocationOn(false);
                          handleToggle(true);
                        },
                        child: SizedBox(
                          height: 35,
                          width: 60,
                          child: Center(
                            child: Text(
                              _selectedCity,
                              style: TextStyle(
                                fontWeight: isHome
                                    ? FontWeight.w900
                                    : FontWeight.normal,
                                fontSize: 16,
                                color: isHome
                                    ? AppColors.primaryColor
                                    : AppColors.blackColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),

                      /// Dropdown for city selection
                      BlocListener<CityBloc, CityState>(
                        listener: (context, state) {
                          ///success state
                          if (state is CityUpdatedState) {
                            ShardPrefHelper.setIsLocationOn(false);
                            handleToggle(true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${AppLocalizations.of(context)!.city_updated_to} ${state.city}!'),
                              ),
                            );
                          }

                          /// failure state
                          else if (state is CityErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                 
                                  '${AppLocalizations.of(context)!.error}: ${state.errorMessage}',
                                 // 'Error: ${state.errorMessage}'
                                  ),
                              ),
                            );
                          }
                        },
                        child: HomeDropdownCity(
                          selectCity: _selectedCity,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              context
                                  .read<CityBloc>()
                                  .add(UpdateCityEvent(newValue));
                            }
                          },
                        ),
                      ),

                      /// Vertical Divider
                      Container(
                        height: 25,
                        width: 1,
                        color: AppColors.blackColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),

                      /// Location Button
                      InkWell(
                        onTap: () {
                          ShardPrefHelper.setIsLocationOn(true);
                          handleToggle(false);
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isHome
                                ? AppColors.inActivePrimaryColor
                                : AppColors.primaryColor,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/location.svg',
                              height: 25,
                              width: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ///search icon
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () {
                  // context.push('/groups/search');
                },
                child: SvgPicture.asset(
                  'assets/search.svg',
                  fit: BoxFit.contain,
                  width: 30,
                  height: 30,
                ),
              ),
            ),

            ///chat icon
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () {
                  // context.push('/chat');
                },
                child: SvgPicture.asset(
                  'assets/chat.svg',
                  fit: BoxFit.contain,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
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
                      child: tabTitle(
                        AppLocalizations.of(context)!.nearby_Groups,
                      //  'Nearby Groups'
                        ),
                    ),
                    Tab(
                      child: tabTitle(
                        AppLocalizations.of(context)!.my_Groups,
                      //  'My Groups'
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
                  /// get near by groups tab
                  RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: BlocConsumer<CommunityMainCubit, CommunityMainState>(
                      bloc: communityMainCubit,
                      listener: (context, state) {
                        if (state.status == Status.loading) {}
                        if (state.status == Status.success) {}
                        if (state.status == Status.failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${state.errorMessage}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        ///loading state
                        if (state.status == Status.loading) {
                          return const CommunityMainSheemer();
                        }

                        ///failure state
                        if (state.status == Status.failure) {
                          return Center(
                            child: Text(
                                state.errorMessage ?? AppLocalizations.of(context)!.something_went_wrong),
                          );
                        }
                        if (state.status == Status.success) {
                          /// if community is not empty
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

                          /// if community is empty
                          if (state.communities.isEmpty) {
                            return Center(
                              child: Text(
                                AppLocalizations.of(context)!.no_Community_found,
                              //  'No Community found'
                                ),
                            );
                          }
                        }

                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!.something_went_wrong,
                          //  'Something went wrong'
                            ),
                        );
                      },
                    ),
                  ),

                  /// get my groups tab
                  RefreshIndicator(
                    onRefresh: _onRefres,
                    child: BlocConsumer<GetUserGroupsBloc, GetUserGroupsState>(
                      listener: (context, state) {
                        ///failure state
                        if (state is GetUserGroupsFailureState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state.error.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        ///loading state
                        if (state is GetUserGroupsLoadingState) {
                          return const CommunityMainSheemer();
                        }

                        if (state is GetUserGroupsSuccessState) {
                          /// if community is not empty
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

                          /// if community is empty
                          if (state.communities.isEmpty) {
                            return Center(
                              child: Text(
                                AppLocalizations.of(context)!.no_Community_found,
                               // 'No Community found'
                                ),
                            );
                          }
                        }

                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!.something_went_wrong,
                           // 'Something went wrong'
                            ),
                        );
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
}

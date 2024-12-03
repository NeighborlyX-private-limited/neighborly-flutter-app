import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/widgets/award_buy_bottom_sheet.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_drawer.dart';
import 'package:neighborly_flutter_app/core/widgets/somthing_went_wrong.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/home_dropdown_city.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_event.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_state.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../authentication/presentation/widgets/button_widget.dart';
import '../../../profile/presentation/bloc/get_gender_and_DOB_bloc/get_gender_and_DOB_bloc.dart';
import '../bloc/get_all_posts_bloc/get_all_posts_bloc.dart';
import '../widgets/poll_widget.dart';
import '../widgets/post_sheemer_widget.dart';
import '../widgets/post_widget.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../notification/data/data_sources/notification_remote_data_source/notification_remote_data_source_impl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final String tabIndex;
  const HomeScreen({super.key, required this.tabIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isHome = true;
  bool isDobSet = true;
  late String _selectedCity;
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  bool isDobBtnActive = false;

  /// Generate lists for day, month, and year
  List<String> days =
      List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));
  List<String> months =
      List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  List<String> years = List.generate(
    DateTime.now().year - 16 - 1900 + 1,
    (index) => (DateTime.now().year - 16 - index).toString(),
  );

  /// init method
  @override
  void initState() {
    super.initState();
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }

    setIsHome();
    fetchLocationAndUpdate();
    setCityHomeName();
    setCityCurrentName();
    getUnreadNotificationCount();
    isDobSet = ShardPrefHelper.getDob();
    _selectedCity = ShardPrefHelper.getHomeCity() ?? 'New Delhi';
    if (_selectedCity.toLowerCase() == 'delhi') {
      _selectedCity = 'New Delhi';
    }
    _fetchPosts();

    if (!isDobSet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openBottomSheet();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
  }

  ///dispose method
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// on notification method
  void onNotificationRead() {
    getUnreadNotificationCount();
  }

  /// fetch post method
  void _fetchPosts() {
    _selectedCity = ShardPrefHelper.getHomeCity() ?? 'New Delhi';
    if (_selectedCity.toLowerCase() == 'delhi') {
      _selectedCity = 'New Delhi';
    }
    setState(() {});
    BlocProvider.of<GetAllPostsBloc>(context)
        .add(GetAllPostsButtonPressedEvent(isHome: isHome));
  }

  /// set the location of  user whether their home location is on or current location in
  setIsHome() {
    var isLocationOn = ShardPrefHelper.getIsLocationOn();
    setState(() {
      isHome = isLocationOn ? false : true;
    });
  }

  /// refersh the home screen
  Future<void> _onRefresh() async {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
    setIsHome();
    getUnreadNotificationCount();
    BlocProvider.of<GetAllPostsBloc>(context)
        .add(GetAllPostsButtonPressedEvent(isHome: isHome));
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

  void handleToggle(bool value) async {
    if (mounted) {
      setState(() {
        isHome = value;
      });
    }
    if (!isHome) {
      fetchLocationAndUpdate();
    }
    _fetchPosts();
  }

  String formatDOB(String day, String month, String year) {
    year = year.length == 2 ? '20$year' : year;
    year = int.parse(year) > 2021 ? '2021' : year;
    month = month.length == 1 ? '0$month' : month;
    month = int.parse(month) > 12 ? '12' : month;
    day = int.parse(day) > 31 ? '31' : day;
    day = day.length == 1 ? '0$day' : day;
    return '$year-$month-$day';
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
              content: Text(AppLocalizations.of(context)!
                  .location_permissions_are_denied),
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
            content: Text(AppLocalizations.of(context)!
                .location_permissions_are_permanently_denied_we_cannot_request_permissions),
          ),
        );
      }
      return false;
    }

    /// if location is granted
    return true;
  }

  /// fetch the user location and upldate it.
  Future<void> fetchLocationAndUpdate() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      ShardPrefHelper.setLocation([position.latitude, position.longitude]);
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

  ///fetch the unread notification count
  int unreadNotificationCount = 0;
  Future<void> getUnreadNotificationCount() async {
    getNotificationUnreadCount().then((value) {
      if (value >= 0) {
        if (mounted) {
          setState(() {
            unreadNotificationCount = value;
          });
        }
      }
    }).catchError((error) {
      if (mounted && (!error.contains('oops something went wrong'))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          _scaffoldKey.currentState?.closeEndDrawer();
        },
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: AppColors.lightBackgroundColor,
              appBar: AppBar(
                backgroundColor: AppColors.whiteColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/logo.svg',
                      width: 30,
                      height: 34,
                    ),
                    const SizedBox(width: 10),
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
                                  _fetchPosts();
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
                                      content:
                                          Text('Error: ${state.errorMessage}'),
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
                  /// buy awrad button
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        showDragHandle: true,
                        backgroundColor: AppColors.whiteColor,
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => const AwardSelectionScreen(),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/award.svg',
                      height: 24.0,
                      width: 24.0,
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),

                  /// notification icon button
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        context.push('/notifications');
                      },
                      child: unreadNotificationCount > 0
                          ? badges.Badge(
                              badgeContent: unreadNotificationCount > 0
                                  ? Text(
                                      "$unreadNotificationCount",
                                      style: TextStyle(
                                          color: AppColors.whiteColor),
                                    )
                                  : null,
                              badgeStyle: BadgeStyle(
                                  badgeColor: AppColors.primaryColor),
                              position:
                                  badges.BadgePosition.custom(end: 0, top: -8),
                              child: SvgPicture.asset(
                                'assets/alarm.svg',
                                fit: BoxFit.contain,
                                width: 26,
                                height: 26,
                              ),
                            )
                          : badges.Badge(
                              showBadge: false,
                              badgeStyle: BadgeStyle(
                                badgeColor: AppColors.primaryColor,
                              ),
                              position: badges.BadgePosition.custom(
                                end: 0,
                                top: -8,
                              ),
                              child: SvgPicture.asset(
                                'assets/alarm.svg',
                                fit: BoxFit.contain,
                                width: 26,
                                height: 26,
                              ),
                            ),
                    ),
                  ),

                  /// drawer menu icon
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: AppColors.greyColor,
                      size: 26,
                    ),
                    onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                  ),
                ],
              ),
              endDrawer: CustomDrawer(
                scaffoldKey: _scaffoldKey,
              ),
              body: BlocBuilder<GetAllPostsBloc, GetAllPostsState>(
                builder: (context, state) {
                  /// loading state
                  if (state is GetAllPostsLoadingState) {
                    return const PostSheemerWidget();
                  }

                  ///success state
                  else if (state is GetAllPostsSuccessState) {
                    final posts = state.post;
                    return posts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/nothing.svg',
                                  height: 200.0,
                                  width: 200.0,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(AppLocalizations.of(context)!
                                    .time_to_be_the_hero_this_wall_needs_start_the),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                  ),
                                  onPressed: () {
                                    context.push('/create');
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.create_a_post,
                                    style:
                                        TextStyle(color: AppColors.whiteColor),
                                  ),
                                )
                              ],
                            ),
                          )
                        : ListView.separated(
                            controller: _scrollController,
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              if (post.type == 'post') {
                                return PostWidget(
                                    post: post,
                                    onDelete: () {
                                      _onRefresh();
                                    });
                              } else if (post.type == 'poll') {
                                return PollWidget(
                                    post: post,
                                    onDelete: () {
                                      _onRefresh();
                                    });
                              }
                              return const SizedBox();
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                              );
                            },
                          );
                  }

                  /// failure state
                  else if (state is GetAllPostsFailureState) {
                    if (state.error.contains('Invalid Token')) {
                      context.go('/loginScreen');
                    }
                    if (state.error.contains('Internal server error')) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .oops_something_went_wrong,
                          style: TextStyle(color: AppColors.redColor),
                        ),
                      );
                    }
                    if (state.error.contains('No internet connection')) {
                      return SomethingWentWrong(
                        imagePath: 'assets/something_went_wrong.svg',
                        title: AppLocalizations.of(context)!
                            .aaah_something_went_wrong,
                        message: AppLocalizations.of(context)!
                            .we_could_not_fetch_your_data_please_try_starting_it_again,
                        buttonText: AppLocalizations.of(context)!.retry,
                        onButtonPressed: () {
                          _onRefresh();
                        },
                      );
                    }
                    if (state.error.contains('oops something went wrong')) {
                      return SomethingWentWrong(
                        imagePath: 'assets/something_went_wrong.svg',
                        title: AppLocalizations.of(context)!
                            .aaah_something_went_wrong,
                        message: AppLocalizations.of(context)!
                            .we_could_not_fetch_your_data_please_try_starting_it_again,
                        buttonText: AppLocalizations.of(context)!.retry,
                        onButtonPressed: () {
                          _onRefresh();
                        },
                      );
                    }

                    return Center(child: Text(state.error));
                  } else {
                    return Center(
                      child: Text(AppLocalizations.of(context)!.no_data),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// bottom sheet
  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void checkIfDobBtnShouldBeActive() {
              setModalState(() {
                isDobBtnActive = selectedDay != null &&
                    selectedMonth != null &&
                    selectedYear != null;
              });
            }

            return FractionallySizedBox(
              heightFactor: 0.5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .one_last_thing_before_we_get_started,
                        style: onboardingHeading2Style,
                      ),
                    ),
                    const Divider(
                      color: AppColors.greyColor,
                    ),
                    Text(AppLocalizations.of(context)!.date_of_birth,
                        style: blackonboardingBody1Style),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// Day Dropdown
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedDay,
                            hint: Text(AppLocalizations.of(context)!.day),
                            items: days.map((day) {
                              return DropdownMenuItem(
                                value: day,
                                child: Text(day),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedDay = value;
                              });
                              checkIfDobBtnShouldBeActive();
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            dropdownColor: AppColors.whiteColor,
                            icon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        SizedBox(width: 8),

                        /// Month Dropdown
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedMonth,
                            hint: Text(AppLocalizations.of(context)!.month),
                            items: months.map((month) {
                              return DropdownMenuItem(
                                value: month,
                                child: Text(month),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedMonth = value;
                              });
                              checkIfDobBtnShouldBeActive();
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            dropdownColor: AppColors.whiteColor,
                            icon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        SizedBox(width: 8),

                        /// Year Dropdown
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedYear,
                            hint: Text(AppLocalizations.of(context)!.year),
                            items: years.map((year) {
                              return DropdownMenuItem(
                                value: year,
                                child: Text(year),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedYear = value;
                              });
                              checkIfDobBtnShouldBeActive();
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            dropdownColor: AppColors.whiteColor,
                            icon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    BlocConsumer<GetGenderAndDOBBloc, GetGenderAndDOBState>(
                      listener:
                          (BuildContext context, GetGenderAndDOBState state) {
                        ///failure state
                        if (state is GetGenderAndDOBFailureState) {
                          context.pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error
                                      .contains('DOB can only be set once.')
                                  ? AppLocalizations.of(context)!
                                      .date_of_birth_saved_successfully
                                  : state.error),
                            ),
                          );
                        }

                        ///success state
                        else if (state is GetGenderAndDOBSuccessState) {
                          context.pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .date_of_birth_saved_successfully),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        ///loading state
                        if (state is GetGenderAndDOBLoadingState) {
                          return Center(
                            child: BouncingLogoIndicator(
                              logo: 'images/logo.svg',
                            ),
                          );
                        }

                        ///save dob button
                        return ButtonContainerWidget(
                          text: AppLocalizations.of(context)!.save,
                          color: AppColors.primaryColor,
                          isActive: isDobBtnActive,
                          isFilled: true,
                          onTapListener: () {
                            BlocProvider.of<GetGenderAndDOBBloc>(context).add(
                              GetGenderAndDOBButtonPressedEvent(
                                dob:
                                    '$selectedYear-$selectedMonth-$selectedDay',
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}

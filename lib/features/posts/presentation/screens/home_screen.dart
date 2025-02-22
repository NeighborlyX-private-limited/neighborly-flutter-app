import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_drawer.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/somthing_went_wrong.dart';
import 'package:neighborly_flutter_app/features/homePage/home_page.dart';
import 'package:neighborly_flutter_app/features/notification/presentation/bloc/notification_general_cubit.dart';
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
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int unreadNotificationCount = 0;

  bool isDobSet = true;
  bool isDobBtnActive = false;
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  bool isLocationDenied = false;
  String? _deepLink;
  static const platform = MethodChannel('com.neighborlyx.neighborlysocial');

  // INIT STATE
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
    });
    fetchLocationAndUpdate();
    updateFCMtokenNotification();
    getUnreadNotificationCount();
    _setDeepLinkListener();
    // setIsHome();

    isDobSet = ShardPrefHelper.getDob();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isDobSet) {
        _openBottomSheet();
      }
    });
  }

  // DISPOSE
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // GENERATE LISTS OF DAYS, MONTHS AND YEARS
  List<String> days =
      List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));
  List<String> months =
      List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  List<String> years = List.generate(
    DateTime.now().year - 16 - 1900 + 1,
    (index) => (DateTime.now().year - 16 - index).toString(),
  );

// UPDATE FCM TOKEN
  Future<void> updateFCMtokenNotification() async {
    try {
      var result = await BlocProvider.of<NotificationGeneralCubit>(context)
          .updateFCMTokenUsecase();
      result.fold(
        (failure) {
          showSnackBar(context: context, message: failure.message);
        },
        (currentFCMtoken) {
          ShardPrefHelper.setFCMtoken(currentFCMtoken);
        },
      );
    } catch (e) {
      if (mounted) {
        showSnackBar(context: context, message: e.toString());
      }
    }
  }

  // FEATCH UNREAD NOTIFICATION COUNT
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
      if (mounted) {
        showSnackBar(
          context: context,
          message: error.toString(),
        );
      }
    });
  }

// DEEP LINK LISTENER FOR UPCOMING DEEP LINK
  Future<void> _setDeepLinkListener() async {
    platform.setMethodCallHandler(
      (MethodCall call) async {
        if (call.method == "onDeepLink") {
          setState(
            () {
              _deepLink = call.arguments;
              List? linksplit = _deepLink?.split('neighborly.in');
              if (linksplit != null && linksplit.length > 1) {
                // GO TO POST DETAIL SCREEN
                if (linksplit[1].contains('post-detail/')) {
                  try {
                    context.push(linksplit[1]);
                  } catch (e) {
                    showSnackBar(context: context, message: e.toString());
                  }
                }
                // GO TO GROUP DETAIL SCREEN
                else if (linksplit[1].contains('group-details/')) {
                  try {
                    context.push(linksplit[1]);
                  } catch (e) {
                    showSnackBar(context: context, message: e.toString());
                  }
                }
                // GO TO USER PROFILE SCREEN
                else if (linksplit[1].contains('userProfileScreen/')) {
                  try {
                    context.push(linksplit[1]);
                  } catch (e) {
                    showSnackBar(context: context, message: e.toString());
                  }
                }
              } else {
                showSnackBar(
                  context: context,
                  message: 'oops something went wrong.',
                );
              }
            },
          );
        }
      },
    );
  }

  // ASK LOCATION PERMISSION
  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;
    var checkPushPermission = await Permission.notification.isDenied;
    print('check this checkPushPermission: $checkPushPermission');
    if (checkPushPermission) {
      print('check this checkPushPermission: $checkPushPermission');
      await Permission.notification.request();
    }

    permission = await Geolocator.checkPermission();
    print('check this permission: $permission');
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      // LOCATION PERMISSION DENIED
      if (permission == LocationPermission.denied) {
        if (mounted) {
          showSnackBar(
            context: context,
            message:
                AppLocalizations.of(context)!.location_permissions_are_denied,
          );
        }
        print('i am returning false');
        return false;
      }
    }

    // LOCATION PERMISSION PERMANANT DENIED
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        showSnackBar(
          context: context,
          message: AppLocalizations.of(context)!
              .location_permissions_are_permanently_denied_we_cannot_request_permissions,
        );
      }
      print('i am returning false');
      return false;
    }

    // LOCATION PERMISSION GRANTED
    print('i am returning true');
    return true;
  }

  // FEATCH USER'S CURRENT LOCATION AND UPDATE.
  Future<void> fetchLocationAndUpdate() async {
    final hasPermission = await _handleLocationPermission();
    print('What is permisssion: $hasPermission');
    if (!hasPermission) {
      bool isLocationOn = ShardPrefHelper.getIsCurrentLocationOn() ?? true;

      setState(() {
        isLocationDenied = true;
      });
      if (!isLocationOn) {
        print('Try to featch others citys post');
        _fetchPosts();
      }
    } else {
      bool isLocationOn = ShardPrefHelper.getIsCurrentLocationOn() ?? true;
      print('What is location on:$isLocationOn');
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
          await ShardPrefHelper.setIsCurrentLocationOn(true);
          await ShardPrefHelper.setCity(city);

          _fetchPosts();
        } catch (e) {
          bool isLocationOn = ShardPrefHelper.getIsCurrentLocationOn() ?? true;
          print('isLocationOn : $isLocationOn');
          setState(() {
            isLocationDenied = true;
          });
          if (!isLocationOn) {
            print('Try to featch post with other city');
            _fetchPosts();
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
      _fetchPosts();
    }
  }

  // FEATCH ALL POST
  void _fetchPosts() {
    BlocProvider.of<GetAllPostsBloc>(context).add(
      GetAllPostsButtonPressedEvent(isHome: true),
    );
  }

  // REFRESH
  Future<void> _onRefresh() async {
    getUnreadNotificationCount();
    BlocProvider.of<GetAllPostsBloc>(context).add(
      GetAllPostsButtonPressedEvent(isHome: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      context.push('/googleMapScreen');
                    },
                    icon: Icon(Icons.location_on_outlined),
                  ),
                  // NOTIFICATION ICON
                  // NEED TO ADD BLOC BUILDER HERE FOR NOTIFICATION COUNT
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
                                        color: AppColors.whiteColor,
                                      ),
                                    )
                                  : null,
                              badgeStyle: BadgeStyle(
                                badgeColor: AppColors.primaryColor,
                              ),
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

                  // DRAWER ICON
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: AppColors.greyColor,
                      size: 26,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                  ),
                ],
              ),
              onEndDrawerChanged: (isOpened) {
                if (!isOpened) {
                  isBottomNavVisible.value = true;
                } else {
                  isBottomNavVisible.value = false;
                }
              },
              endDrawer: CustomDrawer(
                scaffoldKey: _scaffoldKey,
              ),
              body: BlocBuilder<GetAllPostsBloc, GetAllPostsState>(
                builder: (context, state) {
                  // LOADING STATE
                  if (state is GetAllPostsLoadingState) {
                    return const PostSheemerWidget();
                  }

                  // SUCCESS STATE
                  else if (state is GetAllPostsSuccessState) {
                    final posts = state.post;
                    return posts.isEmpty
                        // 0 POST
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
                                Text(
                                  AppLocalizations.of(context)!
                                      .time_to_be_the_hero_this_wall_needs_start_the,
                                  textAlign: TextAlign.center,
                                ),
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
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        // HAVE SOME POST
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
                            separatorBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                              );
                            },
                          );
                  }

                  // FAILURE STATE
                  else if (state is GetAllPostsFailureState) {
                    if (state.error.contains('Invalid Token')) {
                      context.go('/loginScreen');
                    }
                    if (state.error.contains('Internal server error')) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .oops_something_went_wrong,
                          style: TextStyle(
                            color: AppColors.greyColor,
                          ),
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

                    return Center(child: Text('oops something went wrong'));
                  } else {
                    bool isLocationOn =
                        ShardPrefHelper.getIsCurrentLocationOn() ?? true;
                    if (isLocationDenied && isLocationOn) {
                      return SizedBox(
                        child: Center(
                          child: Text(
                            'Please on your location from mobile.',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.greyColor,
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      child: Center(
                        child: Text(
                          'Location off but no data.',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.greenColor,
                          ),
                        ),
                      ),
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

  // DOB BOTTOM SHEET
  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
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
                    Text(
                      AppLocalizations.of(context)!
                          .one_last_thing_before_we_get_started,
                      style: blackonboardingBody2Style,
                    ),
                    const Divider(
                      color: AppColors.greyColor,
                    ),
                    Text(
                      AppLocalizations.of(context)!.date_of_birth,
                      style: blackonboardingBody1Style,
                    ),
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

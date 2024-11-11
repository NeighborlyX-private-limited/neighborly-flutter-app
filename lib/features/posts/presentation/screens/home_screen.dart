import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
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

class HomeScreen extends StatefulWidget {
  final String tabIndex;
  const HomeScreen({super.key, required this.tabIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isHome = true;
  bool isDobSet = true;
  late String _selectedCity;
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  bool isDobBtnActive = false;

  // Generate lists for day, month, and year

  List<String> days =
      List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));
  List<String> months =
      List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  List<String> years = List.generate(
    DateTime.now().year - 16 - 1900 + 1,
    (index) => (DateTime.now().year - 16 - index).toString(),
  );

  @override
  void initState() {
    super.initState();
    setIsHome();
    fetchLocationAndUpdate();
    setCityHomeName();
    setCityCurrentName();
    getUnreadNotificationCount();
    _selectedCity = ShardPrefHelper.getHomeCity() ?? 'Delhi';
    isDobSet = ShardPrefHelper.getDob();
    print('dob...$isDobSet');
    _fetchPosts();
    if (!isDobSet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openBottomSheet();
        // showBottomSheet(context);
      });
    }
    // _handleDeepLink('https://prod.neighborly.in/posts/12345');
  }

  // void _handleDeepLink(String deepLink) {
  //   // Parse the deep link
  //   try {
  //     print('callifng deeplink $deepLink');
  //     Uri uri = Uri.parse(deepLink);

  //     // // Check the scheme and host
  //     if (uri.scheme == 'myapp' && uri.host == 'posts') {
  //       //   // Extract the post ID from the path
  //       String postId =
  //           uri.pathSegments[1]; // Assuming the path is like /posts/12345

  //       //   // Navigate to the post detail screen
  //     }
  //   } catch (e) {
  //     print("getting error");
  //   }
  // }

  void onNotificationRead() {
    getUnreadNotificationCount();
  }

  void _fetchPosts() {
    _selectedCity = ShardPrefHelper.getHomeCity() ?? 'Delhi';
    setState(() {});
    BlocProvider.of<GetAllPostsBloc>(context)
        .add(GetAllPostsButtonPressedEvent(isHome: isHome));
  }

  /// set the location of  user whether their home location is on or current location in
  setIsHome() {
    print('setIsHome...');
    var isLocationOn = ShardPrefHelper.getIsLocationOn();
    setState(() {
      isHome = isLocationOn ? false : true;
    });
  }

  /// refersh the home screen
  Future<void> _onRefresh() async {
    print('this is call....');
    setIsHome();
    getUnreadNotificationCount();
    BlocProvider.of<GetAllPostsBloc>(context)
        .add(GetAllPostsButtonPressedEvent(isHome: isHome));
  }

// set home location city name
  setCityHomeName() async {
    List<double> homeLocation = ShardPrefHelper.getHomeLocation();
    print('home cord in city set: $homeLocation');
    List<Placemark> placemarks = await placemarkFromCoordinates(
      homeLocation[0],
      homeLocation[1],
    );

    var city = placemarks[0].locality ?? 'Delhi';
    print('home city $city');
    ShardPrefHelper.setHomeCity(city);
  }

// set current location city name
  setCityCurrentName() async {
    List<double> location = ShardPrefHelper.getLocation();
    print('current cord in city set: $location');
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location[0],
      location[1],
    );

    var city = placemarks[0].locality ?? 'Delhi';
    print('current city $city');
    ShardPrefHelper.setCurrentCity(city);
  }

  void handleToggle(bool value) {
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

  Future<bool> _handleLocationPermission() async {
    // bool serviceEnabled;
    LocationPermission permission;

    var checkPushPermission = await Permission.notification.isDenied;
    print('...checkPushPermission: $checkPushPermission');
    if (checkPushPermission) {
      await Permission.notification.request();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are denied'),
          ),
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );
      return false;
    }
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
      print(
          'Lat Long in Home Screen: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
      debugPrint('Error getting location: $e');
    }
  }

  ///fetch the unread notification count
  int unreadNotificationCount = 0;
  Future<void> getUnreadNotificationCount() async {
    print('getUnreadNotificationCount call..');
    getNotificationUnreadCount().then((value) {
      if (value >= 0) {
        if (mounted) {
          setState(() {
            unreadNotificationCount = value;
            print('Unread Notification Count: $unreadNotificationCount');
          });
        }
      }
    }).catchError((error) {
      print("Error in getUnread Notification Count: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5FF),
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                    color: const Color(0xffC5C2FF),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: isHome
                            ? const Color(0xff635BFF)
                            : const Color.fromARGB(255, 65, 65, 70),
                      ),
                      // Home Button
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
                                    ? const Color(0xff635BFF)
                                    : const Color.fromARGB(255, 65, 65, 70),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      // Dropdown for city selection
                      BlocListener<CityBloc, CityState>(
                        listener: (context, state) {
                          if (state is CityUpdatedState) {
                            ShardPrefHelper.setIsLocationOn(false);
                            handleToggle(true);
                            _fetchPosts();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('City updated to ${state.city}!'),
                              ),
                            );
                          } else if (state is CityErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${state.errorMessage}'),
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
                      // Vertical Divider
                      Container(
                        height: 25,
                        width: 1,
                        color: const Color(0xff2E2E2E),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      // Location Button
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
                                ? const Color(0xffC5C2FF)
                                : const Color(0xff635BFF),
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
                                style: TextStyle(color: Colors.white),
                              )
                            : null,
                        badgeStyle:
                            BadgeStyle(badgeColor: AppColors.primaryColor),
                        position: badges.BadgePosition.custom(end: 0, top: -8),
                        child: SvgPicture.asset(
                          'assets/alarm.svg',
                          fit: BoxFit.contain,
                          width: 30,
                          height: 30,
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
                          width: 30,
                          height: 30,
                        ),
                      ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<GetAllPostsBloc, GetAllPostsState>(
          builder: (context, state) {
            if (state is GetAllPostsLoadingState) {
              return const PostSheemerWidget();
            } else if (state is GetAllPostsSuccessState) {
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
                          Text(
                              "Time to be the hero this wall needs, start the"),
                          Text('Conversation!'),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor),
                            onPressed: () {
                              context.push('/create');
                            },
                            child: Text(
                              'Create a Post',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        if (post.type == 'post') {
                          return PostWidget(
                              post: post,
                              onDelete: () {
                                //context.read<GetAllPostsBloc>().deletepost(post.id);
                                _onRefresh();
                              });
                        } else if (post.type == 'poll') {
                          return PollWidget(
                              post: post,
                              onDelete: () {
                                //context.read<GetAllPostsBloc>().deletepost(post.id);
                                _onRefresh();
                              });
                        }
                        return const SizedBox();
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                        );
                      },
                    );
            } else if (state is GetAllPostsFailureState) {
              if (state.error.contains('Invalid Token')) {
                context.go('/loginScreen');
              }
              if (state.error.contains('Internal server error')) {
                // return SomethingWentWrong();
                return const Center(
                    child: Text(
                  'oops something went wrong',
                  style: TextStyle(color: Colors.red),
                ));
              }
              if (state.error.contains('No internet connection')) {
                return SomethingWentWrong(
                  imagePath: 'assets/something_went_wrong.svg',
                  title: 'Aaah! Something went wrong',
                  message:
                      "We couldn't start your program.\nPlease try starting it again",
                  buttonText: 'Retry',
                  onButtonPressed: () {
                    _onRefresh();
                  },
                );
              }

              return Center(child: Text(state.error));
            } else {
              return const Center(
                child: Text('No data'),
              );
            }
          },
        ),
      ),
    );
  }

  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          // Use StatefulBuilder to handle setState within the bottom sheet context
          builder: (BuildContext context, StateSetter setModalState) {
            void checkIfDobBtnShouldBeActive() {
              // Evaluate if all dropdowns have values
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
                          color: const Color(0xffB8B8B8),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        'One last thing before we get started!!',
                        style: onboardingHeading2Style,
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    Text('Date of Birth', style: blackonboardingBody1Style),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Day Dropdown
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedDay,
                            hint: Text("Day"),
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
                            dropdownColor: Colors.white,
                            icon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        SizedBox(width: 8),
                        // Month Dropdown
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedMonth,
                            hint: Text("Month"),
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
                            dropdownColor: Colors.white,
                            icon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        SizedBox(width: 8),
                        // Year Dropdown
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedYear,
                            hint: Text("Year"),
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
                            dropdownColor: Colors.white,
                            icon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    BlocConsumer<GetGenderAndDOBBloc, GetGenderAndDOBState>(
                      listener:
                          (BuildContext context, GetGenderAndDOBState state) {
                        if (state is GetGenderAndDOBFailureState) {
                          context.pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error
                                      .contains('DOB can only be set once.')
                                  ? 'User DOB already saved.'
                                  : state.error),
                            ),
                          );
                        } else if (state is GetGenderAndDOBSuccessState) {
                          print('User Info saved successfully.');
                          context.pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User Info saved successfully.'),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is GetGenderAndDOBLoadingState) {
                          return Center(
                            child: BouncingLogoIndicator(
                              logo: 'images/logo.svg',
                            ),
                          );
                          // return const Center(
                          //   child: CircularProgressIndicator(),
                          // );
                        }
                        return ButtonContainerWidget(
                          isActive: isDobBtnActive,
                          color: AppColors.primaryColor,
                          text: 'Save',
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

  // Future<void> showBottomSheet(BuildContext context) {
  //   TextEditingController dateController = TextEditingController();
  //   TextEditingController monthController = TextEditingController();
  //   TextEditingController yearController = TextEditingController();

  //   return showModalBottomSheet<num>(
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return DraggableScrollableSheet(
  //             expand: false,
  //             builder:
  //                 (BuildContext context, ScrollController scrollController) {
  //               return SingleChildScrollView(
  //                 controller: scrollController,
  //                 child: Container(
  //                   decoration: const BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(20),
  //                       topRight: Radius.circular(20),
  //                     ),
  //                   ),
  //                   padding: const EdgeInsets.symmetric(
  //                       horizontal: 12, vertical: 16),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Center(
  //                         child: Container(
  //                           width: 40,
  //                           height: 5,
  //                           decoration: BoxDecoration(
  //                             color: const Color(0xffB8B8B8),
  //                             borderRadius: BorderRadius.circular(40),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 15),
  //                       Center(
  //                         child: Text(
  //                           'One last thing before we get started!!',
  //                           style: onboardingHeading2Style,
  //                         ),
  //                       ),
  //                       const Divider(color: Colors.grey),
  //                       Text('Date of Birth', style: blackonboardingBody1Style),
  //                       const SizedBox(height: 8),
  //                       DOBPickerWidget(
  //                         dateController: dateController,
  //                         monthController: monthController,
  //                         yearController: yearController,
  //                         isDayFilled: true,
  //                         isMonthFilled: true,
  //                         isYearFilled: true,
  //                       ),
  //                       const SizedBox(height: 45),
  //                       BlocConsumer<GetGenderAndDOBBloc, GetGenderAndDOBState>(
  //                         listener: (BuildContext context,
  //                             GetGenderAndDOBState state) {
  //                           if (state is GetGenderAndDOBFailureState) {
  //                             if (state.error
  //                                 .contains('DOB can only be set once.')) {
  //                               context.pop();
  //                               ScaffoldMessenger.of(context).showSnackBar(
  //                                 const SnackBar(
  //                                     content: Text(
  //                                         'User Info saved successfully.')),
  //                               );
  //                             } else {
  //                               context.pop();
  //                               ScaffoldMessenger.of(context).showSnackBar(
  //                                 SnackBar(content: Text(state.error)),
  //                               );
  //                             }
  //                           } else if (state is GetGenderAndDOBSuccessState) {
  //                             print('User Info saved successfully.');
  //                             context.pop();
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               const SnackBar(
  //                                   content:
  //                                       Text('User Info saved successfully.')),
  //                             );
  //                           }
  //                         },
  //                         builder: (context, state) {
  //                           if (state is GetGenderAndDOBLoadingState) {
  //                             return const Center(
  //                               child: CircularProgressIndicator(),
  //                             );
  //                           }
  //                           return ButtonContainerWidget(
  //                             isActive: true,
  //                             color: AppColors.primaryColor,
  //                             text: 'Save',
  //                             isFilled: true,
  //                             onTapListener: () {
  //                               BlocProvider.of<GetGenderAndDOBBloc>(context)
  //                                   .add(
  //                                 GetGenderAndDOBButtonPressedEvent(
  //                                   dob: formatDOB(
  //                                     dateController.text.trim(),
  //                                     monthController.text.trim(),
  //                                     yearController.text.trim(),
  //                                   ),
  //                                 ),
  //                               );
  //                             },
  //                           );
  //                         },
  //                       ),
  //                       const SizedBox(height: 15),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}

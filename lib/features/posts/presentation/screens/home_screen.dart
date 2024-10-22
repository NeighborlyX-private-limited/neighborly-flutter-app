import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/home_dropdown_city.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_event.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_state.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../authentication/presentation/widgets/button_widget.dart';
import '../../../homePage/widgets/dob_picker_widget.dart';
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
  final bool isFirstTime;
  const HomeScreen({super.key, required this.isFirstTime});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isHome = true;
  late String _selectedCity;

  @override
  void initState() {
    super.initState();
    setIsHome();
    fetchLocationAndUpdate();
    setCityHomeName();
    setCityCurrentName();
    getUnreadNotificationCount();
    _selectedCity = ShardPrefHelper.getHomeCity() ?? 'Delhi';
    _fetchPosts();
    if (widget.isFirstTime) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showBottomSheet(context);
      });
    }
    //_handleDeepLink('https://prod.neighborly.in/posts/12345');
  }

  // void _handleDeepLink(String deepLink) {
  // // Parse the deep link
  // try {
  // print('callifng deeplink $deepLink');
  // Uri uri = Uri.parse(deepLink);

  // // // Check the scheme and host
  //  if (uri.scheme == 'myapp' && uri.host == 'posts') {
  // //   // Extract the post ID from the path
  // //   String postId = uri.pathSegments[1]; // Assuming the path is like /posts/12345

  // //   // Navigate to the post detail screen

  //  }
  // }catch(e){
  //   print("getting error");
  // }
// }
  void onNotificationRead() {
    getUnreadNotificationCount();
  }

  void _fetchPosts() {
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
          desiredAccuracy: LocationAccuracy.high);

      ShardPrefHelper.setLocation([position.latitude, position.longitude]);
      print(
          'Lat Long in Home Screen: ${position.latitude}, ${position.longitude}');
      setState(() {});
      //bool? isVerified = await ShardPrefHelper.getIsVerified();
      ///remove this code because we will only update the location only from settings
      // Map<String, List<num>> locationDetail = {
      //   isVerified ? 'homeLocation' : 'userLocation': [
      //     position.latitude,
      //     position.longitude
      //   ]
      // };

      // BlocProvider.of<UpdateLocationBloc>(context).add(
      //   UpdateLocationButtonPressedEvent(
      //     location: locationDetail,
      //   ),
      // );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  ///fetch the unread notification count
  int unreadNotificationCount = 0;
  Future<void> getUnreadNotificationCount() async {
    getNotificationUnreadCount().then((value) {
      if (value > 0) {
        if (mounted) {
          setState(() {
            unreadNotificationCount = value;
            print('UnreadNotificationCount Count: $unreadNotificationCount');
          });
        }
      }
    }).catchError((error) {
      print("Error in getUnreadNotificationCount: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                width: 120,
                decoration: BoxDecoration(
                  color: const Color(0xffC5C2FF),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Home Button
                    InkWell(
                      onTap: () {
                        ShardPrefHelper.setIsLocationOn(false);
                        handleToggle(true);
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isHome
                              ? const Color(0xff635BFF)
                              : const Color(0xffC5C2FF),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/home.svg',
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(),
                    // Vertical Divider
                    Container(
                      height: 20,
                      width: 1,
                      color: const Color(0xff2E2E2E),
                    ),
                    // Dropdown for city selection
                    BlocListener<CityBloc, CityState>(
                      listener: (context, state) {
                        if (state is CityUpdatedState) {
                          if (isHome) {
                            _fetchPosts();
                          }

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
        // title: Row(
        //   children: [
        //     SvgPicture.asset(
        //       'assets/logo.svg',
        //       width: 30,
        //       height: 34,
        //     ),
        //     const SizedBox(width: 10),
        //     Container(
        //       height: 40,
        //       width: 120,
        //       decoration: BoxDecoration(
        //         color: Color(0xffC5C2FF),
        //         borderRadius: BorderRadius.circular(100),
        //       ),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         children: [
        //           InkWell(
        //             onTap: () {
        //               ShardPrefHelper.setIsLocationOn(false);
        //               handleToggle(true);
        //             },
        //             child: Container(
        //               height: 35,
        //               width: 35,
        //               decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 color: isHome ? Color(0xff635BFF) : Color(0xffC5C2FF),
        //               ),
        //               child: Center(
        //                 child: SvgPicture.asset(
        //                   'assets/home.svg',
        //                   height: 25,
        //                   width: 25,
        //                 ),
        //               ),
        //             ),
        //           ),
        //           // SizedBox(
        //           //   width: 10,
        //           // ),
        //           Container(
        //             height: 20,
        //             width: 2,
        //             color: Color(0xff2E2E2E),
        //           ),
        //           Expanded(
        //             child: SizedBox(
        //               width: 30,
        //               height: 25,
        //               child: BlocProvider(
        //                 create: (context) => CityBloc(sl<
        //                     CityRepository>()), // Create and provide the CityBloc.
        //                 child: BlocListener<CityBloc, CityState>(
        //                   listener: (context, state) {
        //                     if (state is CityUpdatedState) {
        //                       print("yes");
        //                       ScaffoldMessenger.of(context).showSnackBar(
        //                         SnackBar(
        //                             content: Text(
        //                                 'City updated to ${state.city} successfully!')),
        //                       );
        //                     } else if (state is CityErrorState) {
        //                       ScaffoldMessenger.of(context).showSnackBar(
        //                         SnackBar(
        //                             content: Text(
        //                                 'Failed to update city: ${state.errorMessage}')),
        //                       );
        //                     }
        //                   },
        //                   child: SizedBox(
        //                     width: 20,
        //                     child: CityDropdownHome(
        //                       selectCity: _selectedCity,
        //                       onChanged: (String? newValue) {
        //                         setState(() {
        //                           _selectedCity = newValue!;
        //                         });

        //                         // Trigger the BLoC event only for the CityDropdown button.
        //                         if (newValue != null) {
        //                           // Add the UpdateCityEvent to the CityBloc when a new city is selected.
        //                           context
        //                               .read<CityBloc>()
        //                               .add(UpdateCityEvent(newValue));
        //                         }
        //                       },
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //           // Container(
        //           //     height: 35,
        //           //     // width: 50,
        //           //     decoration: BoxDecoration(
        //           //         color: isHome ? Color(0xffC5C2FF) : Color(0xff635BFF),
        //           //         borderRadius: BorderRadius.circular(10)),
        //           //     child: Icon(Icons.arrow_drop_down_circle)),

        //           InkWell(
        //             onTap: () {
        //               ShardPrefHelper.setIsLocationOn(true);
        //               handleToggle(false);
        //             },
        //             child: Container(
        //               height: 35,
        //               width: 35,
        //               decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 color: isHome ? Color(0xffC5C2FF) : Color(0xff635BFF),
        //                 // color: isHome ? Color(0xff635BFF) : Color(0xffC5C2FF),
        //                 // borderRadius: BorderRadius.circular(10)
        //               ),
        //               child: Center(
        //                 child: SvgPicture.asset(
        //                   'assets/location.svg',
        //                   height: 25,
        //                   width: 25,
        //                   // color: Color(0xff635BFF),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),

        //     // CustomToggleSwitch(
        //     //   imagePath1: 'assets/home.svg',
        //     //   imagePath2: 'assets/location.svg',
        //     //   onToggle: handleToggle,
        //     // ),
        //   ],
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                context.push('/notifications');
              },
              child: badges.Badge(
                badgeContent: unreadNotificationCount > 0
                    ? Text(
                        "$unreadNotificationCount",
                        style: TextStyle(color: Colors.white),
                      )
                    : null,
                badgeStyle: BadgeStyle(badgeColor: AppColors.primaryColor),
                position: badges.BadgePosition.custom(end: 0, top: -8),
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<GetAllPostsBloc, GetAllPostsState>(
          builder: (context, state) {
            print('state changed $state');
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
                              context.go('/create');
                            },
                            child: Text(
                              'Create a Post',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    )
                  // ? Center(
                  //     child: InkWell(
                  //       onTap: () {
                  //         context.go('/create');
                  //       },
                  //       child: Text(
                  //         'Create your first post',
                  //         style: bluemediumTextStyleBlack,
                  //       ),
                  //     ),
                  //   )
                  : ListView.separated(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        if (post.type == 'post') {
                          return PostWidget(
                              post: post,
                              onDelete: () {
                                print('this one is called');
                                //context.read<GetAllPostsBloc>().deletepost(post.id);
                                _onRefresh();
                              });
                        } else if (post.type == 'poll') {
                          return PollWidget(
                              post: post,
                              onDelete: () {
                                print('this one is called');
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
                return const Center(
                    child: Text(
                  'oops something went wrong',
                  style: TextStyle(color: Colors.red),
                ));
              }
              if (state.error.contains('No Internet Connection')) {
                return const Center(
                    child: Text(
                  'No Internet Connection',
                  style: TextStyle(color: Colors.red),
                ));
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

  Future<void> showBottomSheet(BuildContext context) {
    TextEditingController dateController = TextEditingController();
    TextEditingController monthController = TextEditingController();
    TextEditingController yearController = TextEditingController();

    return showModalBottomSheet<num>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: Column(
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
                        // const SizedBox(height: 25),
                        // Text('1. Select your Gender',
                        //     style: blackonboardingBody1Style),
                        // const SizedBox(height: 8),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: <Widget>[
                        //     Row(
                        //       children: [
                        //         Radio<String>(
                        //           value: 'Male',
                        //           groupValue: selectedGender,
                        //           onChanged: (String? value) {
                        //             setState(() {
                        //               selectedGender = value!;
                        //             });
                        //           },
                        //         ),
                        //         const Text('Male'),
                        //       ],
                        //     ),
                        //     Row(
                        //       children: [
                        //         Radio<String>(
                        //           value: 'Female',
                        //           groupValue: selectedGender,
                        //           onChanged: (String? value) {
                        //             setState(() {
                        //               selectedGender = value!;
                        //             });
                        //           },
                        //         ),
                        //         const Text('Female'),
                        //       ],
                        //     ),
                        //     Row(
                        //       children: [
                        //         Radio<String>(
                        //           value: 'Others',
                        //           groupValue: selectedGender,
                        //           onChanged: (String? value) {
                        //             setState(() {
                        //               selectedGender = value!;
                        //             });
                        //           },
                        //         ),
                        //         const Text('Others'),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        const Divider(color: Colors.grey),
                        Text('Date of Birth', style: blackonboardingBody1Style),
                        const SizedBox(height: 8),
                        DOBPickerWidget(
                          dateController: dateController,
                          monthController: monthController,
                          yearController: yearController,
                          isDayFilled: true,
                          isMonthFilled: true,
                          isYearFilled: true,
                        ),
                        const SizedBox(height: 45),
                        BlocConsumer<GetGenderAndDOBBloc, GetGenderAndDOBState>(
                          listener: (BuildContext context,
                              GetGenderAndDOBState state) {
                            if (state is GetGenderAndDOBFailureState) {
                              if (state.error
                                  .contains('DOB can only be set once.')) {
                                context.pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'User Info saved successfully.')),
                                );
                              } else {
                                context.pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.error)),
                                );
                              }
                            } else if (state is GetGenderAndDOBSuccessState) {
                              print('User Info saved successfully.');
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('User Info saved successfully.')),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is GetGenderAndDOBLoadingState) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ButtonContainerWidget(
                              isActive: true,
                              color: AppColors.primaryColor,
                              text: 'Save',
                              isFilled: true,
                              onTapListener: () {
                                BlocProvider.of<GetGenderAndDOBBloc>(context)
                                    .add(
                                  GetGenderAndDOBButtonPressedEvent(
                                    dob: formatDOB(
                                      dateController.text.trim(),
                                      monthController.text.trim(),
                                      yearController.text.trim(),
                                    ),
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
      },
    );
  }
}

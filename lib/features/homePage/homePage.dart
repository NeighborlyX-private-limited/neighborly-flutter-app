// ignore_for_file: unused_field

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/theme/colors.dart';
import '../../core/utils/shared_preference.dart';
import '../notification/presentation/bloc/notification_general_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  final Widget child;
  final String childId;

  const MainPage({
    super.key,
    required this.child,
    required this.childId,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ///bool varibale
  bool isDayFilled = false;
  bool isMonthFilled = false;
  bool isYearFilled = false;

  ///strinng varibale
  String? _currentAddress;
  String? _deepLink;

  ///controllers
  late PageController pageController;

  static const platform = MethodChannel('com.neighborlyx.neighborlysocial');

  /// init method
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    fetchLocationAndUpdate();
    updateFCMtokenNotification();
    _setDeepLinkListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ShardPrefHelper.removeImageUrl();
  }

  ///dispose method
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  /// deep link listner
  Future<void> _setDeepLinkListener() async {
    platform.setMethodCallHandler(
      (MethodCall call) async {
        if (call.method == "onDeepLink") {
          print("deep link received");
          setState(
            () {
              _deepLink = call.arguments;
              List? linksplit = _deepLink?.split('neighborly.in');
              if (linksplit != null && linksplit.length > 1) {
                if (linksplit[1].contains('post-detail/')) {
                  try {
                    context.push(linksplit[1]);
                  } catch (e) {
                    print("error in deep link $e");
                  }
                } else {
                  //context.push('/userProfileScreen/${widget.post.userId}');
                  print(
                      'here you have to handle other navigation for url based on if condition');
                }
              } else {
                print("Empty means open default page");
              }
            },
          );
        }
      },
    );
  }

  /// location permission method
  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;
    var checkPushPermission = await Permission.notification.isDenied;
    if (checkPushPermission) {
      await Permission.notification.request();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      /// location permission denied
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                AppLocalizations.of(context)!.location_permissions_are_denied),
          ));
        }
        return false;
      }
    }

    /// location permission forever denied
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!
              .location_permissions_are_permanently_denied_we_cannot_request_permissions),
        ));
      }
      return false;
    }

    ///location permission granted
    return true;
  }

  /// update fcm token method
  Future<void> updateFCMtokenNotification() async {
    try {
      var result = await BlocProvider.of<NotificationGeneralCubit>(context)
          .updateFCMTokenUsecase();
      result.fold(
        (failure) {},
        (currentFCMtoken) {
          ShardPrefHelper.setFCMtoken(currentFCMtoken);
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('FCM token error: $e')),
        );
      }
    }
  }

  /// fetch location and update
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
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
  }

  int _currentIndex = 0;
  void _onItemTapped(int index) {
    print('Tab Index:$index');
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        setState(() {
          _currentIndex = 0;
        });
        context.go('/home/Home');
        break;
      case 1:
        setState(() {
          _currentIndex = 1;
        });
        context.go('/groups');
        break;
      case 2:
        setState(() {
          _currentIndex = 2;
        });
        context.push('/create');
        break;
      // case 3:
      //     setState(() {
      //   _currentIndex = 3;
      // });
      //   context.go('/events');
      //   break;
      case 3:
        setState(() {
          _currentIndex = 3;
        });
        context.push('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Tab Id: ${widget.childId}');
    if (widget.childId == 'Home') {
      setState(() {
        _currentIndex = 0;
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: AppColors.whiteColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.blackColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.home,
              ),
              label: AppLocalizations.of(context)!.home,
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.groups,
              ),
              label: 'Groups',
            ),

            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/add.svg',
                fit: BoxFit.contain,
              ),
              label: '',
            ),
            // const BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.calendar_month,
            //   ),
            //   label: 'Events',
            // ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: AppLocalizations.of(context)!.profile,
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) => _onItemTapped(
            index,
          ),
        ),
        body: widget.child,
      ),
    );
  }
}

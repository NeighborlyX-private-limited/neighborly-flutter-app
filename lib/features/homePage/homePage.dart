import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/homePage/bloc/update_location_bloc/update_location_bloc.dart';

class MainPage extends StatefulWidget {
  final Widget child;

  const MainPage({
    super.key,
    required this.child,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _currentAddress;
  Position? _currentPosition;

  bool isDayFilled = false;
  bool isMonthFilled = false;
  bool isYearFilled = false;

  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    fetchLocationAndUpdate();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchLocationAndUpdate();
    ShardPrefHelper.removeImageUrl();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // void navigationTapped(int index) {
  //   pageController.jumpToPage(index);
  // }

  // void onPageChanged(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  // }

  // Future<bool> _getDOBFilled() async {
  //   final userID = ShardPrefHelper.getUserID();
  //   final box = Hive.box('dobDatabse');

  //   return box.get('${userID}_isFilled', defaultValue: false);
  // }

  // Future<void> _setDOBFilledTrue() async {
  //   final userID = ShardPrefHelper.getUserID();
  //   final box = Hive.box('dobDatabse');
  //   await box.put('${userID}_isFilled', true);
  // }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> fetchLocationAndUpdate() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      ShardPrefHelper.setLocation([position.latitude, position.longitude]);
      print('Location: ${position.latitude}, ${position.longitude}');

      BlocProvider.of<UpdateLocationBloc>(context).add(
        UpdateLocationButtonPressedEvent(
          location: [position.latitude, position.longitude],
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  int _currentIndex = 0;
  // List<Widget> pages = [
  //   const HomeScreen(),
  //   const EventScreen(),
  //   const CreatePostScreen(),
  //   const CommunityScreen(),
  //   const ProfileScreen(),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/home/false');
        break;
      case 1:
        context.go('/events');
        break;
      case 2:
        context.go('/create');
        break;
      case 3:
        context.go('/groups');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5FF),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFFF5F5FF),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_month,
              ),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/add.svg',
                fit: BoxFit.contain,
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.groups,
              ),
              label: 'Groups',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Profile',
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/homePage/bloc/update_location_bloc/update_location_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/screens/home_screen.dart';
import 'package:neighborly_flutter_app/features/upload/presentation/screens/create_post_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  String? _currentAddress;
  Position? _currentPosition;

  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch location and update when the page becomes visible
    _fetchLocationAndUpdate();
    ShardPrefHelper.removeImageUrl();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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

  Future<void> _fetchLocationAndUpdate() async {
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

      // Dispatch the event to update location
      BlocProvider.of<UpdateLocationBloc>(context).add(
        UpdateLocationButtonPressedEvent(
          location: [position.latitude, position.longitude],
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5FF),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFFF5F5FF),
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: navigationTapped,
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
              label: '', // Optional: You can leave the label empty
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
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: const <Widget>[
            HomeScreen(),
            HomeScreen(),
            CreatePostScreen(),
            CreatePostScreen(),
            CreatePostScreen(),
          ],
        ),
      ),
    );
  }
}

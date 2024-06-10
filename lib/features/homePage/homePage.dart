import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/screens/home_screen.dart';
import 'package:neighborly_flutter_app/features/upload_post/presentation/screens/create_post_screen.dart';
import 'package:neighborly_flutter_app/features/upload_post/presentation/widgets/post_button_widget.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
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
                icon: Image.asset(
                  'assets/add.png',
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
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_version_plus/new_version_plus.dart';
import '../../core/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

ValueNotifier<bool> isBottomNavVisible = ValueNotifier<bool>(true);

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
  late PageController pageController;
  late dynamic newVersionPlus;
  int _lastIndex = 0;
  int currentIndex = 0;

  /// init method
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    newVersionPlus = NewVersionPlus();
    newVersionPlus.showAlertIfNecessary(context: context);
  }

  /// dispose method
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  /// Get the current index based on the active route
  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    print('Router location : $location');
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/groups')) {
      return 1;
    }
    if (location.startsWith('/create') ||
        location.startsWith('/groups/create')) {
      return 2;
    }
    if (location.startsWith('/coming-soon')) {
      return 3;
    }
    if (location.startsWith('/profile')) {
      return 4;
    }

    return 0;
  }

  /// Handle bottom navigation taps
  void _onItemTapped(int index) {
    currentIndex = _getCurrentIndex(context);
    setState(() {
      _lastIndex = currentIndex;
    });

    if (index == 2) {
      if (_lastIndex == 0 || _lastIndex == 3 || _lastIndex == 4) {
        context.push('/create');
      } else if (_lastIndex == 1) {
        context.push('/group-create');
      }
      return;
    }

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/groups');
        break;
      case 3:
        context.go('/coming-soon');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_getCurrentIndex');
    print(_getCurrentIndex(context));
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        bottomNavigationBar: ValueListenableBuilder<bool>(
          valueListenable: isBottomNavVisible,
          builder: (context, isVisible, child) {
            return isVisible
                ? BottomNavigationBar(
                    elevation: 0,
                    backgroundColor: AppColors.whiteColor,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: AppColors.primaryColor,
                    unselectedItemColor: AppColors.blackColor,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.home),
                        label: AppLocalizations.of(context)!.home,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.groups),
                        label: AppLocalizations.of(context)!.groups,
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          'assets/add.svg',
                          fit: BoxFit.contain,
                        ),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.calendar_month),
                        label: AppLocalizations.of(context)!.events,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.person),
                        label: AppLocalizations.of(context)!.profile,
                      ),
                    ],
                    currentIndex: _getCurrentIndex(context),
                    onTap: _onItemTapped,
                  )
                : const SizedBox.shrink();
          },
        ),
        body: widget.child,
      ),
    );
  }
}

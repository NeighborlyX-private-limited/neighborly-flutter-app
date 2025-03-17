import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
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
  NewVersionPlus newVersionPlus = NewVersionPlus();
  int _lastIndex = 0;
  int currentIndex = 0;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    ShowUpdate();
  }

  // Future<bool> isConnected() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   return connectivityResult != ConnectivityResult.none;
  // }

// CHECK CAN UPDATE
  void ShowUpdate() async {
    try {
      print('ok ');
      VersionStatus? status = await newVersionPlus.getVersionStatus();
      print('ok this');
      if (status != null && status.canUpdate) {
        Update();
      }
    } catch (e) {
      print('this is error : $e');
    }
  }

// UPDATE DIALOG

  void Update() async {
    print('ok yes');
    final status = await newVersionPlus.getVersionStatus();

    newVersionPlus.showUpdateDialog(
      context: context,
      versionStatus: status!,
      dialogTitle: 'New Update Available',
      dialogText:
          'Please update the app for new features and better experience.',
      updateButtonText: 'Update',
      allowDismissal: false,
    );
  }

  // DISPOSE
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

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
        // context.go('/discover');
        // context.go('/private-chat');
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

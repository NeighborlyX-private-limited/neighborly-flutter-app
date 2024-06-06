import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/constants/route_constants.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/onboarding_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/register_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: RouteConstants.onboardingScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const OnBoardingScreen();
        },
      ),
      GoRoute(
        path: '/registerScreen',
        name: RouteConstants.reisterScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: '/registerScreen',
        name: RouteConstants.loginScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
    ]);

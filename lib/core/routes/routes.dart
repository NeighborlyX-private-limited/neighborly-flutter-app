import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/constants/route_constants.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/login_with_email_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/new_password_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/onboarding_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/otp_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/register_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/register_with_email_screen.dart';
import 'package:neighborly_flutter_app/features/homePage/homePage.dart';
import 'package:neighborly_flutter_app/features/upload/presentation/screens/create_post_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
List<String>? cookies = ShardPrefHelper.getCookie();

String setInitialLocation() {
  if (cookies == null) {
    return '/';
  } else {
    return '/homescreen';
  }
}

final GoRouter router = GoRouter(
    // initialLocation: setInitialLocation(),
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
        path: '/loginScreen',
        name: RouteConstants.loginScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/registerWithEmailScreen',
        name: RouteConstants.registerWithEmailScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterWithEmailScreen();
        },
      ),
      GoRoute(
        path: '/loginWithEmailScreen',
        name: RouteConstants.loginWithEmailScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginWithEmailScreen();
        },
      ),
      GoRoute(
        path: '/otp/:data/:verificationFor',
        name: RouteConstants.otpRouteName,
        builder: (BuildContext context, GoRouterState state) {
          final String data = state.pathParameters['data']!;
          final String verificationFor =
              state.pathParameters['verificationFor']!;
          return OtpScreen(data: data, verificationFor: verificationFor);
        },
      ),
      GoRoute(
        path: '/newPassword/:data',
        name: RouteConstants.newPasswordScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          final String data = state.pathParameters['data']!;

          return NewPasswordScreen(data: data);
        },
      ),
      GoRoute(
        path: '/forgot-password',
        name: RouteConstants.forgotPasswordRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotPasswordScreen();
        },
      ),
      GoRoute(
        path: '/homescreen',
        name: RouteConstants.homeScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const MainPage();
        },
      ),
      // GoRoute(
      //   path: '/post-detail/',
      //   name: RouteConstants.postDetailScreenRouteName,
      //   builder: (BuildContext context, GoRouterState state) {

      //     return const PostDetailScreen();
      //   },
      // ),
      GoRoute(
        path: '/upload-post',
        name: RouteConstants.uploadPostScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const CreatePostScreen();
        },
      ),
    ]);

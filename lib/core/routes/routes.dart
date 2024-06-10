import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/constants/route_constants.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/login_with_email_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/onboarding_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/otp_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/register_screen.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/register_with_email_screen.dart';
import 'package:neighborly_flutter_app/features/homePage/homePage.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/screens/home_screen.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/screens/post_detail_screen.dart';
import 'package:neighborly_flutter_app/features/upload_post/presentation/screens/create_post_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      // GoRoute(
      //   path: '/',
      //   name: RouteConstants.onboardingScreenRouteName,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const OnBoardingScreen();
      //   },
      // ),
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
        path: '/forgot-password',
        name: RouteConstants.forgotPasswordRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotPasswordScreen();
        },
      ),
      GoRoute(
        path: '/',
        name: RouteConstants.homeScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return MainPage();
        },
      ),
      GoRoute(
        path: '/post-detail',
        name: RouteConstants.postDetailScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const PostDetailScreen();
        },
      ),
      GoRoute(
        path: '/upload-post',
        name: RouteConstants.uploadPostScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const CreatePostScreen();
        },
      ),
    ]);

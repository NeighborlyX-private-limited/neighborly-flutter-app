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
import 'package:neighborly_flutter_app/features/community_screen.dart';
import 'package:neighborly_flutter_app/features/events_screen.dart';
import 'package:neighborly_flutter_app/features/homePage/homePage.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/screens/home_screen.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/screens/post_detail_screen.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/screens/activity_and_stats_screen.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/screens/basic_information_screen.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/screens/communities_screen.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/screens/feedback_screen.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/screens/find_me_screen.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/screens/security_screen.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/screens/setting_screen.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/screens/user_profile_screen.dart';
import 'package:neighborly_flutter_app/features/upload/presentation/screens/create_post_screen.dart';
import 'package:neighborly_flutter_app/features/upload/presentation/screens/media_preview_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
List<String>? cookies = ShardPrefHelper.getCookie();

// String setInitialLocation() {
//   if (cookies == null) {
//     return '/';
//   } else {
//     return '/homescreen';
//   }
// }

String setInitialLocation() {
  // Check if cookies exist and set the initial location accordingly
  // return (cookies == null || cookies!.isEmpty) ? '/' : '/homescreen/false';
  return (cookies == null || cookies!.isEmpty) ? '/' : '/home/false';
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
      // GoRoute(
      //   path: '/homescreen/',
      //   name: RouteConstants.homeScreenRouteName,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const MainPage(
      //       isFirstTime: true,
      //     );
      //   },
      // ),
      ShellRoute(
        builder: (context, state, child) {
          return MainPage(
            child: child,
          );
        },
        routes: [
          GoRoute(
              path: '/home/:isFirstTime',
              builder: (context, state) {
                final bool isFirstTime =
                    state.pathParameters['isFirstTime'] == 'true';
                return HomeScreen(
                  isFirstTime: isFirstTime,
                );
              }),
          GoRoute(
            path: '/events',
            builder: (context, state) => const EventScreen(),
          ),
          GoRoute(
            path: '/create',
            builder: (context, state) => const CreatePostScreen(),
          ),
          GoRoute(
            path: '/groups',
            builder: (context, state) => const CommunityScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/post-detail/:postId/:isPost/:userId',
        name: RouteConstants.postDetailScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          final String postId = state.pathParameters['postId']!;
          final bool isPost = state.pathParameters['isPost'] == 'true';
          final String userId = state.pathParameters['userId']!;
          return PostDetailScreen(
            postId: postId,
            isPost: isPost,
            userId: userId,
          );
        },
      ),
      GoRoute(
        path: '/settingsScreen',
        name: RouteConstants.settingsScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const SettingScreen();
        },
      ),
      GoRoute(
        path: '/media-preview',
        name: RouteConstants.mediaPreviewScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const MediaPreviewScreen();
        },
      ),
      GoRoute(
        path: '/securityScreen',
        name: RouteConstants.securityScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const SecurityPage();
        },
      ),
      GoRoute(
        path: '/activityAndStatsScreen',
        name: RouteConstants.activityAndStatsScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const ActivityAndStatsScreen();
        },
      ),
      GoRoute(
        path: '/feedbackScreen',
        name: RouteConstants.feedbackScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const FeedbackScreen();
        },
      ),
      GoRoute(
        path: '/findMeScreen',
        name: RouteConstants.findMeScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const FindMeScreen();
        },
      ),
      GoRoute(
        path: '/communitiesScreen',
        name: RouteConstants.communitiesScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const CommunitiesScreen();
        },
      ),
      GoRoute(
        path: '/userProfileScreen/:userId',
        name: RouteConstants.userProfileScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          final String userId = state.pathParameters['userId']!;
          return UserProfileScreen(
            userId: userId,
          );
        },
      ),
      GoRoute(
        path: '/basicInformationScreen',
        name: RouteConstants.basicInformationScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const BasicInformationScreen();
        },
      ),
    ]);

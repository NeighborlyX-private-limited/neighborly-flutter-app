import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/tutorial_screen.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/screens/deletd_user_profile_screen.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/screens/radius_screen.dart';

import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/login_with_email_screen.dart';
import '../../features/authentication/presentation/screens/new_password_screen.dart';
import '../../features/authentication/presentation/screens/onboarding_screen.dart';
import '../../features/authentication/presentation/screens/otp_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/register_with_email_screen.dart';
import '../../features/chat/data/model/chat_room_model.dart';
import '../../features/chat/presentation/screens/chat_group_screen.dart';
import '../../features/chat/presentation/screens/chat_group_thread_screen.dart';
import '../../features/chat/presentation/screens/chat_main_screen.dart';
import '../../features/chat/presentation/screens/chat_private_screen.dart';
import '../../features/communities/presentation/screens/community_admin_set_block_screen.dart';
import '../../features/communities/presentation/screens/community_admin_set_description_screen.dart';
import '../../features/communities/presentation/screens/community_admin_set_icon_screen.dart';
import '../../features/communities/presentation/screens/community_admin_set_location_screen.dart';
import '../../features/communities/presentation/screens/community_admin_set_members_screen.dart';
import '../../features/communities/presentation/screens/community_admin_set_radius_screen.dart';
import '../../features/communities/presentation/screens/community_admin_set_screen.dart';
import '../../features/communities/presentation/screens/community_admin_set_type_screen.dart';
import '../../features/communities/presentation/screens/community_create_screen.dart';
import '../../features/communities/presentation/screens/community_details_screen.dart';
import '../../features/communities/presentation/screens/community_screen.dart';
import '../../features/communities/presentation/screens/community_search_screen.dart';
import '../../features/event/data/model/event_model.dart';
import '../../features/event/presentation/screens/event_create_screen.dart';
import '../../features/event/presentation/screens/event_join_screen.dart';
import '../../features/event/presentation/screens/event_success_screen.dart';
import '../../features/event/presentation/screens/event_detail_screen.dart';
import '../../features/event/presentation/screens/event_main_screen.dart';
import '../../features/event/presentation/screens/event_search_screen.dart';
import '../../features/homePage/homePage.dart';
import '../../features/notification/presentation/screens/notification_list_screen.dart';
import '../../features/posts/presentation/screens/home_screen.dart';
import '../../features/posts/presentation/screens/post_detail_screen.dart';
import '../../features/profile/presentation/screens/activity_and_stats_screen.dart';
import '../../features/profile/presentation/screens/basic_information_screen.dart';
import '../../features/profile/presentation/screens/communities_screen.dart';
import '../../features/profile/presentation/screens/feedback_screen.dart';
import '../../features/profile/presentation/screens/find_me_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/security_screen.dart';
import '../../features/profile/presentation/screens/setting_screen.dart';
import '../../features/profile/presentation/screens/user_profile_screen.dart';
import '../../features/upload/presentation/screens/create_post_screen.dart';
import '../constants/route_constants.dart';
import '../models/community_model.dart';
import '../utils/shared_preference.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
List<String>? cookies = ShardPrefHelper.getCookie();

String setInitialLocation() {
  var IsPhoneVarify = ShardPrefHelper.getIsPhoneVerified();
  var IsVarify = ShardPrefHelper.getIsVerified();
  if (cookies == null || cookies!.isEmpty) {
    return '/';
  } else {
    if (IsPhoneVarify || IsVarify || cookies!.isNotEmpty) {
      return '/home/false';
    } else {
      return '/';
    }
  }
}

final GoRouter router = GoRouter(
    initialLocation: setInitialLocation(),
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
        path: '/tutorialScreen',
        name: RouteConstants.tutorialScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const TutorialScreen();
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
        path: '/deleted-user',
        name: RouteConstants.deletedUserRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const DeletedUserProfileScreen();
        },
      ),
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
            builder: (context, state) => const EventMainScreen(),
          ),
          GoRoute(
            path: '/events/create',
            builder: (context, state) => const EventCreateScreen(),
          ),
          GoRoute(
            path: '/events/edit',
            builder: (context, state) => EventCreateScreen(
              eventToUpdate:
                  state.extra != null ? state.extra as EventModel : null,
            ),
          ),
          GoRoute(
            path: '/events/join', // register
            builder: (context, state) => EventJoinScreen(
              eventToJoin:
                  state.extra != null ? state.extra as EventModel : null,
            ),
          ),
          GoRoute(
            path: '/events/success/:type',
            builder: (context, state) => EventSuccessSuccessScreen(
              type: state.pathParameters["type"] as String,
              event: state.extra as EventModel,
            ),
          ),
          GoRoute(
            path: '/events/search',
            builder: (context, state) => const EventSearchScreen(),
          ),
          GoRoute(
            path: '/events/detail/:eventId',
            builder: (context, state) => EventDetailScreen(
              eventId: state.pathParameters["eventId"] as String,
              event: state.extra != null ? state.extra as EventModel : null,
            ),
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
            path: '/groups/create',
            builder: (context, state) => const CommunityCreateScreen(),
          ),
          GoRoute(
            path: '/groups/admin',
            builder: (context, state) => CommunityAdminSetScreen(
                community: state.extra as CommunityModel),
          ),
          GoRoute(
            path: '/groups/admin/members',
            builder: (context, state) =>
                const CommunityAdminMembersUsersScreen(),
          ),
          GoRoute(
            path: '/groups/admin/type',
            builder: (context, state) => const CommunityAdminTypeScreen(),
          ),
          GoRoute(
            path: '/groups/admin/radius',
            builder: (context, state) => const CommunityAdminRadiusScreen(),
          ),
          GoRoute(
            path: '/groups/admin/description',
            builder: (context, state) =>
                const CommunityAdminDescriptionScreen(),
          ),
          GoRoute(
            path: '/groups/admin/icon',
            builder: (context, state) => const CommunityAdminIconScreen(),
          ),
          GoRoute(
            path: '/groups/admin/location',
            builder: (context, state) => const CommunityAdminLocationScreen(),
          ),
          GoRoute(
            path: '/groups/admin/blocked',
            builder: (context, state) =>
                const CommunityAdminBlockedUsersScreen(),
          ),
          GoRoute(
            path: '/groups/search',
            builder: (context, state) => const CommunitySearchScreen(),
          ),
          GoRoute(
            path: '/groups/:communityId',
            builder: (context, state) => CommunityDetailsScreen(
                communityId: state.pathParameters["communityId"] as String),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatMainScreen(),
          ),
          GoRoute(
            path: '/chat/group/:roomId',
            builder: (context, state) => ChatGroupScreen(
              roomId: state.pathParameters["roomId"] as String,
              room: state.extra as ChatRoomModel,
            ),
          ),
          GoRoute(
              path: '/chat/group/thread/:messageId',
              builder: (context, state) {
                return ChatGroupThreadScreen(
                  messageId: state.pathParameters["messageId"] as String,
                  room: (state.extra as Map<String, dynamic>)['room'],
                  message: (state.extra as Map<String, dynamic>)['message'],
                );
              }),
          GoRoute(
            path: '/chat/private/:roomId',
            builder: (context, state) => ChatPrivateScreen(
              roomId: state.pathParameters["roomId"] as String,
              room: state.extra as ChatRoomModel,
            ),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationListScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/post-detail/:postId/:isPost/:userId/:commentId',
        name: RouteConstants.postDetailScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          final String postId = state.pathParameters['postId']!;
          final bool isPost = state.pathParameters['isPost'] == 'true';
          final String userId = state.pathParameters['userId']!;
          final String commentId = state.pathParameters['commentId'] ?? '0';
          return PostDetailScreen(
            postId: postId,
            isPost: isPost,
            userId: userId,
            commentId: commentId,
          );
        },
      ),
      GoRoute(
        path: '/settingsScreen/:karma/:findMe',
        name: RouteConstants.settingsScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          final String karma = state.pathParameters['karma']!;
          final bool findMe = state.pathParameters['findMe'] == 'true';

          return SettingScreen(
            karma: karma,
            findMe: findMe,
          );
        },
      ),
      // GoRoute(
      //   path: '/media-preview',
      //   name: RouteConstants.mediaPreviewScreenRouteName,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const MediaPreviewScreen();
      //   },
      // ),
      GoRoute(
        path: '/securityScreen',
        name: RouteConstants.securityScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const SecurityPage();
        },
      ),
      GoRoute(
        path: '/activityAndStatsScreen/:karma',
        name: RouteConstants.activityAndStatsScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          final String karma = state.pathParameters['karma']!;
          return ActivityAndStatsScreen(
            karma: karma,
          );
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
      GoRoute(
        path: '/radiusScreen',
        name: RouteConstants.radiusScreenRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const RadiusScreen();
        },
      ),
    ]);

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/widgets/event_coming_soon.dart';
import 'package:neighborly_flutter_app/core/widgets/not_found_widget.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/tutorial_screen.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/screens/community_admin_set_displayname.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/screens/manage_join_request_screen.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/screens/post_detail_of_specific_comment.dart';
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
import '../../features/chat/presentation/screens/chat_main_screen.dart';
import '../../features/chat/presentation/screens/chat_private_screen.dart';
import '../../features/chat/presentation/screens/discover_screen.dart';
import '../../features/chat/presentation/screens/dm_screen.dart';
import '../../features/chat/presentation/screens/group_pinned_message_screen.dart';
import '../../features/chat/presentation/screens/interest_selection_screen.dart';
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
import '../../features/homePage/home_page.dart';
import '../../features/notification/presentation/screens/notification_list_screen.dart';
import '../../features/posts/presentation/screens/home_screen.dart';
import '../../features/posts/presentation/screens/post_detail_screen.dart';
import '../../features/profile/presentation/screens/activity_and_stats_screen.dart';
import '../../features/profile/presentation/screens/basic_information_screen.dart';
import '../../features/profile/presentation/screens/communities_screen.dart';
import '../../features/profile/presentation/screens/edit_interest_screen.dart';
import '../../features/profile/presentation/screens/feedback_screen.dart';
import '../../features/profile/presentation/screens/find_me_screen.dart';
import '../../features/profile/presentation/screens/location_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/security_screen.dart';
import '../../features/profile/presentation/screens/setting_screen.dart';
import '../../features/profile/presentation/screens/user_profile_screen.dart';
import '../../features/refer_and_earn/presentation/screen/invite_screen.dart';
import '../../features/refer_and_earn/presentation/screen/request_history_screen.dart';
import '../../features/refer_and_earn/presentation/screen/reward_screen.dart';
import '../../features/upload/presentation/screens/create_post_screen.dart';
import '../constants/route_constants.dart';
import '../models/community_model.dart';
import '../utils/shared_preference.dart';
import '../widgets/google_map_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
String? cookies = ShardPrefHelper.getCookie();

// INITIAL ROUTE
String setInitialLocation() {
  var isPhoneVarify = ShardPrefHelper.getIsPhoneVerified();
  var isEmailVarify = ShardPrefHelper.getIsVerified();
  var authType = ShardPrefHelper.getAuthtype();
  print('isPhoneVarify:$isPhoneVarify');
  print('isEmailVarify:$isEmailVarify');
  print('authType:$authType');
  // IF COOKIE NOT FOUND
  if (cookies == null || cookies!.isEmpty) {
    return '/';
  }
  // IS PHONE LOGIN
  else if (authType == 'phone') {
    if (isPhoneVarify && cookies!.isNotEmpty) {
      return '/home';
    } else {
      return '/';
    }
  }
  // IS EMAIL LOGIN
  else if (authType == 'email') {
    if (isEmailVarify && cookies!.isNotEmpty) {
      return '/home';
    } else {
      return '/';
    }
  }
  // IS GOOGLE LOGIN
  else if (authType == 'google') {
    return '/home';
  }
  return '/';
}

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: setInitialLocation(),
  routes: <RouteBase>[
    // AUTH ROUTES
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
        final String verificationFor = state.pathParameters['verificationFor']!;
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

    // SHELL ROUTES
    ShellRoute(
      builder: (context, state, child) {
        return MainPage(
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) {
            return HomeScreen();
          },
        ),
        GoRoute(
          path: '/groups',
          builder: (context, state) => const CommunityScreen(),
        ),
        GoRoute(
          path: '/events',
          builder: (context, state) => const EventMainScreen(),
        ),
        GoRoute(
          path: '/private-chat',
          builder: (context, state) => InterestSelectionScreen(),
        ),
        // GoRoute(
        //   path: '/coming-soon',
        //   builder: (context, state) => const CommingSoonScreen(),
        // ),
        GoRoute(
          path: '/discover',
          builder: (context, state) => DiscoverScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // POST UPLOAD SCREEN
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreatePostScreen(),
    ),

    // HOME ROUTES
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationListScreen(),
    ),
    GoRoute(
      path: '/post-detail/:postId',
      // path: '/post-detail/:postId/:isPost/:userId/:commentId',
      name: RouteConstants.postDetailScreenRouteName,
      builder: (BuildContext context, GoRouterState state) {
        final String postId = state.pathParameters['postId']!;
        // final bool isPost = state.pathParameters['isPost'] == 'true';
        // final String userId = state.pathParameters['userId']!;
        final String commentId = state.pathParameters['commentId'] ?? '0';
        return PostDetailScreen(
          postId: postId,
          //isPost: isPost,
          //userId: userId,
          // commentId: commentId,
        );
      },
    ),
    GoRoute(
      path: '/post-detail-of-specific-comment/:commentId',
      name: RouteConstants.postDetailOfSpecificCommentScreenRouteName,
      builder: (BuildContext context, GoRouterState state) {
        final String commentId = state.pathParameters['commentId'] ?? '0';
        return PostDetailOfSpecificComment(
          commentId: commentId,
        );
      },
    ),

    // GROUP ROUTES
    GoRoute(
      path: '/group-create',
      builder: (context, state) => const CommunityCreateScreen(),
    ),
    GoRoute(
      path: '/group-admin',
      builder: (context, state) =>
          CommunityAdminSetScreen(community: state.extra as CommunityModel),
    ),
    GoRoute(
      path: '/manage-group-join-request/:communityId',
      builder: (context, state) => ManageJoinRequestScreen(
        communityId: state.pathParameters["communityId"] as String,
      ),
    ),
    GoRoute(
      path: '/group-members',
      builder: (context, state) => const CommunityAdminMembersUsersScreen(),
    ),
    GoRoute(
      path: '/group-type',
      builder: (context, state) => const CommunityAdminTypeScreen(),
    ),
    GoRoute(
      path: '/group-radius',
      builder: (context, state) => const CommunityAdminRadiusScreen(),
    ),
    GoRoute(
      path: '/group-description',
      builder: (context, state) => const CommunityAdminDescriptionScreen(),
    ),
    GoRoute(
      path: '/group-displayname',
      builder: (context, state) => const CommunityAdminDisplaynameScreen(),
    ),
    GoRoute(
      path: '/group-icon',
      builder: (context, state) => const CommunityAdminIconScreen(),
    ),
    GoRoute(
      path: '/group-location',
      builder: (context, state) => const CommunityAdminLocationScreen(),
    ),
    GoRoute(
      path: '/group-blocked',
      builder: (context, state) => const CommunityAdminBlockedUsersScreen(),
    ),
    GoRoute(
      path: '/group-search',
      builder: (context, state) => const CommunitySearchScreen(),
    ),
    GoRoute(
      path: '/group-details/:communityId',
      builder: (context, state) => CommunityDetailsScreen(
        communityId: state.pathParameters["communityId"] as String,
      ),
    ),

    // GROUP CHAT ROUTES
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatMainScreen(),
    ),
    // GoRoute(
    //   path: '/chat-private/:chatId',
    //   builder: (context, state) => DMScreen(
    //     chatId: state.pathParameters["chatId"] as String,
    //   ),
    // ),
    GoRoute(
      path: '/chat-private/:chatId',
      builder: (context, state) {
        final chatId = state.pathParameters['chatId'] as String;
        final extra = state.extra as Map<String, dynamic>?;

        final profilePic = extra?['profilePic'] ?? '';
        final userName = extra?['userName'] ?? '';

        return DMScreen(
          chatId: chatId,
          profilePic: profilePic,
          userNmae: userName,
        );
      },
    ),

    GoRoute(
      path: '/edit-interest',
      builder: (context, state) => EditInterestScreen(),
    ),

    GoRoute(
      path: '/group-chat/:roomId',
      builder: (context, state) {
        String roomId = state.pathParameters["roomId"] as String;
        // final extra = state.extra as Map?;

        // final ChatRoomModel chatRoom = extra!['chatModel'];

        return ChatGroupScreen(
          roomId: roomId,
          //chatRoom: chatRoom,
        );
      },
    ),
    GoRoute(
      path: '/group-chat-pinned-message/:groupId/:isAdmin',
      builder: (context, state) {
        String isAdmin = state.pathParameters["isAdmin"] as String;

        return GroupPinnedMessagesScreen(
          groupId: state.pathParameters["groupId"] as String,
          isAdmin: isAdmin == "true" ? true : false,
        );
      },
    ),

    // EVENT ROUTES
    GoRoute(
      path: '/events/create',
      builder: (context, state) => const EventCreateScreen(),
    ),
    GoRoute(
      path: '/events/edit',
      builder: (context, state) => EventCreateScreen(
        eventToUpdate: state.extra != null ? state.extra as EventModel : null,
      ),
    ),
    GoRoute(
      path: '/events/join',
      builder: (context, state) => EventJoinScreen(
        eventToJoin: state.extra != null ? state.extra as EventModel : null,
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

    // PROFILE ROUTES
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
    GoRoute(
      path: '/securityScreen',
      name: RouteConstants.securityScreenRouteName,
      builder: (BuildContext context, GoRouterState state) {
        return const SecurityPage();
      },
    ),
    GoRoute(
      path: '/reward-details',
      // name: RouteConstants.securityScreenRouteName,
      builder: (BuildContext context, GoRouterState state) {
        return const RewardScreen();
      },
    ),
    GoRoute(
      path: '/reward-history',
      // name: RouteConstants.securityScreenRouteName,
      builder: (BuildContext context, GoRouterState state) {
        return const RewardHistoryScreen();
      },
    ),
    GoRoute(
      path: '/invite',
      // name: RouteConstants.securityScreenRouteName,
      builder: (BuildContext context, GoRouterState state) {
        return const InviteScreen();
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
      path: '/locationScreen',
      builder: (BuildContext context, GoRouterState state) {
        return const LocationScreen();
      },
    ),
    GoRoute(
      path: '/googleMapScreen',
      builder: (BuildContext context, GoRouterState state) {
        return LocationPickerScreen();
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
    GoRoute(
      path: '/communitiesScreen',
      name: RouteConstants.communitiesScreenRouteName,
      builder: (BuildContext context, GoRouterState state) {
        return const CommunitiesScreen();
      },
    ),
    GoRoute(
      path: '/deleted-user',
      name: RouteConstants.deletedUserRouteName,
      builder: (BuildContext context, GoRouterState state) {
        return const DeletedUserProfileScreen();
      },
    ),
  ],
  errorPageBuilder: (context, state) {
    return MaterialPage(
      key: state.pageKey,
      child: NotFoundWidget(),
    );
  },
);

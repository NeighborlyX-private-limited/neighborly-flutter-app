import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/cubit/tutorial_cubit.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/add_user_community_usecase.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/get_user_groups_usecase.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/join_community_usecase.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/delete_community_usecase.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/remove_admin_community_usecase.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/update_community_displayname.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/add_remove_user_in_group_bloc.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/get_user_groups_bloc.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/join_group_bloc.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/make_remove_admin_bloc.dart';
import 'package:neighborly_flutter_app/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:neighborly_flutter_app/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:neighborly_flutter_app/features/payment/domain/repositories/payment_repository.dart';
import 'package:neighborly_flutter_app/features/payment/domain/usecases/create_order_usecase.dart';
import 'package:neighborly_flutter_app/features/payment/domain/usecases/verify_payment_usecase.dart';
import 'package:neighborly_flutter_app/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/get_comment_by_comment_id.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/get_comment_by_comment_id_bloc/get_comments_by_commentId_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/data/repositories/city_repositories.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_bloc.dart';
import 'core/network/network_info.dart';
import 'features/authentication/data/data_sources/auth_remote_data_source/auth_remote_data_source.dart';
import 'features/authentication/data/data_sources/auth_remote_data_source/auth_remote_data_source_impl.dart';
import 'features/authentication/data/repository/auth_repository_impl.dart';
import 'features/authentication/domain/repositories/auth_repository.dart';
import 'features/authentication/domain/usecases/fogot_password_usecase.dart';
import 'features/authentication/domain/usecases/google_authentication_usecase.dart';
import 'features/authentication/domain/usecases/login_with_email_usecase.dart';
import 'features/authentication/domain/usecases/resend_otp_usecase.dart';
import 'features/authentication/domain/usecases/signup_with_email_usecase.dart';
import 'features/authentication/domain/usecases/verify_otp_usecase.dart';
import 'features/authentication/presentation/bloc/fogot_password_bloc/forgot_password_bloc.dart';
import 'features/authentication/presentation/bloc/google_authentication_bloc/google_authentication_bloc.dart';
import 'features/authentication/presentation/bloc/login_with_email_bloc/login_with_email_bloc.dart';
import 'features/authentication/presentation/bloc/register_bloc/register_bloc.dart';
import 'features/authentication/presentation/bloc/resend_otp_bloc/resend_otp_bloc.dart';
import 'features/authentication/presentation/bloc/verify_otp_bloc/verify_otp_bloc.dart';
import 'features/chat/data/data_sources/chat_remote_data_source/chat_remote_data_source.dart';
import 'features/chat/data/data_sources/chat_remote_data_source/chat_remote_data_source_impl.dart';
import 'features/chat/data/data_sources/chat_remote_data_source/chat_remote_data_source_thread.dart';
import 'features/chat/data/data_sources/chat_remote_data_source/chat_remote_data_source_impl_thread.dart';
import 'features/chat/data/repositories/chat_repositories_impl.dart';
import 'features/chat/data/repositories/chat_repositories_impl_thread.dart';
import 'features/chat/domain/repositories/chat_repositories.dart';
import 'features/chat/domain/repositories/chat_repositories_thread.dart';
import 'features/chat/domain/usecases/get_all_chat_rooms_usecase.dart';
import 'features/chat/domain/usecases/get_chat_group_room_messages_usecase .dart';
import 'features/chat/domain/usecases/get_chat_room_messages_usecase.dart';
import 'features/chat/domain/usecases/get_all_chat_rooms_usecase_thread.dart';
import 'features/chat/domain/usecases/get_chat_group_room_messages_usecase_thread.dart';
import 'features/chat/domain/usecases/get_chat_room_messages_usecase_thread.dart';
import 'features/chat/presentation/bloc/chat_group_cubit.dart';
import 'features/chat/presentation/bloc/chat_group_cubit_thread.dart';
import 'features/chat/presentation/bloc/chat_main_cubit.dart';
import 'features/chat/presentation/bloc/chat_private_cubit.dart';
import 'features/communities/data/data_sources/community_remote_data_source/community_remote_data_source.dart';
import 'features/communities/data/data_sources/community_remote_data_source/community_remote_data_source_impl.dart';
import 'features/communities/data/repositories/community_repositories_impl.dart';
import 'features/communities/domain/repositories/community_repositories.dart';
import 'features/communities/domain/usecases/create_community_usecase.dart';
import 'features/communities/domain/usecases/get_all_communities_usecase.dart';
import 'features/communities/domain/usecases/get_community_usecase.dart';
import 'features/communities/domain/usecases/get_search_history_communities_usecase.dart';
import 'features/communities/domain/usecases/get_search_results_communities_usecase.dart';
import 'features/communities/domain/usecases/leave_community_usecase.dart';
import 'features/communities/domain/usecases/make_admin_community_usecase.dart';
import 'features/communities/domain/usecases/remove_user_community_usecase.dart';
import 'features/communities/domain/usecases/report_community_usecase.dart';
import 'features/communities/domain/usecases/unblock_user_community_usecase.dart';
import 'features/communities/domain/usecases/update_description_community_usecase.dart';
import 'features/communities/domain/usecases/update_icon_community_usecase.dart';
import 'features/communities/domain/usecases/update_location_community_usecase.dart';
import 'features/communities/domain/usecases/update_mute_community_usecase.dart';
import 'features/communities/domain/usecases/update_radius_community_usecase.dart';
import 'features/communities/domain/usecases/update_type_community_usecase.dart';
import 'features/communities/presentation/bloc/communities_create_cubit.dart';
import 'features/communities/presentation/bloc/communities_main_cubit.dart';
import 'features/communities/presentation/bloc/communities_search_cubit.dart';
import 'features/communities/presentation/bloc/community_detail_cubit.dart';
import 'features/event/data/data_sources/event_remote_data_source/event_remote_data_source.dart';
import 'features/event/data/data_sources/event_remote_data_source/event_remote_data_source_impl.dart';
import 'features/event/data/repositories/event_repositories_impl.dart';
import 'features/event/domain/repositories/event_repositories.dart';
import 'features/event/domain/usecases/cancel_event_usecase.dart';
import 'features/event/domain/usecases/create_event_usecase.dart';
import 'features/event/domain/usecases/get_all_events_usecase.dart';
import 'features/event/domain/usecases/join_event_usecase.dart';
import 'features/event/domain/usecases/update_event_usecase.dart';
import 'features/event/presentation/bloc/event_create_cubit.dart';
import 'features/event/presentation/bloc/event_detail_cubit.dart';
import 'features/event/presentation/bloc/event_join_cubit.dart';
import 'features/event/presentation/bloc/event_main_cubit.dart';
import 'features/event/presentation/bloc/event_search_cubit.dart';
import 'features/homePage/bloc/update_location_bloc/update_location_bloc.dart';
import 'features/notification/data/data_sources/notification_remote_data_source/notification_remote_data_source.dart';
import 'features/notification/data/data_sources/notification_remote_data_source/notification_remote_data_source_impl.dart';
import 'features/notification/data/repositories/notification_repositories_impl.dart';
import 'features/notification/domain/repositories/notification_repositories.dart';
import 'features/notification/domain/usecases/get_all_notifications_usecase.dart';
import 'features/notification/domain/usecases/update_fcm_token_usecase.dart';
import 'features/notification/presentation/bloc/notification_general_cubit.dart';
import 'features/notification/presentation/bloc/notification_list_cubit.dart';
import 'features/posts/data/data_sources/post_remote_data_source/post_remote_data_source.dart';
import 'features/posts/data/data_sources/post_remote_data_source/post_remote_data_source_impl.dart';
import 'features/posts/data/repositories/post_repositories_impl.dart';
import 'features/posts/domain/repositories/post_repositories.dart';
import 'features/posts/domain/usecases/add_comment_usecase.dart';
import 'features/posts/domain/usecases/delete_post_usecase.dart';
import 'features/posts/domain/usecases/feedback_usecase.dart';
import 'features/posts/domain/usecases/fetch_comment_reply_usecase.dart';
import 'features/posts/domain/usecases/get_all_posts_usecase.dart';
import 'features/posts/domain/usecases/get_comments_by_postid_usecase.dart';
import 'features/posts/domain/usecases/get_post_by_id_usecase.dart';
import 'features/posts/domain/usecases/give_award_usecase.dart';
import 'features/posts/domain/usecases/report_post_usecase.dart';
import 'features/posts/domain/usecases/vote_poll_usecase.dart';
import 'features/posts/presentation/bloc/add_comment_bloc/add_comment_bloc.dart';
import 'features/posts/presentation/bloc/delete_post_bloc/delete_post_bloc.dart';
import 'features/posts/presentation/bloc/feedback_bloc/feedback_bloc.dart';
import 'features/posts/presentation/bloc/fetch_comment_reply_bloc/fetch_comment_reply_bloc.dart';
import 'features/posts/presentation/bloc/get_all_posts_bloc/get_all_posts_bloc.dart';
import 'features/posts/presentation/bloc/get_comments_by_postId_bloc/get_comments_by_postId_bloc.dart';
import 'features/posts/presentation/bloc/get_post_by_id_bloc/get_post_by_id_bloc.dart';
import 'features/posts/presentation/bloc/give_award_bloc/give_award_bloc.dart';
import 'features/posts/presentation/bloc/report_post_bloc/report_post_bloc.dart';
import 'features/posts/presentation/bloc/vote_poll_bloc/vote_poll_bloc.dart';
import 'features/profile/data/data_sources/profile_remote_data_source/profile_remote_data_source.dart';
import 'features/profile/data/data_sources/profile_remote_data_source/profile_remote_data_source_impl.dart';
import 'features/profile/data/repositories/profile_repositories_impl.dart';
import 'features/profile/domain/repositories/profile_repositories.dart';
import 'features/profile/domain/usecases/change_password_usecase.dart';
import 'features/profile/domain/usecases/delete_account_usecase.dart';
import 'features/profile/domain/usecases/edit_profile_usecase.dart';
import 'features/profile/domain/usecases/get_gender_and_dob.dart';
import 'features/profile/domain/usecases/get_my_awards_usecase.dart';
import 'features/profile/domain/usecases/get_my_comments_usecase.dart';
import 'features/profile/domain/usecases/get_my_groups_usecase.dart';
import 'features/profile/domain/usecases/get_my_posts_usecase.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/domain/usecases/get_user_info_usecase.dart';
import 'features/profile/domain/usecases/logout_usecase.dart';
import 'features/profile/domain/usecases/send_feedback_usecase.dart';
import 'features/profile/domain/usecases/update_location_usecase.dart';
import 'features/profile/presentation/bloc/change_password_bloc/change_password_bloc.dart';
import 'features/profile/presentation/bloc/delete_account_bloc/delete_account_bloc.dart';
import 'features/profile/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'features/profile/presentation/bloc/get_gender_and_DOB_bloc/get_gender_and_DOB_bloc.dart';
import 'features/profile/presentation/bloc/get_my_awards_bloc/get_my_awards_bloc.dart';
import 'features/profile/presentation/bloc/get_my_comments_bloc/get_my_comments_bloc.dart';
import 'features/profile/presentation/bloc/get_my_groups_bloc/get_my_groups_bloc.dart';
import 'features/profile/presentation/bloc/get_my_posts_bloc/get_my_posts_bloc.dart';
import 'features/profile/presentation/bloc/get_profile_bloc/get_profile_bloc.dart';
import 'features/profile/presentation/bloc/get_user_info_bloc/get_user_info_bloc.dart';
import 'features/profile/presentation/bloc/logout_bloc.dart/logout_bloc.dart';
import 'features/profile/presentation/bloc/send_feedback_bloc/send_feedback_bloc.dart';
import 'features/upload/data/data_sources/upload_remote_data_source/upload_remote_data_source.dart';
import 'features/upload/data/data_sources/upload_remote_data_source/upload_remote_data_source_impl.dart';
import 'features/upload/data/repositories/upload_repositories_impl.dart';
import 'features/upload/domain/repositories/upload_repositories.dart';
import 'features/upload/domain/usecases/upload_file_usecase.dart';
import 'features/upload/domain/usecases/upload_post_usecase.dart';
import 'features/upload/presentation/bloc/upload_file_bloc/upload_file_bloc.dart';
import 'features/upload/presentation/bloc/upload_post_bloc/upload_post_bloc.dart';
import 'features/chat/Socket/socketService.dart';

/// getit instance
final sl = GetIt.instance;

void init() async {
  // Bloc
  sl.registerFactory(
      () => PaymentBloc(createOrderUseCase: sl(), verifyPaymentUseCase: sl()));

  ///........... register repository
  /// auth repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  /// profile repository
  sl.registerLazySingleton<ProfileRepositories>(
      () => ProfileRepositoriesImpl(remoteDataSource: sl(), networkInfo: sl()));

  /// post repository
  sl.registerLazySingleton<PostRepositories>(
      () => PostRepositoriesImpl(remoteDataSource: sl(), networkInfo: sl()));

  /// uploade repository
  sl.registerLazySingleton<UploadRepositories>(
      () => UploadRepositoriesImpl(remoteDataSource: sl(), networkInfo: sl()));

  /// community/group repository
  sl.registerLazySingleton<CommunityRepositories>(() =>
      CommunityRepositoriesImpl(remoteDataSource: sl(), networkInfo: sl()));

  /// chat repository
  sl.registerLazySingleton<ChatRepositories>(
      () => ChatRepositoriesImpl(remoteDataSource: sl(), networkInfo: sl()));

  /// chat repository thread
  sl.registerLazySingleton<ChatRepositoriesThread>(() =>
      ChatRepositoriesImplThread(remoteDataSource: sl(), networkInfo: sl()));

  /// event repository
  sl.registerLazySingleton<EventRepositories>(
      () => EventRepositoriesImpl(remoteDataSource: sl(), networkInfo: sl()));

  /// notification repository
  sl.registerLazySingleton<NotificationRepositories>(() =>
      NotificationRepositoriesImpl(remoteDataSource: sl(), networkInfo: sl()));

  /// city repository
  sl.registerLazySingleton<CityRepository>(() => CityRepository());

  /// payment Repositories
  sl.registerLazySingleton<PaymentRepository>(
      () => PaymentRepositoryImpl(remoteDataSource: sl()));

  ///.......... register datasource
  ///auth datasource
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: sl()));

  ///profile datasource
  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(client: sl()));

  ///post datasource
  sl.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(client: sl()));

  ///uploade datasource
  sl.registerLazySingleton<UploadRemoteDataSource>(
      () => UploadRemoteDataSourceImpl(client: sl()));

  ///community/group datasource
  sl.registerLazySingleton<CommunityRemoteDataSource>(
      () => CommunityRemoteDataSourceImpl(client: sl()));

  ///chat datasource
  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(client: sl()));

  ///chat datasource thread
  sl.registerLazySingleton<ChatRemoteDataSourceThread>(
      () => ChatRemoteDataSourceImplThread(client: sl()));

  ///event datasource
  sl.registerLazySingleton<EventRemoteDataSource>(
      () => EventRemoteDataSourceImpl(client: sl()));

  ///notification datasource
  sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(client: sl()));

  ///payment datasource
  sl.registerLazySingleton(() => PaymentRemoteDataSource(client: sl()));

  ///.................. register usecase
  ///auth usecase
  sl.registerLazySingleton(() => SignupUsecase(sl()));
  sl.registerLazySingleton(() => LoginWithEmailUsecase(sl()));
  sl.registerLazySingleton(() => ResendOTPUsecase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUsecase(sl()));
  sl.registerLazySingleton(() => VerifyOTPUsecase(sl()));
  sl.registerLazySingleton(() => GoogleAuthenticationUsecase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));

  ///post usecase
  sl.registerLazySingleton(() => GetAllPostsUsecase(sl()));
  sl.registerLazySingleton(() => ReportPostUsecase(sl()));
  sl.registerLazySingleton(() => FeedbackUsecase(sl()));
  sl.registerLazySingleton(() => GetPostByIdUsecase(sl()));
  sl.registerLazySingleton(() => GetCommentsByPostIdUsecase(sl()));
  sl.registerLazySingleton(() => UpdateLocationUsecase(sl()));
  sl.registerLazySingleton(() => DeletePostUsecase(sl()));
  sl.registerLazySingleton(() => AddCommentUsecase(sl()));
  sl.registerLazySingleton(() => VotePollUsecase(sl()));
  sl.registerLazySingleton(() => FetchCommentReplyUsecase(sl()));
  sl.registerLazySingleton(() => GiveAwardUsecase(sl()));
  sl.registerLazySingleton(() => GetGenderAndDOBUsecase(sl()));
  sl.registerLazySingleton(() => GetMyPostsUsecase(sl()));
  sl.registerLazySingleton(() => SendFeedbackUsecase(sl()));
  sl.registerLazySingleton(() => GetCommentByCommentIdUsecase(sl()));

  ///uploade usecase
  sl.registerLazySingleton(() => UploadFileUsecase(sl()));
  sl.registerLazySingleton(() => UploadPostUsecase(sl()));

  /// profile usecase
  sl.registerLazySingleton(() => GetProfileUsecase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(sl()));
  sl.registerLazySingleton(() => GetUserInfoUsecase(sl()));
  sl.registerLazySingleton(() => GetMyCommentsUsecase(sl()));
  sl.registerLazySingleton(() => GetMyGroupUsecase(sl()));
  sl.registerLazySingleton(() => EditProfileUsecase(sl()));
  sl.registerLazySingleton(() => GetMyAwardsUsecase(sl()));

  /// community/group usecase
  sl.registerLazySingleton(() => CreateCommunityUsecase(sl()));
  sl.registerLazySingleton(() => GetAllCommunitiesUsecase(sl()));
  sl.registerLazySingleton(() => GetUserGroupsUsecase(sl()));
  sl.registerLazySingleton(() => GetCommunityUsecase(sl()));
  sl.registerLazySingleton(() => MakeAdminCommunityUsecase(sl()));
  sl.registerLazySingleton(() => RemoveAdminCommunityUsecase(sl()));
  sl.registerLazySingleton(() => AddUserCommunityUsecase(sl()));
  sl.registerLazySingleton(() => RemoveUserCommunityUsecase(sl()));
  sl.registerLazySingleton(() => JoinCommunityUsecase(sl()));
  sl.registerLazySingleton(() => LeaveCommunityUsecase(sl()));
  sl.registerLazySingleton(() => ReportCommunityUsecase(sl()));
  sl.registerLazySingleton(() => DeleteCommunityUsecase(sl()));
  sl.registerLazySingleton(() => UpdateIconCommunityUsecase(sl()));
  sl.registerLazySingleton(() => UpdateDisplayNameCommunityUsecase(sl()));
  sl.registerLazySingleton(() => UpdateDescriptionCommunityUsecase(sl()));
  sl.registerLazySingleton(() => UpdateTypeCommunityUsecase(sl()));
  sl.registerLazySingleton(() => UnblockUserCommunityUsecase(sl()));
  sl.registerLazySingleton(() => UpdateLocationCommunityUsecase(sl()));
  sl.registerLazySingleton(() => UpdateRadiusCommunityUsecase(sl()));
  sl.registerLazySingleton(() => UpdateMuteCommunityUsecase(sl()));
  sl.registerLazySingleton(() => GetSearchHistoryCommunitiesUsecase(sl()));
  sl.registerLazySingleton(() => GetSearchResultsCommunitiesUsecase(sl()));

  ///payment usecase
  sl.registerLazySingleton(() => CreateOrderUseCase(repository: sl()));
  sl.registerLazySingleton(() => VerifyPaymentUseCase(repository: sl()));

  ///chat usecase
  sl.registerLazySingleton(() => GetAllChatRoomsUsecase(sl()));
  sl.registerLazySingleton(() => GetAllChatRoomsUsecaseThread(sl()));
  sl.registerLazySingleton(() => GetChatRoomMessagesUseCaseThread(sl()));
  sl.registerLazySingleton(() => GetChatGroupRoomMessagesUseCaseThread(sl()));
  sl.registerLazySingleton(() => GetChatRoomMessagesUseCase(sl()));
  sl.registerLazySingleton(() => GetChatGroupRoomMessagesUseCase(sl()));

  ///event usecase
  sl.registerLazySingleton(() => CreateEventUsecase(sl()));
  sl.registerLazySingleton(() => GetEventsUsecase(sl()));
  sl.registerLazySingleton(() => CancelEventUsecase(sl()));
  sl.registerLazySingleton(() => UpdateEventUsecase(sl()));
  sl.registerLazySingleton(() => JoinEventUsecase(sl()));

  ///notification usecase
  sl.registerLazySingleton(() => UpdateFCMTokenUsecase(sl()));
  sl.registerLazySingleton(() => GetAllNotificationsUsecase(sl()));

  ///........... register bloc
  ///auth bloc
  sl.registerFactory(
      () => RegisterBloc(registerUseCase: sl(), googleLoginCase: sl()));
  sl.registerFactory(
      () => LoginWithEmailBloc(loginUseCase: sl(), googleLoginCase: sl()));
  sl.registerFactory(() => ResendOtpBloc(resendOTPUsecase: sl()));
  sl.registerFactory(() => ForgotPasswordBloc(forgotPasswordUsecase: sl()));
  sl.registerFactory(() => OtpBloc(verifyOTPUsecase: sl()));
  sl.registerFactory(
      () => GoogleAuthenticationBloc(googleAuthenticationaUsecase: sl()));
  sl.registerFactory(() => ChangePasswordBloc(changePasswordUsecase: sl()));
  sl.registerFactory(() => LogoutBloc(logoutUsecase: sl()));

  ///post bloc
  sl.registerFactory(() => UploadPostBloc(uploadPostUsecase: sl()));
  sl.registerFactory(() => UploadFileBloc(uploadFileUsecase: sl()));
  sl.registerFactory(() => GetAllPostsBloc(getAllPostsUsecase: sl()));
  sl.registerFactory(() => ReportPostBloc(reportPostUsecase: sl()));
  sl.registerFactory(() => FeedbackBloc(feedbackUsecase: sl()));
  sl.registerFactory(() => GetPostByIdBloc(getPostByIdUsecase: sl()));
  sl.registerFactory(
      () => GetCommentsByPostIdBloc(getCommentsByPostIdUsecase: sl()));
  sl.registerFactory(
      () => GetCommentByCommentIdBloc(commentByCommentIdUsecase: sl()));
  sl.registerFactory(() => UpdateLocationBloc(updateLocationUsecase: sl()));
  sl.registerFactory(() => DeletePostBloc(deletePostUsecase: sl()));
  sl.registerFactory(() => AddCommentBloc(addCommentUsecase: sl()));
  sl.registerFactory(() => VotePollBloc(votePollUsecase: sl()));
  sl.registerFactory(
      () => FetchCommentReplyBloc(fetchCommentReplyUsecase: sl()));
  sl.registerFactory(() => GiveAwardBloc(giveAwardUsecase: sl()));
  sl.registerFactory(() => SendFeedbackBloc(sendFeedbackUsecase: sl()));

  ///profile bloc
  sl.registerFactory(() => GetProfileBloc(getProfileUsecase: sl()));
  sl.registerFactory(() => GetMyPostsBloc(getMyPostsUsecase: sl()));
  sl.registerFactory(() => DeleteAccountBloc(deleteAccountUsecase: sl()));
  sl.registerFactory(() => GetUserInfoBloc(getUserInfoUsecase: sl()));
  sl.registerFactory(() => GetMyCommentsBloc(getMyCommentsUsecase: sl()));
  sl.registerFactory(() => GetMyGroupsBloc(getMyGroupsUsecase: sl()));
  sl.registerFactory(() => EditProfileBloc(editProfileUsecase: sl()));
  sl.registerFactory(() => GetMyAwardsBloc(getMyAwardsUsecase: sl()));
  sl.registerFactory(() => GetGenderAndDOBBloc(getGenderAndDOBUsecase: sl()));

  ///community bloc
  sl.registerFactory(() => CommunityMainCubit(sl()));
  sl.registerFactory(() => GetUserGroupsBloc(getUserGroupsUsecase: sl()));
  sl.registerFactory(() => CommunityDetailsCubit(sl(), sl(), sl(), sl(), sl(),
      sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => CommunityCreateCubit(sl()));
  sl.registerFactory(() =>
      JoinGroupBloc(joinCommunityUsecase: sl(), leaveCommunityUsecase: sl()));
  sl.registerFactory(() => AddRemoveUserInGroupBloc(
      addUserCommunityUsecase: sl(), removeUserCommunityUsecase: sl()));
  sl.registerFactory(() => MakeRemoveAdminBloc(
      makeAdminCommunityUsecase: sl(), removeAdminCommunityUsecase: sl()));
  sl.registerFactory(() => CommunitySearchCubit(sl(), sl()));

  ///chat bloc
  sl.registerFactory(() => ChatMainCubit(sl()));
  sl.registerFactory(() => ChatPrivateCubit(sl()));
  sl.registerFactory(() => ChatGroupCubit(sl(), sl<SocketService>()));
  sl.registerFactory(() => ChatGroupCubitThread(sl(), sl<SocketService>()));

  ///event bloc
  sl.registerFactory(() => EventMainCubit(sl()));
  sl.registerFactory(() => EventCreateCubit(sl(), sl(), sl()));
  sl.registerFactory(() => EventDetailCubit(sl(), sl()));
  sl.registerFactory(() => EventSearchCubit(sl()));
  sl.registerFactory(() => EventJoinCubit(sl()));

  ///notification bloc
  sl.registerFactory(() => NotificationGeneralCubit(sl()));
  sl.registerFactory(() => NotificationListCubit(sl()));

  ///others bloc
  sl.registerFactory<TutorialCubit>(() => TutorialCubit(sl()));
  sl.registerFactory(() => CityBloc(sl<CityRepository>()));

  /// register socket services
  sl.registerLazySingleton<SocketService>(() => SocketService());

  /// register network info
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      InternetConnectionChecker(),
    ),
  );
}

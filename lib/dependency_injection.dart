import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:neighborly_flutter_app/core/network/network_info.dart';
import 'package:neighborly_flutter_app/features/homePage/bloc/update_location_bloc/update_location_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/add_comment_usecase.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/delete_post_usecase.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/feedback_usecase.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/fetch_comment_reply_usecase.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/get_comments_by_postid_usecase.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/get_post_by_id_usecase.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/give_award_usecase.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/report_post_usecase.dart';
import 'package:neighborly_flutter_app/features/posts/domain/usecases/vote_poll_usecase.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/add_comment_bloc/add_comment_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/delete_post_bloc/delete_post_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/feedback_bloc/feedback_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/fetch_comment_reply_bloc/fetch_comment_reply_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/get_comments_by_postId_bloc/get_comments_by_postId_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/get_post_by_id_bloc/get_post_by_id_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/give_award_bloc/give_award_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/report_post_bloc/report_post_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/vote_poll_bloc/vote_poll_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/edit_profile_usecase.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/get_my_comments_usecase.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/get_my_groups_usecase.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/get_my_posts_usecase.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/get_gender_and_dob.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/get_user_info_usecase.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/logout_usecase.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/send_feedback_usecase.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/update_location_usecase.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/delete_account_bloc/delete_account_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_my_comments_bloc/get_my_comments_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_my_groups_bloc/get_my_groups_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_my_posts_bloc/get_my_posts_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_profile_bloc/get_profile_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_gender_and_DOB_bloc/get_gender_and_DOB_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_user_info_bloc/get_user_info_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/logout_bloc.dart/logout_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/send_feedback_bloc/send_feedback_bloc.dart';
import 'package:neighborly_flutter_app/features/upload/domain/usecases/upload_file_usecase.dart';
import 'package:neighborly_flutter_app/features/upload/presentation/bloc/upload_file_bloc/upload_file_bloc.dart';
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
import 'features/authentication/presentation/bloc/resend_otp_bloc/resend_otp_bloc.dart';
import 'features/authentication/presentation/bloc/login_with_email_bloc/login_with_email_bloc.dart';
import 'features/authentication/presentation/bloc/register_with_email_bloc/register_with_email_bloc.dart';
import 'features/authentication/presentation/bloc/verify_otp_bloc/verify_otp_bloc.dart';
import 'features/posts/data/data_sources/post_remote_data_source/post_remote_data_source.dart';
import 'features/posts/data/data_sources/post_remote_data_source/post_remote_data_source_impl.dart';
import 'features/posts/data/repositories/post_repositories_impl.dart';
import 'features/posts/domain/repositories/post_repositories.dart';
import 'features/posts/domain/usecases/get_all_posts_usecase.dart';
import 'features/posts/presentation/bloc/get_all_posts_bloc/get_all_posts_bloc.dart';
import 'features/profile/data/data_sources/profile_remote_data_source/profile_remote_data_source.dart';
import 'features/profile/data/data_sources/profile_remote_data_source/profile_remote_data_source_impl.dart';
import 'features/profile/data/repositories/profile_repositories_impl.dart';
import 'features/profile/domain/repositories/profile_repositories.dart';
import 'features/profile/domain/usecases/change_password_usecase.dart';
import 'features/profile/presentation/bloc/change_password_bloc/change_password_bloc.dart';
import 'features/upload/data/data_sources/upload_remote_data_source/upload_remote_data_source.dart';
import 'features/upload/data/data_sources/upload_remote_data_source/upload_remote_data_source_impl.dart';
import 'features/upload/data/repositories/upload_repositories_impl.dart';
import 'features/upload/domain/repositories/upload_repositories.dart';
import 'features/upload/domain/usecases/upload_post_usecase.dart';
import 'features/upload/presentation/bloc/upload_post_bloc/upload_post_bloc.dart';

final sl = GetIt.instance;

void init() async {
  // register repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<ProfileRepositories>(
      () => ProfileRepositoriesImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<PostRepositories>(
      () => PostRepositoriesImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<UploadRepositories>(
      () => UploadRepositoriesImpl(remoteDataSource: sl(), networkInfo: sl()));

  // register datasource
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<UploadRemoteDataSource>(
      () => UploadRemoteDataSourceImpl(client: sl()));

  // register usecase
  sl.registerLazySingleton(() => SignupWithEmailUsecase(sl()));
  sl.registerLazySingleton(() => LoginWithEmailUsecase(sl()));
  sl.registerLazySingleton(() => ResendOTPUsecase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUsecase(sl()));
  sl.registerLazySingleton(() => VerifyOTPUsecase(sl()));
  sl.registerLazySingleton(() => GoogleAuthenticationUsecase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUsecase(sl()));
  sl.registerLazySingleton(() => GetAllPostsUsecase(sl()));
  sl.registerLazySingleton(() => UploadPostUsecase(sl()));
  sl.registerLazySingleton(() => ReportPostUsecase(sl()));
  sl.registerLazySingleton(() => FeedbackUsecase(sl()));
  sl.registerLazySingleton(() => GetPostByIdUsecase(sl()));
  sl.registerLazySingleton(() => GetCommentsByPostIdUsecase(sl()));
  sl.registerLazySingleton(() => UpdateLocationUsecase(sl()));
  sl.registerLazySingleton(() => DeletePostUsecase(sl()));
  sl.registerLazySingleton(() => UploadFileUsecase(sl()));
  sl.registerLazySingleton(() => AddCommentUsecase(sl()));
  sl.registerLazySingleton(() => VotePollUsecase(sl()));
  sl.registerLazySingleton(() => FetchCommentReplyUsecase(sl()));
  sl.registerLazySingleton(() => GiveAwardUsecase(sl()));
  sl.registerLazySingleton(() => GetGenderAndDOBUsecase(sl()));
  sl.registerLazySingleton(() => GetProfileUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => GetMyPostsUsecase(sl()));
  sl.registerLazySingleton(() => SendFeedbackUsecase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(sl()));
  sl.registerLazySingleton(() => GetUserInfoUsecase(sl()));
  sl.registerLazySingleton(() => GetMyCommentsUsecase(sl()));
  sl.registerLazySingleton(() => GetMyGroupUsecase(sl()));
  sl.registerLazySingleton(() => EditProfileUsecase(sl()));

  // register bloc
  sl.registerFactory(() => RegisterWithEmailBloc(registerUseCase: sl()));
  sl.registerFactory(() => LoginWithEmailBloc(loginUseCase: sl()));
  sl.registerFactory(() => ResendOtpBloc(resendOTPUsecase: sl()));
  sl.registerFactory(() => ForgotPasswordBloc(forgotPasswordUsecase: sl()));
  sl.registerFactory(() => OtpBloc(verifyOtpUseCase: sl()));
  sl.registerFactory(
      () => GoogleAuthenticationBloc(googleAuthenticationaUsecase: sl()));
  sl.registerFactory(() => ChangePasswordBloc(changePasswordUsecase: sl()));
  sl.registerFactory(() => GetAllPostsBloc(getAllPostsUsecase: sl()));
  sl.registerFactory(() => UploadPostBloc(uploadPostUsecase: sl()));
  sl.registerFactory(() => ReportPostBloc(reportPostUsecase: sl()));
  sl.registerFactory(() => FeedbackBloc(feedbackUsecase: sl()));
  sl.registerFactory(() => GetPostByIdBloc(getPostByIdUsecase: sl()));
  sl.registerFactory(
      () => GetCommentsByPostIdBloc(getCommentsByPostIdUsecase: sl()));
  sl.registerFactory(() => UpdateLocationBloc(updateLocationUsecase: sl()));
  sl.registerFactory(() => DeletePostBloc(deletePostUsecase: sl()));
  sl.registerFactory(() => UploadFileBloc(uploadFileUsecase: sl()));
  sl.registerFactory(() => AddCommentBloc(addCommentUsecase: sl()));
  sl.registerFactory(() => VotePollBloc(votePollUsecase: sl()));
  sl.registerFactory(
      () => FetchCommentReplyBloc(fetchCommentReplyUsecase: sl()));
  sl.registerFactory(() => GiveAwardBloc(giveAwardUsecase: sl()));
  sl.registerFactory(() => GetGenderAndDOBBloc(getGenderAndDOBUsecase: sl()));
  sl.registerFactory(() => GetProfileBloc(getProfileUsecase: sl()));
  sl.registerFactory(() => LogoutBloc(logoutUsecase: sl()));
  sl.registerFactory(() => GetMyPostsBloc(getMyPostsUsecase: sl()));
  sl.registerFactory(() => SendFeedbackBloc(sendFeedbackUsecase: sl()));
  sl.registerFactory(() => DeleteAccountBloc(deleteAccountUsecase: sl()));
  sl.registerFactory(() => GetUserInfoBloc(getUserInfoUsecase: sl()));
  sl.registerFactory(() => GetMyCommentsBloc(getMyCommentsUsecase: sl()));
  sl.registerFactory(() => GetMyGroupsBloc(getMyGroupsUsecase: sl()));
  sl.registerFactory(() => EditProfileBloc(editProfileUsecase: sl()));

  // register network info
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
        InternetConnectionChecker(),
      ));
}

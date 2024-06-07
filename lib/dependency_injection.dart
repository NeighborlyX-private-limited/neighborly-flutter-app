import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:neighborly_flutter_app/core/network/network_info.dart';
import 'package:neighborly_flutter_app/features/authentication/data/data_sources/auth_remote_data_source/auth_remote_data_source.dart';
import 'package:neighborly_flutter_app/features/authentication/data/data_sources/auth_remote_data_source/auth_remote_data_source_impl.dart';
import 'package:neighborly_flutter_app/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/usecases/fogot_password_usecase.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/usecases/login_with_email_usecase.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/usecases/resend_otp_usecase.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/usecases/signup_with_email_usecase.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/usecases/verify_otp_usecase.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/fogot_password_bloc/forgot_password_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/resend_otp_bloc/resend_otp_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/login_with_email_bloc/login_with_email_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/register_with_email_bloc/register_with_email_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/verify_otp_bloc/verify_otp_bloc.dart';

final sl = GetIt.instance;

void init() async {
  // register usecase
  sl.registerLazySingleton(() => SignupWithEmailUsecase(sl()));
  sl.registerLazySingleton(() => LoginWithEmailUsecase(sl()));
  sl.registerLazySingleton(() => ResendOTPUsecase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUsecase(sl()));
  sl.registerLazySingleton(() => VerifyOTPUsecase(sl()));

  // register repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  // register datasource
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: sl()));

  // register bloc
  sl.registerFactory(() => RegisterWithEmailBloc(registerUseCase: sl()));
  sl.registerFactory(() => LoginWithEmailBloc(loginUseCase: sl()));
  sl.registerFactory(() => ResendOtpBloc(resendOTPUsecase: sl()));
  sl.registerFactory(() => ForgotPasswordBloc(forgotPasswordUsecase: sl()));
  sl.registerFactory(() => OtpBloc(verifyOtpUseCase: sl()));

  // register network info
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
        InternetConnectionChecker(),
      ));
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/routes/routes.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/fogot_password_bloc/forgot_password_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/google_authentication_bloc/google_authentication_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/resend_otp_bloc/resend_otp_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/login_with_email_bloc/login_with_email_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/register_with_email_bloc/register_with_email_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/bloc/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/get_all_posts_bloc/get_all_posts_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_password_bloc/change_password_bloc.dart';
import 'dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  await ShardPrefHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<RegisterWithEmailBloc>(
            create: (context) => di.sl<RegisterWithEmailBloc>(),
          ),
          BlocProvider<LoginWithEmailBloc>(
            create: (context) => di.sl<LoginWithEmailBloc>(),
          ),
          BlocProvider<ResendOtpBloc>(
            create: (context) => di.sl<ResendOtpBloc>(),
          ),
          BlocProvider<ForgotPasswordBloc>(
            create: (context) => di.sl<ForgotPasswordBloc>(),
          ),
          BlocProvider<OtpBloc>(
            create: (context) => di.sl<OtpBloc>(),
          ),
          BlocProvider<GoogleAuthenticationBloc>(
            create: (context) => di.sl<GoogleAuthenticationBloc>(),
          ),
          BlocProvider<ChangePasswordBloc>(
            create: (context) => di.sl<ChangePasswordBloc>(),
          ),
          BlocProvider<GetAllPostsBloc>(
            create: (context) => di.sl<GetAllPostsBloc>(),
          ),
        ],
        child: MaterialApp.router(
          theme: ThemeData(
            fontFamily: 'Roboto',
          ),
          debugShowCheckedModeBanner: false,
          title: 'Neighborly App',
          routerConfig: router,
        ));
  }
}

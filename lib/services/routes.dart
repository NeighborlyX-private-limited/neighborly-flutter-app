import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/app_routes.dart';
import 'package:flutter_application_1/view/screens/auth/controller/login_controller.dart';
import 'package:flutter_application_1/view/screens/auth/view/login_using_email.dart';
import 'package:flutter_application_1/view/screens/auth/controller/register_controller.dart';
import 'package:flutter_application_1/view/screens/auth/view/join_neighborly.dart';
import 'package:flutter_application_1/view/screens/auth/view/signup_using_email.dart';
import 'package:flutter_application_1/view/screens/dashboard/view/home.dart';
import 'package:get/get.dart';


class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return GetPageRoute(page: () => LoginScreen(), binding: BindingsBuilder(() => Get.lazyPut(() => LoginController())));
      case AppRoutes.register:
        return GetPageRoute(page: () => RegisterScreen(), binding: BindingsBuilder(() => Get.lazyPut(() => RegisterController())));
      case AppRoutes.home:
        return GetPageRoute(page: () => HomeScreen());
      case AppRoutes.reg:
        return GetPageRoute(page: () => RegScreen());
      default:
        return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'view/screens/auth/view/signup.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/app_routes.dart';
import 'package:flutter_application_1/view/screens/auth/view/signup.dart';
import 'package:flutter_application_1/view/screens/auth/view/login.dart';
import 'package:flutter_application_1/view/screens/auth/controller/login_controller.dart';
import 'package:flutter_application_1/view/screens/auth/controller/register_controller.dart';
import 'package:flutter_application_1/view/screens/dashboard/view/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'flutter_application_1',
      initialRoute: AppRoutes.login,
      getPages: [
        GetPage(name: AppRoutes.login, page: () => LoginScreen(), binding: BindingsBuilder(() => Get.lazyPut(() => LoginController()))),
        GetPage(name: AppRoutes.register, page: () => RegisterScreen(), binding: BindingsBuilder(() => Get.lazyPut(() => RegisterController()))),
        GetPage(name: AppRoutes.home, page: () => HomeScreen()),
      ],
    );
  }
}
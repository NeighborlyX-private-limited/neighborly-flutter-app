import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/routes.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
      title: 'flutter_application_1',
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}


      // getPages: [
      //   GetPage(name: AppRoutes.login, page: () => LoginScreen(), binding: BindingsBuilder(() => Get.lazyPut(() => LoginController()))),
      //   GetPage(name: AppRoutes.register, page: () => RegisterScreen(), binding: BindingsBuilder(() => Get.lazyPut(() => RegisterController()))),
      //   GetPage(name: AppRoutes.home, page: () => HomeScreen()),
      //   GetPage(name: AppRoutes.reg, page: () => RegScreen()),
      // ],

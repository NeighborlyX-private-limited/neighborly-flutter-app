import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/services/app_routes.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        Get.offNamed(AppRoutes.home);
      } else {
        Get.offNamed(AppRoutes.reg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:const Center( 
          child: Text(
          'Welcome to Neigbhorly',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),),
    );
  }
}


























// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_application_1/services/app_routes.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatefulWidget {
//   final bool isLoggedIn;

//   const SplashScreen({Key? key, required this.isLoggedIn}) : super(key: key);

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     Timer(Duration(seconds: 3), () async {
//       final prefs = await SharedPreferences.getInstance();
//       final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//       if (isLoggedIn) {
//         Get.offNamed(AppRoutes.home);
//       } else {
//         Get.offNamed(AppRoutes.login);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child:const Center( 
//           child: Text(
//           'Welcome to MyApp',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),),
//     );
//   }
// }

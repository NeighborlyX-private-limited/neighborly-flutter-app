import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/screen/Signup/signup.dart';
void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'flutter_application_1',
      home: SignupScreen(),
    );
  }
}
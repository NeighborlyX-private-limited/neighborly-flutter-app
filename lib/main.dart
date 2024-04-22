import 'package:flutter/material.dart';
import 'view/screens/auth/view/signup.dart';
import 'package:get/get.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'flutter_application_1',
      home: SignupScreen(),
    );
  }
}

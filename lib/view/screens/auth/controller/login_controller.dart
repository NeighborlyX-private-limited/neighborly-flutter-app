import 'dart:convert';
//import 'dart:js';


import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dashboard/view/home.dart';

import 'package:dio/dio.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

@override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final response = await Dio().post(
        'http://3.88.42.34/api/user/login',
        data: {'userId': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = response.data;
      if (response.statusCode == 200) {
        final token = data['token'];
        final userName = data['username']; 
        await saveToken(token);
        Get.offNamed('/home');
      } else {
        Get.snackbar('Login Failed', 'Invalid email or password',
            snackPosition: SnackPosition.BOTTOM);
        throw jsonDecode(response.data)["Message"] ?? "Unknown Error occurred";
      }
    } catch (e) {
      print(e.toString());
    }
  }

  

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Get.offNamed('/home');
    }
  }
  // Future<void> logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isLoggedIn', false);
  //   Get.offNamed('/login');
  // }
}

//   Future<void> login() async {
//     final email = emailController.text;
//     final password = passwordController.text;

//     try {
//       final response = await Dio().post(
//         'http://3.88.42.34/api/user/login',
//         data: {'userId': email, 'password': password},
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );

//       final data = response.data;
//       if (response.statusCode == 200) {
//         final token = data['token'];
//         final userName = data['username']; 
//         await saveToken(token);
//         // Handle successful login
//         Get.offNamed('/home');
//       } else {
//         // Handle login failure
//         //print("galat hai");
//         throw jsonDecode(response.data)["Message"] ?? "Unknown Error occurred";
//       }
//     } catch (e) {
//       // Handle Dio error
//       print(e.toString());
//     }
//   }

//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('token', token);
//   }

// }
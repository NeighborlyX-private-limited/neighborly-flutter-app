import 'dart:convert';
//import 'dart:developer';
//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../dashboard/view/home.dart';

import 'package:dio/dio.dart';

class RegisterController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> register() async {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    try {
      final response = await Dio().post(
        'http://34.207.25.173/api/user/register',
        data: {'email': email, 'password': password, 'confirm_password': confirmPassword},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        Get.offNamed('/login');
      } else {
        // Handle registration failure
        //print("ye sahi nahi");
        throw jsonDecode(response.data)["Message"] ?? "Unknown Error occurred";
      }
    } catch (e) {
      // Handle Dio error
      print(e.toString());
    }
  }
}

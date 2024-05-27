//'http://3.87.94.1/api/user/google/oauth
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final token = googleSignInAuthentication.accessToken;

    final response = await Dio().post(
      'http://3.87.94.1/api/user/google/oauth',
      data: {'token': token},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final token = data['token'];
      final userName = data['username'];

      await saveToken(token);
      Get.offNamed('/home');
    } else {
      Get.snackbar('Login Failed', 'Failed to sign in with Google',
          snackPosition: SnackPosition.BOTTOM);
      throw 'Failed to sign in with Google';
    }
  } catch (error) {
    Get.snackbar('Error', 'An error occurred while signing in with Google',
        snackPosition: SnackPosition.BOTTOM);
    print('Error: $error');
  }
}

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  await prefs.setBool('isLoggedIn', true);
}

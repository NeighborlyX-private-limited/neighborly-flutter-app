import 'dart:convert';
import 'dart:developer';
//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../dashboard/view/home.dart';

class RegistrationController extends GetxController {
  //TextEditingController nameController=TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> registerWithEmail() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.registerEmail);
      Map body = {
        //'name': nameController.text,
        'email': emailController.text.trim(),
        'password': passwordController.text
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['code'] == 0) {
          var token = json['data']['Token'];
          log("$token");
          final SharedPreferences prefs = await _prefs;
          await prefs.setString('token', token);
          //nameController.clear();
          emailController.clear();
          passwordController.clear();
          Get.off(const HomeScreen());
        } else {
          throw jsonDecode(response.body)["Message"] ??
              "Unknown Error occurred";
        }
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Unknown Error occurred";
      }
    } catch (e) {
      Get.back();
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Error'),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(e.toString())],
          );
        },
      );
    }
  }
}

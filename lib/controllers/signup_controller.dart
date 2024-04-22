import 'dart:convert';
//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/Home/home.dart';
import 'package:flutter_application_1/utils/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterationController extends GetxController{
  //TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  final Future<SharedPreferences> _prefs= SharedPreferences.getInstance();

  Future<void> registerwithEmail() async{
    try{
      var headers={'Content-Type': 'application/json' };
      var url = Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.registerEmail);
      Map body= {
        //'name': nameController.text,
        'email':emailController.text.trim(),
        'password':passwordController.text
      };
      http.Response response=
        await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200){
        final json= jsonDecode(response.body);
        if (json['code'] == 0){
          var token =json['data']['Token'];
          print(token);
          final SharedPreferences? prefs = await _prefs;

          await prefs?.setString('token', token);
          //nameController.clear();
          emailController.clear();
          passwordController.clear();
          Get.off(HomeScreen());
        }else {
          throw jsonDecode(response.body)["Message"]?? "Unknown Error occured";
        }

      }else {
        throw jsonDecode(response.body)["Message"]?? "Unknown Error occured";
      }
    } catch(e){
      Get.back();
      showDialog(context: Get.context!, 
      builder: (context){
        return SimpleDialog(
          title: Text('Error'),
          contentPadding: EdgeInsets.all(20),
          children: [Text(e.toString())],
        );
      });
    }
  }
}

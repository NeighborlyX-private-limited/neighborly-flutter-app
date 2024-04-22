//import 'dart:html';

import 'package:flutter_application_1/screen/Signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';



class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}) : super(key:key);

  @override
  State<HomeScreen> createState()=> _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(actions: [ 
    TextButton(
      onPressed: () async {
        final SharedPreferences? prefs= await _prefs; 
        prefs?.clear();
        Get.offAll(SignupScreen());
      },
      child: Text(
            'logout',
            style: TextStyle(color: Colors.white),
      ),
      ),
  ],
  ), 
  body: Center(
  child: Column(
  children: [
    Text('Welcome home'),
  TextButton(
  onPressed: () async {
    final SharedPreferences? prefs= await _prefs; 
    print(prefs?.get("token"));
  },
  child: Text("print token"),
  )
        ],
      ),  
    ), 
  ); 
}
}
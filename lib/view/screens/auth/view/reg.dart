import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/app_routes.dart';

class RegScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Login using Google
              },
              child: Text('Login using Google'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.register);
              },
              child: Text('Login with Email'),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField( 
                decoration: InputDecoration(
                  hintText: 'Enter Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Send OTP logic
              },
              child: Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

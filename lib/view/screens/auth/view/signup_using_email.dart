import 'package:flutter/material.dart';

import 'package:get/get.dart';

//import '../controller/login_controller.dart';
import '../controller/register_controller.dart';
//import '../widgets/login_widgets.dart';
import 'package:flutter_application_1/services/app_routes.dart';
import 'package:flutter_application_1/custom_widgets/input_fields.dart';



class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text('Register')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
                    child: FlutterLogo(
                      size: 40,
                    ),
                  ),
            MyTextField(
                controller: controller.emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              MyTextField(
                controller: controller.passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              MyTextField(
                controller: controller.confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
            //TextField(controller: controller.emailController, decoration: InputDecoration(labelText: 'Email')),
            //TextField(controller: controller.passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            //TextField(controller: controller.confirmPasswordController, decoration: InputDecoration(labelText: 'Confirm Password'), obscureText: true),
            ElevatedButton(onPressed: controller.register, child: Text('Register')),
            TextButton(
              onPressed: () {
                Get.toNamed(AppRoutes.login);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_application_1/custom_widgets/custom_appbar.dart';
import 'package:flutter_application_1/custom_widgets/submit_button.dart';

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
      //backgroundColor: Colors.grey[300],
      appBar: CustomAppBar(
        titleWidget: Container(
          height: 50,
          child: Image.asset('assets/images/neighborly_logo.jpg'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start ,
          children: [
            const Divider(),
            const SizedBox(
              height: 24,
            ),
            Container(
                    padding: const EdgeInsets.fromLTRB(15, 0, 20, 30),
                    width: 100,
                    height: 100,
                    child: Image.asset('assets/images/side_email_logo.png')
                  ),
                  Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child:Container( 
              child: const Text(
              'Continue with Email',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontFamily: 'Roboto',//'Jacquard',
                fontWeight: FontWeight.w600,
              ),
              )
            )
            ),
            const SizedBox(
                height: 12,
              ),
            MyTextField(
                controller: controller.emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(
                height: 12,
              ),
              MyTextField(
                controller: controller.passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(
                height: 12,
              ),
              MyTextField(
                controller: controller.confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(
                height: 40,
              ),
              SubmitButton(
                title: 'Register',
                onPressed: controller.register),
            //ElevatedButton(onPressed: controller.register, child: Text('Register')),
           Center(
            child:  TextButton(
              onPressed: () {
                Get.toNamed(AppRoutes.login);
              },
              child: const Text('Login'),
            ),
           ),
          ],
        ),
      ),
      )
    );
  }
}
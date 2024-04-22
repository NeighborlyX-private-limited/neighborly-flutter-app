import 'package:flutter/material.dart';

import 'package:flutter_application_1/controllers/login_controller.dart';
import 'package:flutter_application_1/controllers/signup_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/Widget/input_fields.dart';
import 'package:flutter_application_1/Widget/submit_button.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupState();
}

class _SignupState extends State<SignupScreen> {
  RegisterationController registrationController =
      Get.put(RegisterationController());

  LoginController loginController = Get.put(LoginController());

  var isLogin = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(

          padding: EdgeInsets.all(36),
          child:   Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Container(
                    child: Text(
                      'Neighbourly',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: !isLogin.value ? Colors.white : Colors.amber,
                        onPressed: () {
                          isLogin.value = true;
                        },
                        child: Text('Register/Login'),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  isLogin.value ? loginWidget() : registerWidget()
                ],
              ),
            ),
          ),

      ),
    );
  }

}

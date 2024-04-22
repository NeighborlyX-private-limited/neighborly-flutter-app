import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controller/login_controller.dart';
import '../controller/signup_controller.dart';
import '../widgets/login_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupState();
}

class _SignupState extends State<SignupScreen> {
  RegistrationController registrationController =
      Get.put(RegistrationController());

  LoginController loginController = Get.put(LoginController());

  var isLogin = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(36),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Neighbourly',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    color: !isLogin.value ? Colors.white : Colors.amber,
                    onPressed: () {
                      isLogin.value = true;
                    },
                    child: const Text('Register/Login'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              isLogin.value
                  ? LoginWidgets.loginWidget(loginController)
                  : LoginWidgets.registerWidget(registrationController)
            ],
          ),
        ),
      ),
    );
  }
}

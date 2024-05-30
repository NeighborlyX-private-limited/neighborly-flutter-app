import 'package:flutter/material.dart';
import 'package:flutter_application_1/custom_widgets/submit_button.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/app_routes.dart';
import '../controller/login_controller.dart';
import 'package:flutter_application_1/custom_widgets/input_fields.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          height: 50,
          child: Image.asset('assets/images/neighborly_logo.jpg'),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Divider(),
            Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                width: 100,
                height: 100,
                child: Image.asset('assets/images/side_email_logo.png')),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                    child: const Text(
                  'Continue with Email',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontFamily: 'Roboto', //'Jacquard',
                    fontWeight: FontWeight.w600,
                  ),
                ))),
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
              height: 40,
            ),
            SubmitButton(title: 'Login', onPressed: controller.login),
            // Container(
            //   height: 40,
            //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            // child: ElevatedButton(style: ElevatedButton.styleFrom(
            //     minimumSize: const Size.fromHeight(50),
            //   ),onPressed: controller.login,
            //child: const Text('Login')),),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.register);
                },
                child: Text('Register'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

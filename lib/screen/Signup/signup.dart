
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/controllers/login_controller.dart';
import 'package:flutter_application_1/controllers/signup_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/Widget/input_fields.dart';
import 'package:flutter_application_1/Widget/submit_button.dart';

class SignupScreen extends StatefulWidget{
  @override
  State<SignupScreen> createState()=> _SignupState();

}

class _SignupState extends State<SignupScreen>{
  RegisterationController registerationController = Get.put(RegisterationController());

  LoginController loginController = Get.put(LoginController());

  var isLogin = false.obs;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child:  Padding(padding: EdgeInsets.all(36),
        child: Center(
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              Container(child:Text('Neighbourly', style: TextStyle(fontSize: 30, 
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400),
                                  ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              color: !isLogin.value? Colors.white: Colors.amber,
                              onPressed: (){
                                isLogin.value= true;
                              },
                              child: Text('Register/Login'),)
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        isLogin.value? loginWidget(): registerWidget()
            ]
          ),
          ),
        ),
        ),
      ),
    );
  }

Widget registerWidget() {
return Column(
children: [
// InputTextFieldWidget(registerationController.nameController, "name"),
// SizedBox(
//   height: 20,
// ),
InputTextFieldWidget(
  registerationController.emailController, 'email address'), // InputTextFieldWidget
SizedBox(
  height: 20,
),
InputTextFieldWidget(registerationController.passwordController, 'password'), // InputTextFieldWidget
SizedBox(
  height: 20,
),
SubmitButton(
onPressed: () => registerationController.registerwithEmail(),
title: 'Register',
) // SubmitButton
],
);
}

Widget loginWidget(){
  return Column(
    children: [
    SizedBox(
      height: 20,
),
InputTextFieldWidget(
  loginController.emailController, 'email address'), // InputTextFieldWidget
SizedBox(
  height: 20,
),
InputTextFieldWidget(loginController.passwordController, 'password'), // InputTextFieldWidget
SizedBox(
  height: 20,
),
SubmitButton(
onPressed: () => loginController.loginwithEmail(),
title: 'Login',
) // SubmitButton
],
);
}
}
import 'package:flutter/cupertino.dart';

import '../../../../custom_widgets/input_fields.dart';
import '../../../../custom_widgets/submit_button.dart';
import '../controller/login_controller.dart';
import '../controller/signup_controller.dart';

class LoginWidgets {
  static Widget registerWidget(RegistrationController registrationController) {
    return Column(
      children: [
// InputTextFieldWidget(registrationController.nameController, "name"),
// SizedBox(
//   height: 20,
// ),
        InputTextFieldWidget(
          registrationController.emailController,
          'email address',
        ),
        const SizedBox(height: 20),
        InputTextFieldWidget(
          registrationController.passwordController,
          'password',
        ),
        const SizedBox(height: 20),
        SubmitButton(
          onPressed: () => registrationController.registerWithEmail(),
          title: 'Register',
        )
        // SubmitButton
      ],
    );
  }

  static Widget loginWidget(LoginController loginController) {
    return Column(
      children: [
        const SizedBox(height: 20),
        InputTextFieldWidget(
          loginController.emailController,
          'email address',
        ),
        const SizedBox(height: 20),
        InputTextFieldWidget(
          loginController.passwordController,
          'password',
        ),
        const SizedBox(height: 20),
        SubmitButton(
          onPressed: () => loginController.loginWithEmail(),
          title: 'Login',
        )
        // SubmitButton
      ],
    );
  }
}

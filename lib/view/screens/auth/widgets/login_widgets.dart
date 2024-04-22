class LoginWidgets {
  static Widget registerWidget() {
    return Column(
      children: [
// InputTextFieldWidget(registerationController.nameController, "name"),
// SizedBox(
//   height: 20,
// ),
        InputTextFieldWidget(
          registerationController.emailController,
          'email address',
        ),
        // InputTextFieldWidget
        SizedBox(height: 20),
        InputTextFieldWidget(
          registerationController.passwordController,
          'password',
        ),
        // InputTextFieldWidget
        SizedBox(height: 20),
        SubmitButton(
          onPressed: () => registerationController.registerwithEmail(),
          title: 'Register',
        )
        // SubmitButton
      ],
    );
  }

  static Widget loginWidget() {
    return Column(
      children: [
        SizedBox(height: 20),
        InputTextFieldWidget(
          loginController.emailController,
          'email address',
        ),
        // InputTextFieldWidget
        SizedBox(height: 20),
        InputTextFieldWidget(
          loginController.passwordController,
          'password',
        ),
        // InputTextFieldWidget
        SizedBox(height: 20),
        SubmitButton(
          onPressed: () => loginController.loginwithEmail(),
          title: 'Login',
        )
        // SubmitButton
      ],
    );
  }
}

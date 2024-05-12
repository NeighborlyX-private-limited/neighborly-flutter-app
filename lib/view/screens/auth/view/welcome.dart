import "package:flutter/material.dart";
import "package:flutter_application_1/custom_widgets/submit_button.dart";

class WelcomeScreen extends StatelessWidget {
  join() {
    print("hello");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SubmitButton(
          onPressed: () {
            join();
          },
          title: "Hello",
        ),
      ),
    );
  }
}


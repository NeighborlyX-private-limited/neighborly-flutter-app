import "package:flutter/material.dart";
import "package:flutter_application_1/custom_widgets/submit_button.dart";



class WelcomeScreen extends StatelessWidget {
  void Join (){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      
      SubmitButton(
  onPressed: (){
    Join(); },
  title: "Hello",
),
    );
}
}
import 'package:flutter/material.dart';
import 'package:flutter_application_1/custom_widgets/custom_outlined_button.dart';
import 'package:flutter_application_1/custom_widgets/submit_button.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/app_routes.dart';

class RegScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50,
          child: Image.asset('assets/images/neighborly_logo.jpg'),
        ),
        centerTitle: true,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ), 
            Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child:Container(
              child: const Center( 
              child: Text(
              'Join Neighborly',
              style: TextStyle(
                fontSize: 45,
                color: Colors.black,
              ),
              )
              )
            )
            ),
            const SizedBox(
              height: 70,
            ),
            SubmitButton(
            onPressed: () {
              Get.toNamed(AppRoutes.register);
            },
            icon: const Icon(Icons.play_arrow),
          title: "Continue with Google",
        ),
        // const SizedBox(
        //   height: 20,
        // ),
        Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child:Container(
          width: double.maxFinite,
          height: 48,
        child: CustomButton(
          icon: const Icon(Icons.play_arrow),
          title: "Continue with  Email",
          bgColor: Colors.black,
          textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
          onPressed: (){
            Get.toNamed(AppRoutes.register);
          }),
        ),
        ),
            // ElevatedButton(
            //   onPressed: () {
            //     // Login using Google
            //   },
            //   child: Text('Login using Google'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     Get.toNamed(AppRoutes.register);
            //   },
            //   child: Text('Login with Email'),
            // ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              children:[
                Expanded(
                  child: Divider(
                    indent: 10,
                    endIndent: 5,
                  )),
                  Text("or"),
                  Expanded(
                    child: Divider(
                      indent: 5,
                      endIndent: 10,
                    )),
                    ]
                    ),
            Container(
              padding: EdgeInsets.all(10),
              child: const TextField( 
                decoration: InputDecoration(
                  hintText: 'Enter Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Send OTP logic
              },
              child: Text('Send OTP'),
            ),
          ],
        ),
      );
  }
}

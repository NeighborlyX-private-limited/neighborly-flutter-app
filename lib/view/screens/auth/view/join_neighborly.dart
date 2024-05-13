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
            const Divider(),
            const SizedBox(
              height: 40,
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
              height: 40,
            ),
            SubmitButton(
            onPressed: () {
              Get.toNamed(AppRoutes.register);
            },
            iconImagePath: 'assets/images/continue_with_google_logo.png',
          title: "Continue with Google",
          textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
        ),
        const SizedBox(
          height: 8,
        ),
        SubmitButton(
            onPressed: () {
              Get.toNamed(AppRoutes.register);
            },
            iconImagePath: 'assets/images/continue_with_email_logo.png',
          title: "Continue with Email",
          textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
        ),
      //   Padding(
      // padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      //   child:Container(
      //     width: double.maxFinite,
      //     height: 48,
      //   child: CustomButton(
      //     icon: const Icon(Icons.play_arrow),
      //     title: "Continue with  Email",
      //     bgColor: Colors.black,
      //     textStyle: const TextStyle(
      //           fontSize: 16,
      //           color: Colors.white,
      //         ),
      //     onPressed: (){
      //       Get.toNamed(AppRoutes.register);
      //     }),
      //   ),
      //   ),
            const SizedBox(
              height: 24,
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
            const SizedBox(
              height: 24,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: const TextField( 
                decoration: InputDecoration(
                  hintText: 'Enter Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
             SubmitButton(
            onPressed: () {
              Get.toNamed(AppRoutes.reg);
            },
          title: "Continue",
          bgColor: const Color.fromRGBO(61, 61, 61, 1),
          textStyle: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(204, 204, 204, 1),
              ),
        ),
            // ElevatedButton(
            //   onPressed: () {
            //     // Send OTP logic
            //   },
            //   child: Text('Send OTP'),
            // ),
            const SizedBox(
              height: 32,
            ),
             Padding(
              padding:  const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child:Container(
              child:  Center( 
              child: RichText(
                textAlign: TextAlign.left,
                text: const TextSpan(
                  text: '\nBy clicking the above button and creating an account, you have read and accepted the Terms of Service and acknowledged our Privacy Policy',
                style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(102, 102, 102, 1),
              ),
              )
              )
              )
              )
              ),

          ],
        ),
      );
  }
}

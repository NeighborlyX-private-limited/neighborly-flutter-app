import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/view/signup.dart';
import 'package:flutter_application_1/view/screens/auth/controller/login_controller.dart';


import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.setBool('isLoggedIn', false);
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Text('Welcome to the Home Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: logout,
        child: Icon(Icons.logout),
      ),
    );
  }
}
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        appBar: AppBar(
//         title: Text('Home Page'),
//         actions: [
//           PopupMenuButton(
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 child: Text('Logout'),
//                 onTap: () async {
//                   await controller.logout();
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Center(
//         child: Text('Welcome home'),
//       ),
//     );
//   }
// }
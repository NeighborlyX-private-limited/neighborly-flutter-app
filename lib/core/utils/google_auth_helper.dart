import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      print('start login signup');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('start login signup $googleUser');

      if (googleUser == null) {
        print('here googleUser');
        return {'error': 'User cancelled sign in'};
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print("here  in googleAuth");
      String fcmToken = ShardPrefHelper.getFCMtoken() ?? '';
      print("fcmToken in Oauth: $fcmToken ");
      return {
        'idToken': googleAuth.idToken,
        'accessToken': googleAuth.accessToken,
        'fcmToken': fcmToken,
      };
    } catch (e) {
      print("here error in catch");
      debugPrint(e.toString());
      return Future.error(e);
    }
  }
}

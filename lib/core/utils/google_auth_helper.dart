import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return {'error': 'User cancelled sign in'};
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    return {
      'idToken': googleAuth.idToken,
      'accessToken': googleAuth.accessToken,
    };
  }
}

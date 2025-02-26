import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Ensure a fresh login by signing out first
      await _googleSignIn.signOut();

      // Check if user is signed in before calling disconnect()
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('GOOGLE USER :$googleUser');

      if (googleUser == null) {
        return {'error': 'User cancelled sign-in'};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('GOOGLE AUTH: $googleAuth');

      return {
        'idToken': googleAuth.idToken,
      };
    } catch (e) {
      print("Google Sign-In Error: $e");
      return {'error': e.toString()};
    }
  }

  static Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
    } catch (e) {
      print("Error during sign-out: $e");
    }
  }
}

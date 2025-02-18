// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

// class GoogleSignInService {
//   static final GoogleSignIn _googleSignIn = GoogleSignIn(
//     signInOption: SignInOption.standard,
//     scopes: ['email', 'profile'],
//     hostedDomain: "", // Ensure it works for all Google accounts
//     // clientId: "YOUR_CLIENT_ID_HERE", // If using a web client ID
//     // forceSignIn: true, // **This might help**
//   );
//   // static final GoogleSignIn _googleSignIn = GoogleSignIn(
//   //   scopes: ['email', 'profile'],
//   // );
//   GoogleSignInService().signOutGoogle();
//   static Future<Map<String, dynamic>> signInWithGoogle() async {
//     try {
//       // await _googleSignIn.signOut();
//       // await _googleSignIn.disconnect();

//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       print('GOOGLE USER:$googleUser');

//       if (googleUser == null) {
//         return {'error': 'User cancelled sign in'};
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       print('GOOGLE AUTH:$googleUser');

//       String fcmToken = ShardPrefHelper.getFCMtoken() ?? '';

//       return {
//         'idToken': googleAuth.idToken,
//         'accessToken': googleAuth.accessToken,
//         'fcmToken': fcmToken,
//       };
//     } catch (e) {
//       return Future.error(e);
//     }
//   }

//   static Future<void> signOutGoogle() async {
//     try {
//       // Step 1: Check if user is signed in
//       bool isSignedIn = await _googleSignIn.isSignedIn();

//       if (isSignedIn) {
//         // Step 2: Disconnect to remove OAuth permissions
//         await _googleSignIn.disconnect();
//       }

//       // Step 3: Sign out to clear session
//       await _googleSignIn.signOut();

//       print("User successfully signed out");
//     } catch (e) {
//       print("Error during sign out: $e");
//     }
//   }
// }

import 'package:google_sign_in/google_sign_in.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
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
      print('GOOGLE USER: $googleUser');

      if (googleUser == null) {
        return {'error': 'User cancelled sign-in'};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('GOOGLE AUTH: $googleAuth');

      String fcmToken = ShardPrefHelper.getFCMtoken() ?? '';

      return {
        'idToken': googleAuth.idToken,
        'accessToken': googleAuth.accessToken,
        'fcmToken': fcmToken,
      };
    } catch (e) {
      print("Google Sign-In Error: $e");
      return {'error': e.toString()};
    }
  }

  static Future<void> signOutGoogle() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }

      await _googleSignIn.signOut();
      print("User successfully signed out");
    } catch (e) {
      print("Error during sign-out: $e");
    }
  }
}

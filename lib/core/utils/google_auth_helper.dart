import 'package:google_sign_in/google_sign_in.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
     

      if (googleUser == null) {
       
        return {'error': 'User cancelled sign in'};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      

      String fcmToken = ShardPrefHelper.getFCMtoken() ?? '';
      

      return {
        'idToken': googleAuth.idToken,
        'accessToken': googleAuth.accessToken,
        'fcmToken': fcmToken,
      };
    } catch (e) {
      
      return Future.error(e);
    }
  }
}

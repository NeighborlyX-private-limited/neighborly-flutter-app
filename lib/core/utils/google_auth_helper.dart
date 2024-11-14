import 'package:google_sign_in/google_sign_in.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      print('start signInWithGoogle in GoogleSignInService...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('googleUser: $googleUser');

      if (googleUser == null) {
        print('googleUser is null...');
        return {'error': 'User cancelled sign in'};
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print("googleAuth: $googleUser");
      String fcmToken = ShardPrefHelper.getFCMtoken() ?? '';
      print("fcmToken in Oauth: $fcmToken ");
      return {
        'idToken': googleAuth.idToken,
        'accessToken': googleAuth.accessToken,
        'fcmToken': fcmToken,
      };
    } catch (e) {
      print("catch error in signInWithGoogle... ${e.toString()}");
      return Future.error(e);
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/utils/google_auth_helper.dart';
import '../../../../../core/utils/shared_preference.dart';
import '../../models/auth_response_model.dart';
import 'auth_remote_data_source.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  /// loginWithEmail function
  @override
  Future<AuthResponseModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    print('.....start login with');
    print('email: $email');
    print('password: $password');

    String url = '$kBaseUrl/authentication/login';
    print('url: $url');

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'userId': email,
        'password': password,
      }),
    );

    print('...login response status code: ${response.statusCode}');
    print('...login response: ${response.body}');

    if (response.statusCode == 200) {
      final jwtToken = response.headers['authorization'] ?? '';
      print('yes this token:$jwtToken');

      /// Assuming the response headers contain the Set-Cookie header
      /// extract data from response
      List<String> cookies = response.headers['set-cookie']?.split(',') ?? [];
      String accessToken = jsonDecode(response.body)['refreshToken'];
      String refreshToken = jsonDecode(response.body)['refreshToken'];
      String userID = jsonDecode(response.body)['user']['_id'];
      String proPic = jsonDecode(response.body)['user']['picture'];
      String username = jsonDecode(response.body)['user']['username'];
      String? email = jsonDecode(response.body)['user']['email'];
      String gender = jsonDecode(response.body)['user']['gender'] ?? 'Male';
      bool isDobSet = jsonDecode(response.body)['user']['dobSet'];
      List<dynamic> homeLocation =
          jsonDecode(response.body)['user']['home_coordinates']['coordinates'];
      List<dynamic> location = jsonDecode(response.body)['user']
          ['current_coordinates']['coordinates'];
      bool isSkippedTutorial =
          jsonDecode(response.body)['user']['skippedTutorial'];
      bool isViewedTutorial =
          jsonDecode(response.body)['user']['viewedTutorial'];
      String authType = jsonDecode(response.body)['user']['auth_type'];
      bool isVerified = jsonDecode(response.body)['user']['isVerified'];

      /// set data to local
      ShardPrefHelper.setJwtToken(jwtToken);
      ShardPrefHelper.setCookie(cookies);
      ShardPrefHelper.setAccessToken(accessToken);
      ShardPrefHelper.setRefreshToken(refreshToken);
      ShardPrefHelper.setUserID(userID);
      ShardPrefHelper.setUserProfilePicture(proPic);
      ShardPrefHelper.setUsername(username);
      ShardPrefHelper.setEmail(email ?? '');
      ShardPrefHelper.setGender(gender);
      ShardPrefHelper.setDob(isDobSet);
      ShardPrefHelper.setIsEmailLogin(true);
      ShardPrefHelper.setHomeLocation([homeLocation[0], homeLocation[1]]);
      ShardPrefHelper.setLocation([location[0], location[1]]);
      ShardPrefHelper.setIsSkippedTutorial(isSkippedTutorial);
      ShardPrefHelper.setIsViewedTutorial(isViewedTutorial);
      ShardPrefHelper.setAuthtype(authType);
      ShardPrefHelper.setIsVerified(isVerified);

      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      print("login error: ${jsonDecode(response.body)['message']}");
      String error =
          jsonDecode(response.body)['message'] ?? 'Something went wrong';
      throw ServerException(message: error);
    }
  }

  /// resendOtp function
  @override
  Future<String> resendOtp({
    String? email,
    String? phone,
  }) async {
    print('.....start resendOtp with');
    print('email: $email');
    print('phone: $phone');

    String urlForEmail = '$kBaseUrl/authentication/send-otp';
    String urlForPhone = '$kBaseUrl/authentication/send-phone-otp';
    print('urlForEmail:  $urlForEmail');
    print('urlForPhone: $urlForPhone');

    final response = await client.post(
      Uri.parse(email != null ? urlForEmail : urlForPhone),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: email != null
          ? jsonEncode(<String, String>{
              'email': email,
            })
          : jsonEncode(<String, String>{
              'phoneNumber': phone!,
            }),
    );
    print('resendOtp response status code :${response.statusCode}');
    print('resendOtp response:${response.body}');

    if (response.statusCode == 200) {
      return "OTP sent successfully";
    } else {
      if (response.body ==
          'Too many requests, please try again after a minute.') {
        throw ServerException(message: 'Please try again after 1 minute');
      }
      print('resendOtp error: ${jsonDecode(response.body)['message']}');
      throw ServerException(message: jsonDecode(response.body)['message']);
    }
  }

  /// signup function
  @override
  Future<AuthResponseModel> signup({
    String? email,
    String? password,
    String? phone,
  }) async {
    print('......signup start with');
    print('email: $email');
    print('password: $password');
    print('phone: $phone');

    String url = '$kBaseUrl/authentication/register';
    print('url... : $url');

    String fcmToken = ShardPrefHelper.getFCMtoken() ?? '';
    print('FCM Token in signup... : $fcmToken');

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: phone == null
          ? jsonEncode(<String, String>{
              'email': email!,
              'password': password!,
              'fcmToken': fcmToken,
            })
          : jsonEncode(<String, String>{
              'phoneNumber': phone,
              'fcmToken': fcmToken,
            }),
    );
    print('...signup response status code: ${response.statusCode}');
    print('...signup response: ${response.body}');

    if (response.statusCode == 200) {
      // Assuming the response headers contain the Set-Cookie header
      /// extract data from response
      List<String> cookies = response.headers['set-cookie']?.split(',') ?? [];
      String userID = jsonDecode(response.body)['user']['_id'];
      String proPic = jsonDecode(response.body)['user']['picture'];
      String username = jsonDecode(response.body)['user']['username'];
      String? email = jsonDecode(response.body)['user']['email'];
      bool isDobSet = jsonDecode(response.body)['user']['dobSet'];
      String gender = jsonDecode(response.body)['user']['gender'] ?? 'Male';

      List<dynamic> homeLocation =
          jsonDecode(response.body)['user']['home_coordinates']['coordinates'];

      List<dynamic> location = jsonDecode(response.body)['user']
          ['current_coordinates']['coordinates'];

      bool isSkippedTutorial =
          jsonDecode(response.body)['user']['skippedTutorial'];

      bool isViewedTutorial =
          jsonDecode(response.body)['user']['viewedTutorial'];

      bool isPhoneVerified =
          jsonDecode(response.body)['user']['isPhoneVerified'];

      bool isVerified = jsonDecode(response.body)['user']['isVerified'];
      String authType = jsonDecode(response.body)['user']['auth_type'];

      /// set data to local
      ShardPrefHelper.setCookie(cookies);
      ShardPrefHelper.setUserID(userID);
      ShardPrefHelper.setUserProfilePicture(proPic);
      ShardPrefHelper.setUsername(username);
      ShardPrefHelper.setEmail(email ?? '');
      ShardPrefHelper.setDob(isDobSet);
      ShardPrefHelper.setGender(gender);
      ShardPrefHelper.setHomeLocation([homeLocation[0], homeLocation[1]]);
      ShardPrefHelper.setLocation([location[0], location[1]]);
      ShardPrefHelper.setIsSkippedTutorial(isSkippedTutorial);
      ShardPrefHelper.setIsViewedTutorial(isViewedTutorial);

      if (email != null) {
        ShardPrefHelper.setIsEmailLogin(true);
      } else {
        ShardPrefHelper.setIsEmailLogin(false);
      }
      ShardPrefHelper.setIsVerified(isVerified);
      ShardPrefHelper.setIsPhoneVerified(isPhoneVerified);
      ShardPrefHelper.setAuthtype(authType);

      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      String error =
          jsonDecode(response.body)['error'] ?? 'Something went wrong';
      print("sign up else if error: $error");
      throw ServerException(message: error);
    } else {
      String error =
          jsonDecode(response.body)['error'] ?? 'Something went wrong';
      print("sign up error: $error");
      throw ServerException(message: error);
    }
  }

  /// verifyOtp function
  @override
  Future<String> verifyOtp({
    String? email,
    required String otp,
    String? verificationFor,
    String? phone,
  }) async {
    print('.....verifyOtp start with');
    print('email: $email');
    print('phone: $phone');
    print('otp: $otp');
    print('verificationFor: $verificationFor');

    String urlForEmail = '$kBaseUrl/authentication/verify-otp';
    String urlForPhone = '$kBaseUrl/authentication/verify-phone-otp';
    print('urlForEmail:  $urlForEmail');
    print('urlForPhone: $urlForPhone');

    final response = await client.post(
      Uri.parse(email != null ? urlForEmail : urlForPhone),
      headers: {
        //'Content-Type': 'application/json',
      },
      body: email != null
          ? {
              'email': email,
              'otp': otp,
              "verificationFor": verificationFor!,
            }
          : {
              'phoneNumber': phone!,
              'otp': otp,
            },
    );
    print('otp response status code:${response.statusCode}');
    print('otp response ${response.body}');
    if (response.statusCode == 200) {
      // Assuming the response headers contain the Set-Cookie header
      /// extract data from response
      if (verificationFor != 'forgot-password') {
        List<String> cookies = response.headers['set-cookie']?.split(',') ?? [];
        String userID = jsonDecode(response.body)['user']['_id'];
        String proPic = jsonDecode(response.body)['user']['picture'];
        String username = jsonDecode(response.body)['user']['username'];
        String? email = jsonDecode(response.body)['user']['email'];
        bool isDobSet = jsonDecode(response.body)['user']['dobSet'];
        String gender = jsonDecode(response.body)['user']['gender'] ?? 'Male';

        List<dynamic> homeLocation = jsonDecode(response.body)['user']
            ['home_coordinates']['coordinates'];

        List<dynamic> location = jsonDecode(response.body)['user']
            ['current_coordinates']['coordinates'];

        bool isSkippedTutorial =
            jsonDecode(response.body)['user']['skippedTutorial'];

        bool isViewedTutorial =
            jsonDecode(response.body)['user']['viewedTutorial'];

        bool isPhoneVerified =
            jsonDecode(response.body)['user']['isPhoneVerified'];

        bool isVerified = jsonDecode(response.body)['user']['isVerified'];
        String authType = jsonDecode(response.body)['user']['auth_type'];

        /// set data to local
        if (email != null) {
          ShardPrefHelper.setIsEmailLogin(true);
        } else {
          ShardPrefHelper.setIsEmailLogin(false);
        }
        ShardPrefHelper.setCookie(cookies);
        ShardPrefHelper.setUserID(userID);
        ShardPrefHelper.setUserProfilePicture(proPic);
        ShardPrefHelper.setUsername(username);
        ShardPrefHelper.setEmail(email ?? '');
        ShardPrefHelper.setDob(isDobSet);
        ShardPrefHelper.setGender(gender);
        ShardPrefHelper.setHomeLocation([homeLocation[0], homeLocation[1]]);
        ShardPrefHelper.setLocation([location[0], location[1]]);
        ShardPrefHelper.setIsSkippedTutorial(isSkippedTutorial);
        ShardPrefHelper.setIsViewedTutorial(isViewedTutorial);
        ShardPrefHelper.setIsVerified(isVerified);
        ShardPrefHelper.setIsPhoneVerified(isPhoneVerified);
        ShardPrefHelper.setAuthtype(authType);
      }

      return 'Account is verified';
    } else if (response.statusCode == 401) {
      String error =
          jsonDecode(response.body)['message'] ?? 'Something went wrong';
      print('else if otp varify error: $error');
      throw ServerException(message: error);
    } else {
      String error =
          jsonDecode(response.body)['error'] ?? 'Something went wrong';

      print('otp varify error: $error');
      throw ServerException(message: error);
    }
  }

  /// forgotPassword function
  @override
  Future<String> forgotPassword({required String email}) async {
    print('.....forgotPassword start with');
    print('email: $email');
    String url = '$kBaseUrl/authentication/forgot-password';
    print('url: $url');
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    print('forgotPassword response status code:${response.statusCode}');
    print('forgotPassword response ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['msg'];
    } else {
      String error =
          jsonDecode(response.body)['message'] ?? 'Something went wrong';
      print('forgotPassword  error: $error');
      throw ServerException(message: error);
    }
  }

  /// googleAuthentication function
  @override
  Future<dynamic> googleAuthentication() async {
    try {
      print(".....googleAuthentication start");

      String url = '$kBaseUrl/authentication/google/login';
      print("url: $url");

      String fcmToken = ShardPrefHelper.getFCMtoken() ?? '';
      print('fcmToken : $fcmToken');

      final GoogleSignIn googleSignIn = GoogleSignIn();
      print("googleSignIn response: $googleSignIn");

      await googleSignIn.signOut();
      print("signOut done");

      var signInResult = await GoogleSignInService.signInWithGoogle();
      print('signInWithGoogle result: $signInResult');
      if (signInResult['error'] != null) {
        print('signInResult error: ${signInResult['error']}');
        throw ServerException(message: signInResult['error']);
      }
      if (signInResult.containsKey('error')) {
        print('signInResult: ${signInResult['error']}');
        throw ServerException(message: signInResult['error']);
      }

      String tokenID = signInResult['idToken'];
      print('signInWithGoogle tokenID: $tokenID');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': tokenID,
          'device': 'android',
          'fcmToken': fcmToken,
        }),
      );
      print('googleAuthentication response status code:${response.statusCode}');
      print('googleAuthentication response ${response.body}');

      if (response.statusCode == 200) {
        /// extract data from response
        List<String> cookies = response.headers['set-cookie']?.split(',') ?? [];
        String userID = jsonDecode(response.body)['user']['_id'];
        String proPic = jsonDecode(response.body)['user']['picture'];
        String username = jsonDecode(response.body)['user']['username'];
        String? email = jsonDecode(response.body)['user']['email'];
        bool isDobSet = jsonDecode(response.body)['user']['dobSet'];
        String gender = jsonDecode(response.body)['user']['gender'] ?? 'Male';

        List<dynamic> homeLocation = jsonDecode(response.body)['user']
            ['home_coordinates']['coordinates'];

        List<dynamic> location = jsonDecode(response.body)['user']
            ['current_coordinates']['coordinates'];

        bool isVerified = jsonDecode(response.body)['user']['isVerified'];
        String authType = 'email';

        /// set data to local
        ShardPrefHelper.setCookie(cookies);
        ShardPrefHelper.setUserID(userID);
        ShardPrefHelper.setUserProfilePicture(proPic);
        ShardPrefHelper.setUsername(username);
        ShardPrefHelper.setEmail(email ?? '');
        ShardPrefHelper.setDob(isDobSet);
        ShardPrefHelper.setGender(gender);
        ShardPrefHelper.setHomeLocation([homeLocation[0], homeLocation[1]]);
        ShardPrefHelper.setLocation([location[0], location[1]]);
        ShardPrefHelper.setIsVerified(isVerified);
        ShardPrefHelper.setAuthtype(authType);
        ShardPrefHelper.setIsEmailLogin(false);

        return jsonDecode(response.body);
      } else {
        print(
            'googleAuthentication  error: ${jsonDecode(response.body)['message']}');
        print(
            'googleAuthentication  error: ${jsonDecode(response.body)['error_description']}');
        String error = jsonDecode(response.body)['error_description'] ??
            'Something went wrong';
        throw ServerException(message: error);
      }
    } catch (e) {
      print('googleAuthentication  catch error: ${e.toString()}');
      throw ServerException(message: e.toString());
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/utils/google_auth_helper.dart';
import '../../../../../core/utils/set_auth.dart';
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

  // LOGIN WITH EMAIL ID
  @override
  Future<AuthResponseModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    String url = '$kBaseUrl/authentication/login';

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
    log('EMAIL OR PHONE LOGIN:${jsonDecode(response.body)}');
    debugPrint('EMAIL OR PHONE LOGIN:${jsonDecode(response.body)}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);

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

      // SET DATA IN LOCAL
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
      String error =
          jsonDecode(response.body)['message'] ?? 'oops something went wrong';
      throw ServerException(message: error);
    }
  }

  // EMAIL AND PHONE SIGNUP
  @override
  Future<AuthResponseModel> signup({
    String? email,
    String? password,
    String? phone,
  }) async {
    String url = '$kBaseUrl/authentication/register';

    String fcmToken = ShardPrefHelper.getFCMtoken() ?? '';
    print('FCM TOKEN IN SIGNUP:$fcmToken');
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
    log('EMAIL OR PHONE SIGNUP:${response.statusCode}');
    log('EMAIL OR PHONE SIGNUP:${jsonDecode(response.body)}');
    debugPrint('EMAIL OR PHONE SIGNUP:${jsonDecode(response.body)}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);

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

      // SET ALL DATA IN LOCAL

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
    } else {
      String error =
          jsonDecode(response.body)['error'] ?? 'oops something went wrong';

      throw ServerException(message: error);
    }
  }

  // SEND OTP FOR PHONE AND EMAIL
  @override
  Future<String> resendOtp({
    String? email,
    String? phone,
  }) async {
    String urlForEmail = '$kBaseUrl/authentication/send-otp';
    String urlForPhone = '$kBaseUrl/authentication/send-phone-otp';

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
    log('SEND OTP FOR EMAIL OR PHONE:${jsonDecode(response.body)}');
    debugPrint('SEND OTP FOR EMAIL OR PHONE:${jsonDecode(response.body)}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return "OTP sent successfully";
    } else {
      if (response.body ==
          'Too many requests, please try again after a minute.') {
        throw ServerException(message: 'Please try again after 1 minute');
      }

      throw ServerException(message: jsonDecode(response.body)['message']);
    }
  }

  // VERIFY OTP FOR EMAIL AND PHONE
  @override
  Future<String> verifyOtp({
    String? email,
    required String otp,
    String? verificationFor,
    String? phone,
  }) async {
    String urlForEmail = '$kBaseUrl/authentication/verify-otp';
    String urlForPhone = '$kBaseUrl/authentication/verify-phone-otp';

    final response = await client.post(
      Uri.parse(email != null ? urlForEmail : urlForPhone),
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
    log('VERIFY OTP FOR EMAIL OR PHONE:${jsonDecode(response.body)}');
    debugPrint('VERIFY OTP FOR EMAIL OR PHONE:${jsonDecode(response.body)}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      if (verificationFor != 'forgot-password') {
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

        // SET DATA IN LOCAL
        if (email != null) {
          ShardPrefHelper.setIsEmailLogin(true);
        } else {
          ShardPrefHelper.setIsEmailLogin(false);
        }

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
          jsonDecode(response.body)['message'] ?? 'oops something went wrong';

      throw ServerException(message: error);
    } else {
      String error =
          jsonDecode(response.body)['error'] ?? 'oops something went wrong';

      throw ServerException(message: error);
    }
  }

  // FORGOT PASSWORD
  @override
  Future<String> forgotPassword({required String email}) async {
    String url = '$kBaseUrl/authentication/forgot-password';

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    log('FORGOT PASSWORD RESPONSE:${jsonDecode(response.body)}');
    debugPrint('FORGOT PASSWORD RESPONSE:${jsonDecode(response.body)}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return jsonDecode(response.body)['msg'];
    } else {
      String error =
          jsonDecode(response.body)['message'] ?? 'oops something went wrong';

      throw ServerException(message: error);
    }
  }

  // GOOGLE AUTH
  @override
  Future<dynamic> googleAuthentication() async {
    try {
      String url = '$kBaseUrl/authentication/google/login';

      String fcmToken = ShardPrefHelper.getFCMtoken() ?? '';

      var signInResult = await GoogleSignInService.signInWithGoogle();

      if (signInResult['error'] != null) {
        throw ServerException(message: signInResult['error']);
      }
      if (signInResult.containsKey('error')) {
        throw ServerException(message: signInResult['error']);
      }

      String tokenID = signInResult['idToken'];

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': tokenID,
          'device': 'android',
          'fcmToken': fcmToken,
        }),
      );
      log('GOOGLE AUTH RESPONSE:${jsonDecode(response.body)}');
      debugPrint('GOOGLE AUTH RESPONSE:${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        handleAuthHeaders(response.headers);

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
        bool isVerified = jsonDecode(response.body)['user']['isVerified'];
        String authType = 'email';

        // SET DATA IN LOCAL
        ShardPrefHelper.setIsSkippedTutorial(isSkippedTutorial);
        ShardPrefHelper.setIsViewedTutorial(isViewedTutorial);
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
        String error = jsonDecode(response.body)['error_description'] ??
            jsonDecode(response.body)['message'] ??
            'oops something went wrong';
        throw ServerException(message: error);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

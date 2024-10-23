import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
    if (response.statusCode == 200) {
      print('...Login response: ${response.body}');
      // Assuming the response headers contain the Set-Cookie header
      List<String> cookies = response.headers['set-cookie']?.split(',') ?? [];
      String userID = jsonDecode(response.body)['user']['_id'];
      String username = jsonDecode(response.body)['user']['username'];
      String accessToken = jsonDecode(response.body)['refreshToken'];
      String refreshToken = jsonDecode(response.body)['refreshToken'];
      String proPic = jsonDecode(response.body)['user']['picture'];
      List<dynamic> location = jsonDecode(response.body)['user']
          ['current_coordinates']['coordinates'];
      List<dynamic> homeLocation =
          jsonDecode(response.body)['user']['home_coordinates']['coordinates'];
      print('home cord inn login: $homeLocation');
      String? email = jsonDecode(response.body)['user']['email'];
      bool isVerified = jsonDecode(response.body)['user']['isVerified'];
      bool isSkippedTutorial =
          jsonDecode(response.body)['user']['skippedTutorial'];
      bool isViewedTutorial =
          jsonDecode(response.body)['user']['viewedTutorial'];
      print(isSkippedTutorial);
      print(isViewedTutorial);

      ShardPrefHelper.setIsSkippedTutorial(isSkippedTutorial);
      ShardPrefHelper.setIsViewedTutorial(isViewedTutorial);

      bool skip = ShardPrefHelper.getIsSkippedTutorial();
      bool view = ShardPrefHelper.getIsViewedTutorial();

      print(skip);
      print(view);

      ShardPrefHelper.setAccessToken(accessToken);
      ShardPrefHelper.setRefreshToken(refreshToken);
      ShardPrefHelper.setCookie(cookies);
      ShardPrefHelper.setUserID(userID);
      ShardPrefHelper.setEmail(email ?? '');
      ShardPrefHelper.setUsername(username);
      ShardPrefHelper.setUserProfilePicture(proPic);
      ShardPrefHelper.setLocation([location[0], location[1]]);
      ShardPrefHelper.setHomeLocation([homeLocation[0], homeLocation[1]]);
      ShardPrefHelper.setIsVerified(isVerified);

      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(message: jsonDecode(response.body)['message']);
    }
  }

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

    if (response.statusCode == 200) {
      print('otp has been send');
      return "OTP sent successfully";
    } else {
      print('resendOtp ${response.body}');
      throw ServerException(message: jsonDecode(response.body)['message']);
    }
  }

  @override
  Future<AuthResponseModel> signup({
    String? email,
    String? password,
    String? phone,
  }) async {
    print('starting email signup');
    String url = '$kBaseUrl/authentication/register';
    String fcmToken = ShardPrefHelper.getFCMtoken() ?? '';
    print('fcm token in signup $fcmToken');
    print('starting email signup hitting api');
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
    print('starting email signup response $response or ${response.statusCode}');
    print(response.body);
    if (response.statusCode == 200) {
      // Assuming the response headers contain the Set-Cookie header
      List<String> cookies = response.headers['set-cookie']?.split(',') ?? [];
      String userID = jsonDecode(response.body)['user']['_id'];
      String username = jsonDecode(response.body)['user']['username'];
      String proPic = jsonDecode(response.body)['user']['picture'];
      List<dynamic> location = jsonDecode(response.body)['user']
          ['current_coordinates']['coordinates'];
      List<dynamic> homeLocation =
          jsonDecode(response.body)['user']['home_coordinates']['coordinates'];
      String? email = jsonDecode(response.body)['user']['email'];
      bool isVerified = jsonDecode(response.body)['user']['isVerified'];
      bool isSkippedTutorial =
          jsonDecode(response.body)['user']['skippedTutorial'];
      bool isViewedTutorial =
          jsonDecode(response.body)['user']['viewedTutorial'];

      ShardPrefHelper.setIsSkippedTutorial(isSkippedTutorial);
      ShardPrefHelper.setIsViewedTutorial(isViewedTutorial);
      ShardPrefHelper.setIsVerified(isVerified);
      ShardPrefHelper.setCookie(cookies);
      ShardPrefHelper.setUserID(userID);

      ShardPrefHelper.setEmail(email ?? '');

      ShardPrefHelper.setUsername(username);
      ShardPrefHelper.setUserProfilePicture(proPic);
      ShardPrefHelper.setLocation([location[0], location[1]]);
      ShardPrefHelper.setHomeLocation([homeLocation[0], homeLocation[1]]);

      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      print("here error");
      throw ServerException(message: jsonDecode(response.body)['message']);
    }
  }

  @override
  Future<String> verifyOtp({
    String? email,
    required String otp,
    String? verificationFor,
    String? phone,
  }) async {
    String urlForEmail = '$kBaseUrl/authentication/verify-otp';
    String urlForPhone = '$kBaseUrl/authentication/verify-phone-otp';
    print('verificationfor $verificationFor');
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

    if (response.statusCode == 200) {
      // Assuming the response headers contain the Set-Cookie header
      List<String> cookies = response.headers['set-cookie']?.split(',') ?? [];
      String userID = jsonDecode(response.body)['user']['_id'];
      String username = jsonDecode(response.body)['user']['username'];
      String proPic = jsonDecode(response.body)['user']['picture'];
      List<dynamic> location = jsonDecode(response.body)['user']
          ['current_coordinates']['coordinates'];
      List<dynamic> homeLocation =
          jsonDecode(response.body)['user']['home_coordinates']['coordinates'];
      String? email = jsonDecode(response.body)['user']['email'];
      bool isVerified = jsonDecode(response.body)['user']['isVerified'];
      bool isSkippedTutorial =
          jsonDecode(response.body)['user']['skippedTutorial'];
      bool isViewedTutorial =
          jsonDecode(response.body)['user']['viewedTutorial'];

      ShardPrefHelper.setIsSkippedTutorial(isSkippedTutorial);
      ShardPrefHelper.setIsViewedTutorial(isViewedTutorial);
      ShardPrefHelper.setIsVerified(isVerified);
      ShardPrefHelper.setCookie(cookies);
      ShardPrefHelper.setUserID(userID);
      ShardPrefHelper.setEmail(email ?? '');
      ShardPrefHelper.setUsername(username);
      ShardPrefHelper.setUserProfilePicture(proPic);
      ShardPrefHelper.setLocation([location[0], location[1]]);
      ShardPrefHelper.setHomeLocation([homeLocation[0], homeLocation[1]]);

      return 'Account is verified';
    } else {
      throw ServerException(message: jsonDecode(response.body)['error']);
    }
  }

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

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['msg'];
    } else {
      throw ServerException(message: jsonDecode(response.body)['error']);
    }
  }

  @override
  Future<dynamic> googleAuthentication() async {
    try {
      print("start vinay checking");
      String url = '$kBaseUrl/authentication/google/login';
      final GoogleSignIn googleSignIn = GoogleSignIn();
      print("start vinay checking googleSignIn $googleSignIn");
      await googleSignIn.signOut();
      print("start vinay checking signOut ");

      print('here i am ');
      var signInResult = await GoogleSignInService.signInWithGoogle();
      print('here i am result $signInResult');
      String tokenID = signInResult['idToken'];
      if (signInResult.containsKey('error')) {
        print(signInResult['error']);
        return;
      }
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': tokenID,
          'device': 'android',
          'fcmToken': 'dE3QQU0UScSvPrABZE81H3:APA91bFHthp42ntwpvyFw4gBRqsmip'
        }), //TODO : need to fetch device type
      );
      if (response.statusCode == 200) {
        List<String> cookies = response.headers['set-cookie']?.split(',') ?? [];
        String userID = jsonDecode(response.body)['user']['_id'];
        String username = jsonDecode(response.body)['user']['username'];
        String proPic = jsonDecode(response.body)['user']['picture'];
        List<dynamic> location = jsonDecode(response.body)['user']
            ['current_coordinates']['coordinates'];
        List<dynamic> homeLocation = jsonDecode(response.body)['user']
            ['home_coordinates']['coordinates'];
        String? email = jsonDecode(response.body)['user']['email'];
        print("cookies : $cookies");
        ShardPrefHelper.setCookie(cookies);
        ShardPrefHelper.setUserID(userID);
        ShardPrefHelper.setEmail(email ?? '');
        ShardPrefHelper.setUsername(username);
        ShardPrefHelper.setUserProfilePicture(proPic);
        ShardPrefHelper.setLocation([location[0], location[1]]);
        ShardPrefHelper.setHomeLocation([homeLocation[0], homeLocation[1]]);

        return jsonDecode(response.body);
      } else {
        throw ServerException(
            message: jsonDecode(response.body)['error_description']);
      }
    } catch (e) {
      print('error for singup $e');
      debugPrint(e.toString());
    }
  }
}

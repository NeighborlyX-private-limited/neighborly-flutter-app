import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:neighborly_flutter_app/core/utils/google_auth_helper.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

import 'auth_remote_data_source.dart';
import '../../models/auth_response_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthResponseModel> loginWithEmail(
      {required String email, required String password}) async {
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
      // Assuming the response headers contain the Set-Cookie header
      List<String> cookies = response.headers['set-cookie']?.split(',') ?? [];
      String userID = jsonDecode(response.body)['user']['_id'];

      ShardPrefHelper.setCookie(cookies);
      ShardPrefHelper.setUserID(userID);

      print('Cookies saved: $cookies');
      print('UserID saved: $userID');
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(message: jsonDecode(response.body)['message']);
    }
  }

  @override
  Future<String> resendOtp({required String email}) async {
    String url = '$kBaseUrl/authentication/send-otp';
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
  Future<AuthResponseModel> signupWithEmail(
      {required String email,
      required String password,
      required String dob,
      required String gender}) async {
    String url = '$kBaseUrl/authentication/register';
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'password': password,
        'email': email,
        'dob': dob,
        'gender': gender
      }),
    );
    if (response.statusCode == 200) {
      // Assuming the response headers contain the Set-Cookie header
      List<String> cookies = response.headers['set-cookie']?.split(',') ?? [];
      String userID = jsonDecode(response.body)['user']['_id'];

      ShardPrefHelper.setCookie(cookies);
      ShardPrefHelper.setUserID(userID);

      print('Cookies saved: $cookies');
      print('UserID saved: $userID');
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(message: jsonDecode(response.body)['message']);
    }
  }

  @override
  Future<String> verifyOtp(
      {required String email,
      required String otp,
      required String verificationFor}) async {
    String url = '$kBaseUrl/authentication/verify-otp';
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'otp': otp,
        "verificationFor": verificationFor,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
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
    String url = '$kBaseUrl/authentication/google/login';
    var signInResult = await GoogleSignInService.signInWithGoogle();
    String tokenID = signInResult['idToken'];
    if (signInResult.containsKey('error')) {
      print(signInResult['error']);
      return;
    }
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'tokenId': tokenID}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ServerException(
          message: jsonDecode(response.body)['error_description']);
    }
  }
}

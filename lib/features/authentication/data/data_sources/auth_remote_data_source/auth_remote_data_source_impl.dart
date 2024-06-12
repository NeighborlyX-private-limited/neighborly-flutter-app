import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

import 'package:neighborly_flutter_app/features/authentication/data/data_sources/auth_remote_data_source/auth_remote_data_source.dart';
import 'package:neighborly_flutter_app/features/authentication/data/models/auth_response_model.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/screens/web_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

      ShardPrefHelper.setCookie(cookies);

      print('Cookies saved: $cookies');
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
      {required String email, required String password}) async {
    String url = '$kBaseUrl/authentication/register';
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'password': password,
        'email': email,
      }),
    );
    if (response.statusCode == 200) {
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
  Future<dynamic> googleAuthentication(BuildContext context) async {
    String url = 'https://neighborly.in/api/authentication/google/oauth';
    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('GoogleAuthenticationButtonPressedEvent in data source');
      if (response.headers['content-type']?.contains('text/html') ?? false) {
        // It's HTML, show it in WebView
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewScreen(htmlContent: response.body),
          ),
        );
      } else {
        // It's JSON, decode it and return
        dynamic data = jsonDecode(response.body);
        print(data);
        return data;
      }
    } else {
      throw ServerException(
          message: jsonDecode(response.body)['error_description']);
    }
  }
}

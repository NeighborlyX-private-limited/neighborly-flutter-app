import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/core/error/exception.dart';

import 'package:neighborly_flutter_app/features/authentication/data/data_sources/auth_remote_data_source/auth_remote_data_source.dart';
import 'package:neighborly_flutter_app/features/authentication/data/models/auth_response_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthResponseModel> loginWithEmail({required String email, required String password}) async {
    final response = await client.post(
      Uri.parse('https://neighborly-api.herokuapp.com/api/v1/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<AuthResponseModel> resendOtp({required String email}) async {
    final response = await client.post(
      Uri.parse('https://neighborly-api.herokuapp.com/api/v1/auth/resend-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<AuthResponseModel> signupWithEmail({required String email, required String password}) async {
    final response = await client.post(
      Uri.parse('https://neighborly-api.herokuapp.com/api/v1/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp({required String email, required String otp}) async {
    final response = await client.post(
      Uri.parse('https://neighborly-api.herokuapp.com/api/v1/auth/verify-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw const ServerException();
    }
  }

  

  
}

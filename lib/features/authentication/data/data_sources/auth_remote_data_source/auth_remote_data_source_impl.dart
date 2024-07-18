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
      String username = jsonDecode(response.body)['user']['username'];
      String proPic = jsonDecode(response.body)['user']['picture'];
      List<dynamic> location = jsonDecode(response.body)['user']
          ['current_coordinates']['coordinates'];
      String? email = jsonDecode(response.body)['user']['email'];

      ShardPrefHelper.setCookie(cookies);
      ShardPrefHelper.setUserID(userID);
      ShardPrefHelper.setEmail(email ?? '');
      ShardPrefHelper.setUsername(username);
      ShardPrefHelper.setUserProfilePicture(proPic);
      ShardPrefHelper.setLocation([location[0], location[1]]);

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
      return "OTP sent successfully";
    } else {
      throw ServerException(message: jsonDecode(response.body)['message']);
    }
  }

  @override
  Future<AuthResponseModel> signup({
    String? email,
    String? password,
    String? phone,
  }) async {
    String url = '$kBaseUrl/authentication/register';
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: phone == null
          ? jsonEncode(<String, String>{
              'email': email!,
              'password': password!,
            })
          : jsonEncode(<String, String>{
              'phoneNumber': phone,
            }),
    );
    if (response.statusCode == 200) {
      // Assuming the response headers contain the Set-Cookie header
      List<String> cookies = response.headers['set-cookie']?.split(',') ?? [];
      String userID = jsonDecode(response.body)['user']['_id'];
      String username = jsonDecode(response.body)['user']['username'];
      String proPic = jsonDecode(response.body)['user']['picture'];
      List<dynamic> location = jsonDecode(response.body)['user']
          ['current_coordinates']['coordinates'];
      String? email = jsonDecode(response.body)['user']['email'];

      ShardPrefHelper.setCookie(cookies);
      ShardPrefHelper.setUserID(userID);

      ShardPrefHelper.setEmail(email ?? '');

      ShardPrefHelper.setUsername(username);
      ShardPrefHelper.setUserProfilePicture(proPic);
      ShardPrefHelper.setLocation([location[0], location[1]]);

      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
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
    final response = await client.post(
      Uri.parse(email != null ? urlForEmail : urlForPhone),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: email != null
          ? jsonEncode(<String, String>{
              'email': email,
              'otp': otp,
              "verificationFor": verificationFor!,
            })
          : jsonEncode(<String, String>{
              'phoneNumber': phone!,
              'otp': otp,
            }),
    );

    if (response.statusCode == 200) {
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

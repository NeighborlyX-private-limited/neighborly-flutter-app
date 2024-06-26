import 'dart:convert';

import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/profile/data/data_sources/profile_remote_data_source/profile_remote_data_source.dart';
import 'package:http/http.dart' as http;

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;

  ProfileRemoteDataSourceImpl({required this.client});
  @override
  Future<String> changePassword(
      {String? currentPassword,
      required String newPassword,
      required String email,
      required bool flag}) async {
    Map<String, dynamic> queryParameters = {
      'newPassword': newPassword,
      'email': email,
      'flag': flag,
    };
    if (currentPassword != null) {
      queryParameters['currentPassword'] = currentPassword;
    }
    String url = '$kBaseUrl/user/change-password';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(queryParameters),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['msg'];
    } else {
      throw ServerException(message: jsonDecode(response.body)['error']);
    }
  }

  @override
  Future<void> updateLocation({required List<num> location}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    // print('Cookies: $cookieHeader');
    String url = '$kBaseUrl/user/update-user-location';
    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode({'userLocation': location}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: jsonDecode(response.body)['error']);
    }
  }
}

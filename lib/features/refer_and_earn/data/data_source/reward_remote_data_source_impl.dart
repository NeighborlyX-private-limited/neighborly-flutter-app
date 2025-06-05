// // lib/core/network/api_service.dart

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:neighborly_flutter_app/features/refer_and_earn/data/data_source/reward_remote_data_source.dart';

// class ApiService {
//   final String baseUrl;

//   ApiService({required this.baseUrl});

//   Future<Map<String, dynamic>> get(String endpoint) async {
//     print('$baseUrl$endpoint');
//     final response = await http.get(Uri.parse('$baseUrl$endpoint'));
//     print('rs: ${response.statusCode}');
//     print('rs: ${response.body}');
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as Map<String, dynamic>;
//     } else {
//       throw Exception('Failed to load data: ${response.statusCode}');
//     }
//   }
// }

import 'dart:convert';

import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
import 'package:neighborly_flutter_app/features/refer_and_earn/data/data_source/reward_remote_data_source.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/utils/set_auth.dart';
import '../../../../core/utils/shared_preference.dart';

class RewardRemoteDataSourceImpl implements RewardRemoteDataSource {
  final http.Client client;

  RewardRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> getRewardDetails() async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    // var city = ShardPrefHelper.getCurrentCity();

    // //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '$kBaseUrl/invite/get-details';
    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      //body: jsonEncode(location));
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw ServerException(
          message: jsonDecode(response.body)['error'] ??
              'oops something went wrong');
    }
  }

  @override
  Future<Map<String, dynamic>> getRequestHistory() async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    // var city = ShardPrefHelper.getCurrentCity();

    // //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '$kBaseUrl/invite/get-request-history';
    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      //body: jsonEncode(location));
    );

    if (response.statusCode == 200) {
      print('success');
      handleAuthHeaders(response.headers);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw ServerException(
          message: jsonDecode(response.body)['error'] ??
              'oops something went wrong');
    }
  }

  @override
  Future<String> withdrawAmmount(int amount, String upiId) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    // var city = ShardPrefHelper.getCurrentCity();

    // //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '$kBaseUrl/invite/withdraw-reward';
    final response = await client.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Cookie': cookies,
        },
        body: jsonEncode({
          "amount": amount,
          "upiId": upiId,
        }));

    if (response.statusCode == 200) {
      print('success');
      handleAuthHeaders(response.headers);
      return 'Request created successfully.';
    } else {
      print('hello ${jsonDecode(response.body)}');
      throw ServerException(
          message: jsonDecode(response.body)['error'] ??
              'oops something went wrong');
    }
  }

  @override
  Future<String> submitInvite(String inviteCode) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    // var city = ShardPrefHelper.getCurrentCity();

    // //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '';
    if (inviteCode == '') {
      url = '$kBaseUrl/invite';
    } else {
      url = '$kBaseUrl/invite?inviteCode=$inviteCode';
    }
    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      // body: jsonEncode({
      //   "amount": amount,
      //   "upiId": upiId,
      // }));
    );

    if (response.statusCode == 200) {
      print('success');
      handleAuthHeaders(response.headers);
      return 'Success';
    } else {
      print('hello ${jsonDecode(response.body)}');
      throw ServerException(
          message: jsonDecode(response.body)['error'] ??
              'oops something went wrong');
    }
  }
}

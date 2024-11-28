import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

class PaymentRemoteDataSource {
  final http.Client client;

  PaymentRemoteDataSource({required this.client});

  /// create order
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> params) async {
    print('...createOrder start with');
    print('params: $params');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in createOrder');
      throw const ServerException(message: 'Someting went wrong');
    }

    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/payment/create-order';
    print('url: $url');
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(params),
    );
    print('createOrder api response status code: ${response.statusCode}');
    print('createOrder api response: ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('else error in createOrder');
      throw Exception('Failed to create order');
    }
  }

  /// verify payment
  Future<bool> verifyPayment(Map<String, dynamic> params) async {
    print('...verifyPayment start with');
    print('params: $params');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in verifyPayment');
      throw const ServerException(message: 'Someting went wrong');
    }

    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/payment/verify-payment';
    print('url: $url');
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(params),
    );
    print('verifyPayment api response status code: ${response.statusCode}');
    print('verifyPayment api response: ${response.body}');
    if (response.statusCode == 200) {
      return true;
    } else {
      print('else error in createOrder');
      return false;
    }
  }
}

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
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Someting went wrong');
    }

    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/payment/create-order';

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(params),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create order');
    }
  }

  /// verify payment
  Future<bool> verifyPayment(Map<String, dynamic> params) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Someting went wrong');
    }

    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/payment/verify-payment';

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(params),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

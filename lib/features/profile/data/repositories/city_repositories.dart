import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

class CityRepository {
  Future<void> updateCity(String city) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

    final url = Uri.parse('$kBaseUrl/user/update-user-location/$city');

    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Cookie': cookies,
        },
      );
      debugPrint('UPDATE CITY: ${response.body}');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        String message = responseMap['message'];
        List<String> words = message.split(' ');
        String lastWord = words.last;

        if (lastWord.toLowerCase() == 'delhi') {
          lastWord = "New Delhi";
        }
        // ShardPrefHelper.setHomeCity(lastWord);
        // ShardPrefHelper.setHomeLocation([
        //   responseMap['user_coordinates'][0],
        //   responseMap['user_coordinates'][1]
        // ]);
      } else {
        final message =
            jsonDecode(response.body)['message'] ?? 'Someting went wrong';
        throw Exception(message);
      }
    } catch (e) {
      rethrow;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

class CityRepository {
  Future<void> updateCity(String city) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    final url = Uri.parse('$kBaseUrl/user/update-user-location/$city');
    print('url in updateCity ==> $url');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        String message = responseMap['message'];
        List<String> words = message.split(' ');
        String lastWord = words.last;
        print('Last word of message ==> $lastWord');
        print('Last word of message ==> ${responseMap['user_coordinates']}');
        ShardPrefHelper.setHomeCity(lastWord);
        ShardPrefHelper.setHomeLocation([
          responseMap['user_coordinates'][0],
          responseMap['user_coordinates'][1]
        ]);

        print('City updated successfully. Response ==> ${response.body}');
      } else {
        print('Failed to update city. Response ==> ${response.body}');
        throw Exception('Failed to update city');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

class CityRepository {
  Future<void> updateCity(String city) async {
    print('updateCity start with...');
    print('city: $city');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in updateCity');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    final url = Uri.parse('$kBaseUrl/user/update-user-location/$city');
    print('url:$url');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
      );
      print("updateCity response status code: ${response.statusCode}");
      print("updateCity response: ${jsonDecode(response.body)}");
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        String message = responseMap['message'];
        List<String> words = message.split(' ');
        String lastWord = words.last;
        print('Last word of update city: $lastWord');
        print('city coordinates: ${responseMap['user_coordinates']}');
        ShardPrefHelper.setHomeCity(lastWord);
        ShardPrefHelper.setHomeLocation([
          responseMap['user_coordinates'][0],
          responseMap['user_coordinates'][1]
        ]);
        print('City updated successfully');
      } else {
        print('updateCity else error: ${jsonDecode(response.body)['message']}');
        final message =
            jsonDecode(response.body)['message'] ?? 'Someting went wrong';
        throw Exception(message);
      }
    } catch (e) {
      print('updateCity catch error: ${jsonDecode(e.toString())}');
      rethrow;
    }
  }
}

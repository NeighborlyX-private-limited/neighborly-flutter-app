import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

class CityRepository {
  Future<void> updateCity(String city) async {
    
    
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    final url = Uri.parse('$kBaseUrl/user/update-user-location/$city');
    

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
        
       
        if (lastWord.toLowerCase() == 'delhi') {
          lastWord = "New Delhi";
        }
        ShardPrefHelper.setHomeCity(lastWord);
        ShardPrefHelper.setHomeLocation([
          responseMap['user_coordinates'][0],
          responseMap['user_coordinates'][1]
        ]);
        
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

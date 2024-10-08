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

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
      );

      if (response.statusCode == 200) {
        print('City updated successfully. Response: ${response.body}');
      } else {
        print('Failed to update city. Response: ${response.body}');
        throw Exception('Failed to update city');
      }
    } catch (e) {
      print('Error: $e');
      rethrow; // Rethrow to let the BLoC handle the error
    }
  }
}

import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

void handleAuthHeaders(Map<String, String> headers) {
  if (headers.containsKey('set-cookie')) {
    print('Cookies without splitting: ${headers['set-cookie']}');

    List<String> cookies = headers['set-cookie']?.split(';') ?? [];
    String? refreshToken;

    for (String cookie in cookies) {
      String trimmedCookie = cookie.trim();
      if (trimmedCookie.startsWith('refreshToken')) {
        refreshToken = trimmedCookie;
        break;
      }
    }

    if (refreshToken != null) {
      print('Refresh token found: $refreshToken');
      ShardPrefHelper.setCookie(refreshToken);
    } else {
      print('No refresh token found.');
    }
  } else {
    print('No set-cookie header found.');
  }

  if (headers.containsKey('authorization')) {
    String accessToken = headers['authorization'] ?? '';
    print('Access Token found: $accessToken');
    ShardPrefHelper.setAccessToken(accessToken);
  } else {
    print('No authorization header found.');
  }
}

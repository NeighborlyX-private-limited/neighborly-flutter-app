import "package:shared_preferences/shared_preferences.dart";

class ShardPrefHelper {
  static late SharedPreferences _preferences;
  static const String _cookie = 'cookies';
  static const String _userID = 'userID';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  // save cookies

  static Future setCookie(List<String> cookie) async =>
      await _preferences.setStringList(_cookie, cookie);
  static List<String>? getCookie() => _preferences.getStringList(_cookie) ?? [];

  // save image url
  static Future setImageUrl(String imageUrl) async =>
      await _preferences.setString('imageUrl', imageUrl);
  static String? getImageUrl() => _preferences.getString('imageUrl');

  // remove image url
  static Future removeImageUrl() async => await _preferences.remove('imageUrl');

  // save userID
  static Future setUserID(String userId) async =>
      await _preferences.setString(_userID, userId);
  static String? getUserID() => _preferences.getString(_userID) ?? '';

  static Future<bool> clear() async {
    await _preferences.clear();
    return true;
  }
}

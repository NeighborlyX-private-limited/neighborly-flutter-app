import "package:shared_preferences/shared_preferences.dart";

class ShardPrefHelper {
  static late SharedPreferences _preferences;
  static const String _cookie = 'cookies';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setCookie(List<String> cookie) async =>
      await _preferences.setStringList(_cookie, cookie);
  static List<String>? getCookie() => _preferences.getStringList(_cookie) ?? [];

  static Future<bool> clear() async {
    await _preferences.clear();
    return true;
  }
}

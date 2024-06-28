import "package:shared_preferences/shared_preferences.dart";

class ShardPrefHelper {
  static late SharedPreferences _preferences;
  static const String _cookie = 'cookies';
  static const String _userID = 'userID';
  static const String _doubleListKey = 'doubleList';

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

  // save userProfilePicture
  static Future setUserProfilePicture(String userProfilePicture) async =>
      await _preferences.setString('userProfilePicture', userProfilePicture);
  static String? getUserProfilePicture() =>
      _preferences.getString('userProfilePicture');

  // save username
  static Future setUsername(String username) async =>
      await _preferences.setString('username', username);
  static String? getUsername() => _preferences.getString('username');

  // Save location
  static Future setLocation(List<double> doubleList) async {
    List<String> stringList = doubleList.map((e) => e.toString()).toList();
    return await _preferences.setStringList(_doubleListKey, stringList);
  }

  // Fetch location
  static List<double> getLocation() {
    List<String> stringList = _preferences.getStringList(_doubleListKey) ?? [];
    return stringList.map((e) => double.tryParse(e) ?? 0.0).toList();
  }

  static Future<bool> clear() async {
    await _preferences.clear();
    return true;
  }
}

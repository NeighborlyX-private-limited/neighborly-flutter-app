import 'package:shared_preferences/shared_preferences.dart';

class ShardPrefHelper {
  /// SharedPreferences instance
  static late SharedPreferences _preferences;

  /// keys
  static const String _cookie = 'cookies';
  static const String _jwtToken = 'jwtToken';
  static const String _accessToken = 'accessToken';
  static const String _refreshToken = 'refreshToken';
  static const String _userID = 'userID';
  static const String _doubleListKey = 'doubleList';
  static const String _homeListKey = 'homeList';
  static const String _languageKey = 'languageKey';

  ///...initialization of SharedPreferences instnace
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  ///...... save cookies
  static Future setCookie(String cookie) async =>
      await _preferences.setString(_cookie, cookie);

  static String? getCookie() => _preferences.getString(_cookie) ?? '';

  static Future removeCookie() async => await _preferences.remove(_cookie);
  // ///...... save cookies
  // static Future setCookie(List<String> cookie) async =>
  //     await _preferences.setStringList(_cookie, cookie);

  // static List<String>? getCookie() => _preferences.getStringList(_cookie) ?? [];

  // static Future removeCookie() async => await _preferences.remove(_cookie);

  ///...... save Access Token
  static Future setAccessToken(String accessToken) async =>
      await _preferences.setString(_accessToken, accessToken);

  static String? getAccessToken() => _preferences.getString(_accessToken) ?? '';

  static Future removeAccessToken() async =>
      await _preferences.remove(_accessToken);

  ///...... save  JWT Token
  static Future setJwtToken(String jwtToken) async =>
      await _preferences.setString(_jwtToken, jwtToken);

  static String? getJwtToken() => _preferences.getString(_jwtToken) ?? '';

  static Future removeJwtToken() async => await _preferences.remove(_jwtToken);

  ///......save Refresh Token
  static Future setRefreshToken(String refreshToken) async =>
      await _preferences.setString(_refreshToken, refreshToken);

  static String? getRefreshToken() =>
      _preferences.getString(_refreshToken) ?? '';

  static Future removeRefreshToken() async =>
      await _preferences.remove(_refreshToken);

  // SAVE FCM TOKEN
  static Future setFCMtoken(String newFCMToken) async =>
      await _preferences.setString('FCMtoken', newFCMToken);
  static String? getFCMtoken() => _preferences.getString('FCMtoken');

  ///...... save user image url
  static Future setImageUrl(String imageUrl) async =>
      await _preferences.setString('imageUrl', imageUrl);

  static String? getImageUrl() => _preferences.getString('imageUrl');

  static Future removeImageUrl() async => await _preferences.remove('imageUrl');

  ///...... save userID
  static Future setUserID(String userId) async =>
      await _preferences.setString(_userID, userId);

  static String? getUserID() => _preferences.getString(_userID) ?? '';

  static Future removeUserID() async => await _preferences.remove(_userID);

  ///..... save userProfilePicture
  static Future setUserProfilePicture(String userProfilePicture) async =>
      await _preferences.setString('userProfilePicture', userProfilePicture);

  static String? getUserProfilePicture() =>
      _preferences.getString('userProfilePicture');

  static Future removeUserProfilePicture() async =>
      await _preferences.remove('userProfilePicture');

  ///...... save username
  static Future setUsername(String username) async =>
      await _preferences.setString('username', username);

  static String? getUsername() => _preferences.getString('username');

  static Future removeUsername() async => await _preferences.remove('username');

  ///...... save phoneNumber
  static Future setPhoneNumber(String phoneNumber) async =>
      await _preferences.setString('phoneNumber', phoneNumber);

  static String? getPhoneNumber() => _preferences.getString('phoneNumber');

  static Future removePhoneNumber() async =>
      await _preferences.remove('phoneNumber');

  ///... save email
  static Future setEmail(String email) async =>
      await _preferences.setString('email', email);

  static String? getEmail() => _preferences.getString('email');

  static Future removeEmail() async => await _preferences.remove('email');

  ///.... save dob
  static Future setDob(bool isSet) async =>
      await _preferences.setBool('dob', isSet);

  static bool getDob() => _preferences.getBool('dob') ?? false;

  static Future removeDob() async => await _preferences.remove('dob');

  ///.... save gender
  static Future setGender(String gender) async =>
      await _preferences.setString('gender', gender);

  static String? getGender() => _preferences.getString('gender');

  static Future removeGender() async => await _preferences.remove('gender');

  ///......save app language
  static Future setLanguage(String language) async =>
      await _preferences.setString(_languageKey, language);

  static String? getLanguage() => _preferences.getString(_languageKey) ?? 'en';

  static Future removeLanguage() async =>
      await _preferences.remove(_languageKey);

  ///.... save city
  // static Future setHomeCity(String city) async =>
  //     await _preferences.setString('Homecity', city);

  // static String? getHomeCity() => _preferences.getString('Homecity');

  // static Future removeHomeCity() async => await _preferences.remove('Homecity');

////....setCurrentCity
  // static Future setCurrentCity(String city) async =>
  //     await _preferences.setString('city', city);

  // static String? getCurrentCity() => _preferences.getString('city');

  // static Future removeCurrentCity() async => await _preferences.remove('city');

// USER LOCATION SAVING

  static Future<void> setLat(double lat) async =>
      await _preferences.setDouble('lat', lat);
  static Future<void> setLng(double lng) async =>
      await _preferences.setDouble('lng', lng);
  static Future<void> setCity(String city) async =>
      await _preferences.setString('city', city);
  static Future<void> setIsCurrentLocationOn(bool isCurrent) async =>
      await _preferences.setBool('isCurrent', isCurrent);

  static double? getLat() => _preferences.getDouble('lat');
  static double? getLng() => _preferences.getDouble('lng');
  static String? getCity() => _preferences.getString('city');
  static bool? getIsCurrentLocationOn() => _preferences.getBool('isCurrent');

  static Future<void> removeLat() async => await _preferences.remove('lat');
  static Future<void> removeLng() async => await _preferences.remove('lng');
  static Future<void> removeCity() async => await _preferences.remove('city');
  static Future<void> removeCurrent() async =>
      await _preferences.remove('isCurrent');

  // SAVE USER'S CURRENT LOCATION
  // static Future setLocation(List<double> doubleList) async {
  //   List<String> stringList = doubleList.map((e) => e.toString()).toList();
  //   return await _preferences.setStringList(_doubleListKey, stringList);
  // }

  // static List<double> getLocation() {
  //   List<String> stringList = _preferences.getStringList(_doubleListKey) ?? [];
  //   return stringList.map((e) => double.tryParse(e) ?? 0.0).toList();
  // }

  // static Future removeLocation() async =>
  //     await _preferences.remove(_doubleListKey);
  // SAVE USER'S LOCATION
  // static Future setUserLocation(List<double> doubleList) async {
  //   List<String> stringList = doubleList.map((e) => e.toString()).toList();
  //   return await _preferences.setStringList(_doubleListKey, stringList);
  // }

  // static List<double> getUserLocation() {
  //   List<String> stringList = _preferences.getStringList(_doubleListKey) ?? [];
  //   return stringList.map((e) => double.tryParse(e) ?? 0.0).toList();
  // }

  // static Future removeUserLocation() async =>
  //     await _preferences.remove(_doubleListKey);

  ///.... Save home location
  // static Future setHomeLocation(List<double> doubleList) async {
  //   List<String> stringList = doubleList.map((e) => e.toString()).toList();
  //   return await _preferences.setStringList(_homeListKey, stringList);
  // }

  // static List<double> getHomeLocation() {
  //   List<String> stringList = _preferences.getStringList(_homeListKey) ?? [];
  //   return stringList.map((e) => double.tryParse(e) ?? 0.0).toList();
  // }

  // static Future removeHomeLocation() async =>
  //     await _preferences.remove(_homeListKey);

  ///.... save radius
  static Future setRadius(double radius) async =>
      await _preferences.setDouble('radius', radius);

  static double? getRadius() => _preferences.getDouble('radius');

  static Future removeRadius() async => await _preferences.remove('radius');

  ///... set is email password login
  static Future setIsEmailLogin(bool isEmailLogin) async =>
      await _preferences.setBool('isEmailLogin', isEmailLogin);

  static bool getIsEmailLogin() =>
      _preferences.getBool('isEmailLogin') ?? false;

  ///... set is currect location is on
  // static Future setIsLocationOn(bool isLocationOn) async =>
  //     await _preferences.setBool('isLocationOn', isLocationOn);

  // static bool getIsLocationOn() => _preferences.getBool('isLocationOn') ?? true;

  ///.... save Authtype
  static Future setAuthtype(String authtype) async =>
      await _preferences.setString('authtype', authtype);

  static String? getAuthtype() => _preferences.getString('authtype');

  static Future removeAuthtype() async => await _preferences.remove('authtype');

  ////....setIsVerified
  static Future setIsVerified(bool isVerified) async =>
      await _preferences.setBool('isVerified', isVerified);

  static bool getIsVerified() => _preferences.getBool('isVerified') ?? false;

  ////...setIsPhoneVerified
  static Future setIsPhoneVerified(bool isVerified) async =>
      await _preferences.setBool('isPhoneVerified', isVerified);

  static bool getIsPhoneVerified() =>
      _preferences.getBool('isPhoneVerified') ?? false;

  ///...set and get isSkippedTutorial
  static Future setIsSkippedTutorial(bool isSkippedTutorial) async =>
      await _preferences.setBool('isSkippedTutorial', isSkippedTutorial);

  static bool getIsSkippedTutorial() =>
      _preferences.getBool('isSkippedTutorial') ?? false;

  ///....set and get isViewedTutorial
  static Future setIsViewedTutorial(bool isViewedTutorial) async =>
      await _preferences.setBool('isViewedTutorial', isViewedTutorial);

  static bool getIsViewedTutorial() =>
      _preferences.getBool('isViewedTutorial') ?? false;

  ///....set and get karma score
  static Future setKarmaScore(String karmaScore) async =>
      await _preferences.setString('karma', karmaScore);

  static String getKarmaScore() => _preferences.getString('karma') ?? '0';

////.... clear _preferences
  static Future<bool> clear() async {
    await _preferences.clear();
    return true;
  }
}

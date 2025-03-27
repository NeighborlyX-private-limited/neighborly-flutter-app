import 'package:shared_preferences/shared_preferences.dart';

class ShardPrefHelper {
  static late SharedPreferences _preferences;

  // KEYS
  static const String _fcmToken = 'fcmToken';
  static const String _cookie = 'cookies';
  static const String _accessToken = 'accessToken';
  static const String _userID = 'userID';
  static const String _userProfilePic = 'userProfilePic';
  static const String _userName = 'userName';
  static const String _email = 'email';
  static const String _phoneNumber = 'phoneNumber';
  static const String _isDobSet = 'isDobSet';
  static const String _gender = 'gender';
  static const String _isSkippedTutorial = 'isSkippedTutorial';
  static const String _isViewedTutorial = 'isViewedTutorial';
  static const String _isEmailLogin = 'isEmailLogin';
  static const String _isEmailVerified = 'isEmailVerified';
  static const String _isPhoneVerified = 'isPhoneVerified';
  static const String _authType = 'authType';
  static const String _latitude = 'latitude';
  static const String _longitude = 'longitude';
  static const String _city = 'city';
  static const String _isCurrentLocationOn = 'isCurrentLocationOn';
  static const String _languageKey = 'languageKey';
  static const String _radius = 'radius';
  static const String _karma = 'karma';
  static const String _findMe = 'findMe';
  static const String _appVersion = 'appVersion';
  static const String _activeChatRoomId = 'activeChatRoomId';

  // INIT
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  // SAVE FCM TOKEN
  static Future setFCMtoken(String newFCMToken) async =>
      await _preferences.setString(_fcmToken, newFCMToken);
  static String? getFCMtoken() => _preferences.getString(_fcmToken);

  // SAVE REFRESH TOKEN AS COOKIE
  static Future setCookie(String cookie) async =>
      await _preferences.setString(_cookie, cookie);
  static String? getCookie() => _preferences.getString(_cookie);
  static Future removeCookie() async => await _preferences.remove(_cookie);

  // SAVE ACCESS TOKEN
  static Future setAccessToken(String accessToken) async =>
      await _preferences.setString(_accessToken, accessToken);
  static String? getAccessToken() => _preferences.getString(_accessToken);
  static Future removeAccessToken() async =>
      await _preferences.remove(_accessToken);

  // SAVE USER ID
  static Future setUserID(String userId) async =>
      await _preferences.setString(_userID, userId);
  static String? getUserID() => _preferences.getString(_userID) ?? '';
  static Future removeUserID() async => await _preferences.remove(_userID);

  // SAVE USER PROFILE PIC
  static Future setUserProfilePicture(String userProfilePicture) async =>
      await _preferences.setString(_userProfilePic, userProfilePicture);
  static String? getUserProfilePicture() =>
      _preferences.getString(_userProfilePic);
  static Future removeUserProfilePicture() async =>
      await _preferences.remove(_userProfilePic);

  // SAVE USER NAME
  static Future setUsername(String username) async =>
      await _preferences.setString(_userName, username);
  static String? getUsername() => _preferences.getString(_userName);
  static Future removeUsername() async => await _preferences.remove(_userName);

  // SAVE USER EMAIL
  static Future setEmail(String email) async =>
      await _preferences.setString(_email, email);
  static String? getEmail() => _preferences.getString(_email);
  static Future removeEmail() async => await _preferences.remove(_email);

  // SAVE PHONE NUMBER
  static Future setPhoneNumber(String phoneNumber) async =>
      await _preferences.setString(_phoneNumber, phoneNumber);
  static String? getPhoneNumber() => _preferences.getString(_phoneNumber);
  static Future removePhoneNumber() async =>
      await _preferences.remove(_phoneNumber);

  // SAVE USER DOB IS SET OR NOT
  static Future setDob(bool isSet) async =>
      await _preferences.setBool(_isDobSet, isSet);
  static bool getDob() => _preferences.getBool(_isDobSet) ?? false;
  static Future removeDob() async => await _preferences.remove(_isDobSet);

  // SAVE GENDER
  static Future setGender(String gender) async =>
      await _preferences.setString(_gender, gender);
  static String? getGender() => _preferences.getString(_gender);
  static Future removeGender() async => await _preferences.remove(_gender);

  // SAVE IS SKIP TUTE
  static Future setIsSkippedTutorial(bool isSkippedTutorial) async =>
      await _preferences.setBool(_isSkippedTutorial, isSkippedTutorial);
  static bool getIsSkippedTutorial() =>
      _preferences.getBool(_isSkippedTutorial) ?? false;

  // SAVE IS VIEW TUTE
  static Future setIsViewedTutorial(bool isViewedTutorial) async =>
      await _preferences.setBool(_isViewedTutorial, isViewedTutorial);
  static bool getIsViewedTutorial() =>
      _preferences.getBool(_isViewedTutorial) ?? false;

  // SAVE IS EMAIL AND PASS LOGIN
  static Future setIsEmailLogin(bool isEmailLogin) async =>
      await _preferences.setBool(_isEmailLogin, isEmailLogin);
  static bool getIsEmailLogin() => _preferences.getBool(_isEmailLogin) ?? false;

  // SAVE IS EMAIL IS VERIFIED
  static Future setIsVerified(bool isVerified) async =>
      await _preferences.setBool(_isEmailVerified, isVerified);
  static bool getIsVerified() =>
      _preferences.getBool(_isEmailVerified) ?? false;

  // SAVE IS PHONE NUMBER IS VERIFIED
  static Future setIsPhoneVerified(bool isVerified) async =>
      await _preferences.setBool(_isPhoneVerified, isVerified);
  static bool getIsPhoneVerified() =>
      _preferences.getBool(_isPhoneVerified) ?? false;

  // SAVE AUTH TYPE
  static Future setAuthtype(String authtype) async =>
      await _preferences.setString(_authType, authtype);
  static String? getAuthtype() => _preferences.getString(_authType);
  static Future removeAuthtype() async => await _preferences.remove(_authType);

  // SAVE LATITUDE
  static Future<void> setLat(double lat) async =>
      await _preferences.setDouble(_latitude, lat);
  static double? getLat() => _preferences.getDouble(_latitude);
  static Future<void> removeLat() async => await _preferences.remove(_latitude);

  // SAVE LONGITUDE
  static Future<void> setLng(double lng) async =>
      await _preferences.setDouble(_longitude, lng);
  static double? getLng() => _preferences.getDouble(_longitude);
  static Future<void> removeLng() async =>
      await _preferences.remove(_longitude);

  // SAVE CITY
  static Future<void> setCity(String city) async =>
      await _preferences.setString(_city, city);
  static String? getCity() => _preferences.getString(_city);
  static Future<void> removeCity() async => await _preferences.remove(_city);

  // SAVE IS CURRENT LOCATION IS ON
  static Future<void> setIsCurrentLocationOn(bool isCurrent) async =>
      await _preferences.setBool(_isCurrentLocationOn, isCurrent);
  static bool? getIsCurrentLocationOn() =>
      _preferences.getBool(_isCurrentLocationOn);
  static Future<void> removeCurrent() async =>
      await _preferences.remove(_isCurrentLocationOn);

  // SAVE APP LANGUGAE
  static Future setLanguage(String language) async =>
      await _preferences.setString(_languageKey, language);
  static String? getLanguage() => _preferences.getString(_languageKey) ?? 'en';
  static Future removeLanguage() async =>
      await _preferences.remove(_languageKey);

  // SAVE RADIUS
  static Future setRadius(double radius) async =>
      await _preferences.setDouble(_radius, radius);
  static double? getRadius() => _preferences.getDouble(_radius);
  static Future removeRadius() async => await _preferences.remove(_radius);

  // SAVE KARMA SCORE
  static Future setKarmaScore(String karmaScore) async =>
      await _preferences.setString(_karma, karmaScore);
  static String getKarmaScore() => _preferences.getString(_karma) ?? '0';

  // SAVE APP VERSION
  static Future setAppVersion(String newVersion) async =>
      await _preferences.setString(_appVersion, newVersion);
  static String? getAppVersion() => _preferences.getString(_appVersion);

  // SAVE ACTIVE CHAT ROOM ID
  static Future setActiveChatRoomId(String roomId) async =>
      await _preferences.setString(_activeChatRoomId, roomId);
  static String? getActiveChatRoomId() =>
      _preferences.getString(_activeChatRoomId);
  static Future removeActiveChatRoomId() async =>
      await _preferences.remove(_activeChatRoomId);

  // SAVE FIND ME
  static Future setFineMe(bool fineMe) async =>
      await _preferences.setBool(_findMe, fineMe);
  static bool getFineMe() => _preferences.getBool(_findMe) ?? true;

// CLEAR ALL SAVED DATA
  static Future<bool> clear() async {
    await _preferences.clear();
    return true;
  }
}

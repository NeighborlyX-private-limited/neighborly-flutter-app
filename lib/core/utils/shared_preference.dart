import 'package:shared_preferences/shared_preferences.dart';

class ShardPrefHelper {
  static late SharedPreferences _preferences;
  static const String _cookie = 'cookies';
  static const String _accessToken = 'accessToken';
  static const String _refreshToken = 'refreshToken';
  static const String _userID = 'userID';
  static const String _doubleListKey = 'doubleList';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setAccessToken(String accessToken) async =>
      await _preferences.setString(_accessToken, accessToken);
  static String? getAccessToken() => _preferences.getString(_accessToken) ?? '';
  static Future removeAccessToken() async =>
      await _preferences.remove(_accessToken);

  static Future setRefreshToken(String refreshToken) async =>
      await _preferences.setString(_refreshToken, refreshToken);
  static String? getRefreshToken() =>
      _preferences.getString(_refreshToken) ?? '';
  static Future removeRefreshToken() async =>
      await _preferences.remove(_refreshToken);

  // save cookies
  static Future setCookie(List<String> cookie) async =>
      await _preferences.setStringList(_cookie, cookie);
  static List<String>? getCookie() => _preferences.getStringList(_cookie) ?? [];
  static Future removeCookie() async => await _preferences.remove(_cookie);

  // save image url
  static Future setImageUrl(String imageUrl) async =>
      await _preferences.setString('imageUrl', imageUrl);
  static String? getImageUrl() => _preferences.getString('imageUrl');

  // remove image url
  static Future removeImageUrl() async => await _preferences.remove('imageUrl');

  // save userID
  static Future setUserID(String userId) async =>
      await _preferences.setString(_userID, userId);
  static String? getUserID() => _preferences.getString(_userID);
  static Future removeUserID() async => await _preferences.remove(_userID);

  // save gender
  static Future setGender(String gender) async =>
      await _preferences.setString('gender', gender);
  static String? getGender() => _preferences.getString('gender');
  static Future removeGender() async => await _preferences.remove('gender');

  // save userProfilePicture
  static Future setUserProfilePicture(String userProfilePicture) async =>
      await _preferences.setString('userProfilePicture', userProfilePicture);
  static String? getUserProfilePicture() =>
      _preferences.getString('userProfilePicture');
  static Future removeUserProfilePicture() async =>
      await _preferences.remove('userProfilePicture');

  // save username
  static Future setUsername(String username) async =>
      await _preferences.setString('username', username);
  static String? getUsername() => _preferences.getString('username');
  static Future removeUsername() async => await _preferences.remove('username');

  // save phoneNumber
  static Future setPhoneNumber(String phoneNumber) async =>
      await _preferences.setString('phoneNumber', phoneNumber);
  static String? getPhoneNumber() => _preferences.getString('phoneNumber');
  static Future removePhoneNumber() async =>
      await _preferences.remove('phoneNumber');

  // FCM token
  static Future setFCMtoken(String newToken) async =>
      await _preferences.setString('FCMtoken', newToken);
  static String? getFCMtoken() => _preferences.getString('FCMtoken');

  // save email
  static Future setEmail(String email) async =>
      await _preferences.setString('email', email);
  static String? getEmail() => _preferences.getString('email');
  static Future removeEmail() async => await _preferences.remove('email');

  // Save location
  static Future setLocation(List<double> doubleList) async {
    List<String> stringList = doubleList.map((e) => e.toString()).toList();
    return await _preferences.setStringList(_doubleListKey, stringList);
  }

// set is currect location is on
  static Future setIsLocationOn(bool isLocationOn) async =>
      await _preferences.setBool('isLocationOn', isLocationOn);
  static bool getIsLocationOn() =>
      _preferences.getBool('isLocationOn') ?? false;

  static List<double> getLocation() {
    List<String> stringList = _preferences.getStringList(_doubleListKey) ?? [];
    return stringList.map((e) => double.tryParse(e) ?? 0.0).toList();
  }

  static Future removeLocation() async =>
      await _preferences.remove(_doubleListKey);

  //set and get isVerified
  static Future setIsVerified(bool isVerified) async =>
      await _preferences.setBool('isVerified', isVerified);
  static bool getIsVerified() => _preferences.getBool('isVerified') ?? false;

  //set and get isSkippedTutorial
  static Future setIsSkippedTutorial(bool isSkippedTutorial) async =>
      await _preferences.setBool('isSkippedTutorial', isSkippedTutorial);
  static bool getIsSkippedTutorial() =>
      _preferences.getBool('isSkippedTutorial') ?? false;

  //set and get isViewedTutorial
  static Future setIsViewedTutorial(bool isViewedTutorial) async =>
      await _preferences.setBool('isViewedTutorial', isViewedTutorial);
  static bool getIsViewedTutorial() =>
      _preferences.getBool('isViewedTutorial') ?? false;

  // // save is cheered
  // static Future setIsCheered(String userId, num postId, bool isLiked) async =>
  //     await _preferences.setBool('$userId-${postId}_isCheered', isLiked);
  // static bool? getIsCheered(String userId, String postId) =>
  //     _preferences.getBool('$userId-${postId}_isCheered');
  // static Future<void> deleteCheeredPosts(String userId) async {
  //   final keys = _preferences.getKeys();
  //   final cheeredKeys = keys.where(
  //       (key) => key.startsWith('$userId-') && key.endsWith('_isCheered'));

  //   for (var key in cheeredKeys) {
  //     if (_preferences.getBool(key) == true) {
  //       await _preferences.remove(key);
  //     }
  //   }
  // }

  // // save is  boo
  // static Future setIsBoo(String userId, num postId, bool isLiked) async =>
  //     await _preferences.setBool('$userId-${postId}_isBoo', isLiked);
  // static bool? getIsBoo(String userId, String postId) =>
  //     _preferences.getBool('$userId-${postId}_isBoo');
  // static Future<void> deleteBooPosts(String userId) async {
  //   final keys = _preferences.getKeys();
  //   final booKeys = keys
  //       .where((key) => key.startsWith('$userId-') && key.endsWith('_isBoo'));

  //   for (var key in booKeys) {
  //     if (_preferences.getBool(key) == true) {
  //       await _preferences.remove(key);
  //     }
  //   }
  // }

  // // save poll vote
  // static Future setPollVote(
  //         String userId, num pollId, num voteId, bool vote) async =>
  //     await _preferences.setBool('$userId-$pollId-$voteId-_pollVote', vote);
  // static bool? getPollVote(String userId, num pollId, num voteId) =>
  //     _preferences.getBool('$userId-$pollId-$voteId-_pollVote');
  // static Future<void> deltePollVotes(String userId) async {
  //   final keys = _preferences.getKeys();
  //   final voteKeys = keys.where(
  //       (key) => key.startsWith('$userId-') && key.endsWith('_pollVote'));

  //   for (var key in voteKeys) {
  //     if (_preferences.getBool(key) == true) {
  //       await _preferences.remove(key);
  //     }
  //   }
  // }

  static Future<bool> clear() async {
    await _preferences.clear();
    print('SharedPref cleared');
    return true;
  }
}

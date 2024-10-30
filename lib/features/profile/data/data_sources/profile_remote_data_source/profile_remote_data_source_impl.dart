import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/models/post_model.dart';
import '../../../../../core/utils/shared_preference.dart';
import '../../models/auth_response_model.dart';
import '../../models/post_with_comments_model.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;

  ProfileRemoteDataSourceImpl({required this.client});
  @override
  Future<String> changePassword({
    String? currentPassword,
    required String newPassword,
    required String email,
    required bool flag,
  }) async {
    print('changePassword start with...');
    print('currentPassword: $currentPassword');
    print('newPassword: $newPassword');
    print('email: $email');

    Map<String, dynamic> queryParameters = {
      'newPassword': newPassword,
      'email': email,
      'flag': flag,
    };
    if (currentPassword != null) {
      queryParameters['currentPassword'] = currentPassword;
    }
    String url = '$kBaseUrl/user/change-password';
    print('url: $url');

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(queryParameters),
    );
    print('changePassword response status code: ${response.statusCode}');
    print('changePassword response: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['msg'];
    } else if (response.statusCode == 401) {
      print(
          'changePassword else if error: ${jsonDecode(response.body)['msg']}');
      throw ServerException(
          message: jsonDecode(response.body)['msg'] ?? 'Something went wrong');
    } else {
      print('changePassword else error: ${jsonDecode(response.body)['error']}');
      throw ServerException(
          message:
              jsonDecode(response.body)['error'] ?? 'Something went wrong');
    }
  }

  @override
  Future<void> updateLocation({
    required Map<String, List<num>> location,
  }) async {
    print('updateLocation start with...');
    print('location: $location');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in updateLocation');
      throw const ServerException(message: 'Something went wrong');
    }
    var city = ShardPrefHelper.getCurrentCity();
    print('city: $city');
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/user/update-user-location/$city';
    print('url: $url');

    final response = await client.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      //body: jsonEncode(location));
    );

    print("updateLocation response status code: ${response.statusCode}");
    print("updateLocation response: ${jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      print('location update successfully');
    }
    if (response.statusCode != 200) {
      print('updateLocation else error: ${jsonDecode(response.body)['error']}');
      throw ServerException(
          message:
              jsonDecode(response.body)['error'] ?? 'Something went wrong');
    }
  }

  @override
  Future<void> getGenderAndDOB({String? gender, String? dob}) async {
    print('getGenderAndDOB start with...');
    print('gender: $gender');
    print('dob: $dob');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in getGenderAndDOB');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/user/update-user-dob';
    print('url: $url');
    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode({'dob': dob}),
    );
    print("getGenderAndDOB response status code: ${response.statusCode}");
    print("getGenderAndDOB response: ${jsonDecode(response.body)}");
    if (response.statusCode != 200) {
      print(
          'getGenderAndDOB else error: ${jsonDecode(response.body)['message']}');

      throw ServerException(
          message:
              jsonDecode(response.body)['message'] ?? 'Something went wrong');
    }
  }

  @override
  Future<AuthResponseModel> getProfile() async {
    print('getProfile start...');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in getProfile');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/user-info';
    print('url: $url');

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
    );
    print("getProfile response status code: ${response.statusCode}");
    print("getProfile response: ${jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      print('getProfile else error: ${jsonDecode(response.body)['error']}');
      throw ServerException(
          message:
              jsonDecode(response.body)['error'] ?? 'Something went wrong');
    }
  }

  @override
  Future<void> logout() async {
    print('logout start...');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in logout');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/authentication/logout';
    print('url: $url');
    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
    );
    print("logout response status code: ${response.statusCode}");
    print("logout response: ${response.body}}");
    if (response.statusCode == 200) {
      ShardPrefHelper.setIsLocationOn(false);
    }
    if (response.statusCode != 200) {
      print('getProfile else error: ${jsonDecode(response.body)['error']}');
      throw ServerException(
          message: jsonDecode(response.body)['msg'] ?? 'Something went wrong');
    }
  }

  @override
  Future<List<PostModel>> getMyPosts({
    String? userId,
  }) async {
    print('getMyPosts start with...');
    print('userId: $userId');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in getMyPosts');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/user-content';
    print('url: $url');
    Map<String, dynamic> queryParameters = {'userId': userId};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );
    print("getMyPosts response status code: ${response.statusCode}");
    print("getMyPosts response: ${jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => PostModel.fromJson(data)).toList();
    } else {
      print('getMyPosts else error: ${jsonDecode(response.body)['msg']}');
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> sendFeedback({required String feedback}) async {
    print('sendFeedback start with...');
    print('feedback: $feedback');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in sendFeedback');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/send-feedback';
    print('url: $url');
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode({'feedbackText': feedback}),
    );
    print("sendFeedback response status code: ${response.statusCode}");
    print("sendFeedback response: ${jsonDecode(response.body)}");
    if (response.statusCode != 200) {
      print('sendFeedback else error: ${jsonDecode(response.body)['error']}');
      final message =
          jsonDecode(response.body)['error'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> deleteAccount() async {
    print('deleteAccount start...');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in deleteAccount');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/delete-account';
    print('url: $url');
    final response = await client.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
    );
    print("deleteAccount response status code: ${response.statusCode}");
    print("deleteAccount response: ${jsonDecode(response.body)}");
    if (response.statusCode != 200) {
      print('deleteAccount else error: ${jsonDecode(response.body)['error']}');
      final message =
          jsonDecode(response.body)['error'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<AuthResponseModel> getUserInfo({required String userId}) async {
    print('getUserInfo start with...');
    print('userId: $userId');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in getUserInfo');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/user-info';
    print('url: $url');
    Map<String, dynamic> queryParameters = {'userId': userId};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );
    print("getUserInfo response status code: ${response.statusCode}");
    print("getUserInfos response: ${jsonDecode(response.body)}");

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      print('getUserInfo else error: ${jsonDecode(response.body)['error']}');
      final message =
          jsonDecode(response.body)['error'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<List<PostWithCommentsModel>> getMyComments({String? userId}) async {
    print('getMyComments start with...');
    print('userId: $userId');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in getMyComments');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/user-comments';
    print('url: $url');
    Map<String, dynamic> queryParameters = {'userId': userId};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );
    print("getMyComments response status code: ${response.statusCode}");
    print("getMyComments response: ${jsonDecode(response.body)}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)['comments'];
      return jsonData
          .map((data) => PostWithCommentsModel.fromJson(data))
          .toList();
    } else {
      print('getMyComments else error: ${jsonDecode(response.body)['error']}');
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<List> getMyGroups({String? userId}) async {
    print('getMyGroups start with...');
    print('userId: $userId');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in getMyGroups');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/user-groups';
    print('url: $url');
    Map<String, dynamic> queryParameters = {'userId': userId};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );
    print("getMyGroups response status code: ${response.statusCode}");
    print("getMyGroups response: ${jsonDecode(response.body)}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['groups'];
    } else {
      print('getMyGroups else error: ${jsonDecode(response.body)['msg']}');
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> editProfile({
    String? username,
    String? gender,
    String? bio,
    File? image,
    String? phoneNumber,
    bool? toggleFindMe,
    //  List<d?ouble> homeCoordinates,
  }) async {
    print('editProfile start with...');
    print('username: $username');
    print('gender: $gender');
    print('bio: $bio');
    print('image: $image');
    print('phoneNumber: $phoneNumber');
    print('toggleFindMe: $toggleFindMe');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in editProfile');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/edit-user-info';
    print('url: $url');
    final request = http.MultipartRequest('PUT', Uri.parse(url))
      ..headers['Cookie'] = cookieHeader
      ..fields['username'] = username ?? ShardPrefHelper.getUsername()!
      ..fields['bio'] = bio ?? ''
      ..fields['phoneNumber'] = phoneNumber ?? ''
      ..fields['toggleFindMe'] = toggleFindMe.toString()
      // ..fields['homeCoordinates'] = homeCoordinates.join(',')
      ..fields['gender'] = gender ?? '';
    if (image != null) {
      request.files.add(
        http.MultipartFile(
          'file',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: image.path.split('/').last,
        ),
      );
    }

    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    print("editProfile response status code: ${response.statusCode}");
    print("editProfile response: ${jsonDecode(responseString)}");
    if (response.statusCode != 200) {
      print('editProfile else error: ${jsonDecode(responseString)['message']}');
      throw ServerException(
          message:
              jsonDecode(responseString)['message'] ?? 'Something went wrong');
    }
  }

  @override
  Future<List> getMyAwards() async {
    print('getMyAwards start...');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/user-awards';
    print('url: $url');
    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );
    print("getMyAwards response status code: ${response.statusCode}");
    print("getMyAwards response: ${jsonDecode(response.body)}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['awards'];
    } else {
      print('getMyAwards else error: ${jsonDecode(response.body)['msg']}');
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }
}

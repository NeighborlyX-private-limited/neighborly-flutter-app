import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/models/post_model.dart';
import '../../../../../core/utils/set_auth.dart';
import '../../../../../core/utils/shared_preference.dart';
import '../../models/auth_response_model.dart';
import '../../models/post_with_comments_model.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;

  ProfileRemoteDataSourceImpl({required this.client});
  // CHANGE PASSWORD
  @override
  Future<String> changePassword({
    String? currentPassword,
    required String newPassword,
    required String email,
    required bool flag,
  }) async {
    Map<String, dynamic> queryParameters = {
      'newPassword': newPassword,
      'email': email,
      'flag': flag,
    };
    if (currentPassword != null) {
      queryParameters['currentPassword'] = currentPassword;
    }
    String url = '$kBaseUrl/user/change-password';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(queryParameters),
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return jsonDecode(response.body)['msg'];
    } else if (response.statusCode == 401) {
      throw ServerException(
          message:
              jsonDecode(response.body)['msg'] ?? 'oops something went wrong');
    } else {
      throw ServerException(
          message: jsonDecode(response.body)['error'] ??
              'oops something went wrong');
    }
  }

  @override
  Future<void> updateLocation({
    required Map<String, List<num>> location,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    // var city = ShardPrefHelper.getCurrentCity();

    // //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '$kBaseUrl/user/update-user-location';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      //body: jsonEncode(location));
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
    }
    if (response.statusCode != 200) {
      throw ServerException(
          message: jsonDecode(response.body)['error'] ??
              'oops something went wrong');
    }
  }

  @override
  Future<void> getGenderAndDOB({String? gender, String? dob}) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    // //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '$kBaseUrl/user/update-user-dob';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode({'dob': dob}),
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      ShardPrefHelper.setDob(true);
    }
    if (response.statusCode != 200) {
      if (jsonDecode(response.body)['message']
          .toString()
          .contains('DOB can only be set once.')) {
        ShardPrefHelper.setDob(true);
      }

      throw ServerException(
          message: jsonDecode(response.body)['message'] ??
              'oops something went wrong');
    }
  }

  @override
  Future<AuthResponseModel> getProfile() async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '$kBaseUrl/profile/user-info';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
          message: jsonDecode(response.body)['error'] ??
              'oops something went wrong');
    }
  }

  @override
  Future<void> logout() async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '$kBaseUrl/authentication/logout';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      // ShardPrefHelper.setIsLocationOn(false);
    }
    if (response.statusCode != 200) {
      throw ServerException(
          message:
              jsonDecode(response.body)['msg'] ?? 'oops something went wrong');
    }
  }

  @override
  Future<List<PostModel>> getMyPosts({
    String? userId,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '$kBaseUrl/profile/user-content';

    Map<String, dynamic> queryParameters = {'userId': userId};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => PostModel.fromJson(data)).toList();
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> sendFeedback({required String feedback}) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '$kBaseUrl/profile/send-feedback';

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode({'feedbackText': feedback}),
    );

    if (response.statusCode != 200) {
      final message =
          jsonDecode(response.body)['error'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> deleteAccount() async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    // print('cookies: $cookieHeader');
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

    //String cookieHeader = cookies.join('; '); cookies.join('; ');
    // print('cookies: $cookieHeader');
    String url = '$kBaseUrl/profile/delete-account';

    final response = await client.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    print('delete: ${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
    }
    if (response.statusCode != 200) {
      final message = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['msg'] ??
          'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<AuthResponseModel> getUserInfo({required String userId}) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '$kBaseUrl/profile/user-info';

    Map<String, dynamic> queryParameters = {'userId': userId};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      final message =
          jsonDecode(response.body)['error'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<List<PostWithCommentsModel>> getMyComments({String? userId}) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '$kBaseUrl/profile/user-comments';

    Map<String, dynamic> queryParameters = {'userId': userId};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    print('comment res: ${jsonDecode(response.body)}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final List<dynamic> jsonData = jsonDecode(response.body)['comments'];
      return jsonData
          .map((data) => PostWithCommentsModel.fromJson(data))
          .toList();
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<List> getMyGroups({String? userId}) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '$kBaseUrl/profile/user-groups';

    Map<String, dynamic> queryParameters = {'userId': userId};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return jsonDecode(response.body)['groups'];
    } else {
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
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    //String cookieHeader = cookies.join('; '); cookies.join('; ');
    String url = '$kBaseUrl/profile/edit-user-info';

    final request = http.MultipartRequest('PUT', Uri.parse(url))
      ..headers['Cookie'] = cookies
      ..fields['username'] = username ?? ShardPrefHelper.getUsername()!
      ..fields['bio'] = bio ?? ''
      ..fields['phoneNumber'] = phoneNumber ?? ''
      ..fields['toggleFindMe'] = toggleFindMe.toString()
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

    if (response.statusCode != 200) {
      throw ServerException(
          message: jsonDecode(responseString)['message'] ??
              'oops something went wrong');
    }
  }

// GET AWARDS
  @override
  Future<List> getMyAwards() async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }

    String url = '$kBaseUrl/profile/user-awards';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return jsonDecode(response.body)['awards'];
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops someting went wrong';
      throw ServerException(message: message);
    }
  }
}

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
      return jsonDecode(response.body)['msg'];
    } else if (response.statusCode == 401) {
      throw ServerException(
          message: jsonDecode(response.body)['msg'] ?? 'Something went wrong');
    } else {
      throw ServerException(
          message:
              jsonDecode(response.body)['error'] ?? 'Something went wrong');
    }
  }

  @override
  Future<void> updateLocation({
    required Map<String, List<num>> location,
  }) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Something went wrong');
    }
    var city = ShardPrefHelper.getCurrentCity();

    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/user/update-user-location/$city';

    final response = await client.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      //body: jsonEncode(location));
    );

    if (response.statusCode == 200) {}
    if (response.statusCode != 200) {
      throw ServerException(
          message:
              jsonDecode(response.body)['error'] ?? 'Something went wrong');
    }
  }

  @override
  Future<void> getGenderAndDOB({String? gender, String? dob}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/user/update-user-dob';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode({'dob': dob}),
    );

    if (response.statusCode == 200) {
      ShardPrefHelper.setDob(true);
    }
    if (response.statusCode != 200) {
      if (jsonDecode(response.body)['message']
          .toString()
          .contains('DOB can only be set once.')) {
        ShardPrefHelper.setDob(true);
      }

      throw ServerException(
          message:
              jsonDecode(response.body)['message'] ?? 'Something went wrong');
    }
  }

  @override
  Future<AuthResponseModel> getProfile() async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/user-info';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
          message:
              jsonDecode(response.body)['error'] ?? 'Something went wrong');
    }
  }

  @override
  Future<void> logout() async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/authentication/logout';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {
      ShardPrefHelper.setIsLocationOn(false);
    }
    if (response.statusCode != 200) {
      throw ServerException(
          message: jsonDecode(response.body)['msg'] ?? 'Something went wrong');
    }
  }

  @override
  Future<List<PostModel>> getMyPosts({
    String? userId,
  }) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/user-content';

    Map<String, dynamic> queryParameters = {'userId': userId};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => PostModel.fromJson(data)).toList();
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> sendFeedback({required String feedback}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/send-feedback';

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
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
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/delete-account';

    final response = await client.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {}
    if (response.statusCode != 200) {
      final message = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['msg'] ??
          'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<AuthResponseModel> getUserInfo({required String userId}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/user-info';

    Map<String, dynamic> queryParameters = {'userId': userId};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      final message =
          jsonDecode(response.body)['error'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<List<PostWithCommentsModel>> getMyComments({String? userId}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/user-comments';

    Map<String, dynamic> queryParameters = {'userId': userId};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {
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
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/user-groups';

    Map<String, dynamic> queryParameters = {'userId': userId};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {
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
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/edit-user-info';

    final request = http.MultipartRequest('PUT', Uri.parse(url))
      ..headers['Cookie'] = cookieHeader
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
          message:
              jsonDecode(responseString)['message'] ?? 'Something went wrong');
    }
  }

  @override
  Future<List> getMyAwards() async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/profile/user-awards';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['awards'];
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }
}

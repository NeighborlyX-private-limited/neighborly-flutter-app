import 'dart:convert';
import 'dart:io';

import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

import 'upload_remote_data_source.dart';

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final http.Client client;

  UploadRemoteDataSourceImpl({required this.client});

  @override
  Future<void> uploadPost({
    required String title,
    String? content,
    required String type,
    File? multimedia,
    required String city,
    List<dynamic>? options,
    required bool allowMultipleVotes,
  }) async {
    // Retrieve cookies
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/create-post';

    // Create a multipart request
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers['Cookie'] = cookieHeader
      ..fields['title'] = title
      ..fields['content'] = content ?? ''
      ..fields['type'] = type
      ..fields['city'] = city
      ..fields['pollOptions'] = jsonEncode(options ?? [])
      ..fields['allowMultipleVotes'] = allowMultipleVotes.toString();

    // Add multimedia file if available
    if (multimedia != null) {
      request.files.add(
        http.MultipartFile(
          'file', // Field name for the file
          multimedia.readAsBytes().asStream(),
          multimedia.lengthSync(),
          filename: multimedia.path.split('/').last,
        ),
      );
    }

    // Send the request and handle the response
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print('Post uploaded successfully');
    } else {
      final errorMessage = jsonDecode(responseString)['error'];
      throw ServerException(message: errorMessage);
    }
  }

  @override
  Future<String> uploadFile({required File file}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/user/upload-file';

    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers['Cookie'] = cookieHeader
      ..files.add(
        http.MultipartFile(
          'file',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split('/').last,
        ),
      );

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseString)['url'];
    } else {
      throw ServerException(message: jsonDecode(responseString)['message']);
    }
  }
}

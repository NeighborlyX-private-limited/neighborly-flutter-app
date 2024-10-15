import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/utils/shared_preference.dart';
import 'upload_remote_data_source.dart';

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final http.Client client;

  UploadRemoteDataSourceImpl({required this.client});
  @override
  Future<void> uploadPost({
    required String title,
    required List<double> location,
    String? content,
    required String type,
    List<File>? multimedia, // List of File objects directly from the device
    required String city,
    List<dynamic>? options,
    required bool allowMultipleVotes,
  }) async {
    // Retrieve cookies
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }

    print('_selectedImage path in uploadPost fn: $multimedia');
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/create-post';
    var isLocationOn = ShardPrefHelper.getIsLocationOn();
    var isHome = isLocationOn ? 'false' : 'true';

    print('isHome in uploadPost ==> $isHome');
    Map<String, dynamic> queryParameters = {'home': isHome};
    print("City from post upload: $city");
    print("Location: $location");

    // Create a multipart request
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(url).replace(queryParameters: queryParameters),
    )
      ..headers['Cookie'] = cookieHeader
      ..fields['title'] = title
      ..fields['content'] = content ?? ''
      ..fields['type'] = type
      ..fields['city'] = city
      ..fields['pollOptions'] = jsonEncode(options ?? [])
      ..fields['location[0]'] = location[0].toString()
      ..fields['location[1]'] = location[1].toString()
      ..fields['allowMultipleVotes'] = allowMultipleVotes.toString();

    // Add multimedia files if available
    if (multimedia != null && multimedia.isNotEmpty) {
      for (var file in multimedia) {
        request.files.add(
          http.MultipartFile(
            'files', // Ensure this field name matches what your backend expects for files
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename:
                file.path.split('/').last, // Get the filename from the path
          ),
        );
      }
    }

    // Debug: Print the request fields for verification
    print('Request Fields:');
    request.fields.forEach((key, value) {
      print('$key: $value');
    });

    // Send the request and handle the response
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    print('Post uploaded response: $responseString');
    if (response.statusCode == 403) {
      throw responseString;
    }
    if (response.statusCode == 200) {
      print('Post uploaded successfully');
    } else {
      print('Post uploaded error');
      final errorMessage =
          jsonDecode(responseString)['message'] ?? 'Unknown error';
      throw ServerException(message: errorMessage);
    }
  }

  @override
  Future<String> uploadFile({required File file}) async {
    print('uploadFile fun call');
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
      print('image s3 url: ${jsonDecode(responseString)['url']}');
      return jsonDecode(responseString)['url'];
    } else {
      throw ServerException(message: jsonDecode(responseString)['message']);
    }
  }
}

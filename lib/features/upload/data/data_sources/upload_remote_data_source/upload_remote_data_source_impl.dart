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
    List<File>? multimedia,
    required String city,
    List<dynamic>? options,
    required bool allowMultipleVotes,
    File? thumbnail,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

    // String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/create-post';

    var isLocationOn = ShardPrefHelper.getIsLocationOn();
    var isHome = isLocationOn ? 'false' : 'true';

    Map<String, dynamic> queryParameters = {'home': isHome};

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(url).replace(queryParameters: queryParameters),
    )
      // ..headers['Authorization'] = 'Bearer $accessToken'
      ..headers['Cookie'] = cookies
      ..fields['title'] = title
      ..fields['content'] = content ?? ''
      ..fields['type'] = type
      ..fields['city'] = city
      ..fields['pollOptions'] = jsonEncode(options ?? [])
      ..fields['location[0]'] = location[0].toString()
      ..fields['location[1]'] = location[1].toString()
      ..fields['allowMultipleVotes'] = allowMultipleVotes.toString();

    /// Add multimedia files if available
    if (multimedia != null && multimedia.isNotEmpty) {
      for (var file in multimedia) {
        request.files.add(
          http.MultipartFile(
            'files',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: file.path.split('/').last,
          ),
        );
      }
    }

    /// Add the thumbnail file if available
    if (thumbnail != null) {
      request.files.add(
        http.MultipartFile(
          'thumbnail',
          thumbnail.readAsBytes().asStream(),
          thumbnail.lengthSync(),
          filename: thumbnail.path.split('/').last,
        ),
      );
    }

    request.fields.forEach((key, value) {});

    /// Send the request and handle the response
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    print('error HERE: ${response.statusCode}.');
    if (response.statusCode == 403) {
      throw responseString;
    }
    if (response.statusCode == 200) {
    } else {
      final errorMessage =
          jsonDecode(responseString)['message'] ?? 'oops something went wrong';
      print('error: $errorMessage');
      throw ServerException(message: errorMessage);
    }
  }

  @override
  Future<String> uploadFile({required File file}) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    // String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/user/upload-file';

    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers['Cookie'] = cookies
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
      throw ServerException(
          message: jsonDecode(responseString)['message'] ??
              'oops something went wrong');
    }
  }
}

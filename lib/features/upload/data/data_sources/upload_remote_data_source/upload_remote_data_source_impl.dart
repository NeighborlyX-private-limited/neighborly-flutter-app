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
  // UPLOAD POST
  @override
  Future<void> uploadPost({
    required String type,
    required String title,
    String? content,
    List<dynamic>? options,
    required bool allowMultipleVotes,
    List<File>? multimedia,
    File? thumbnail,
    required List<double> location,
    required String city,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    var city = ShardPrefHelper.getCity() ?? '';
    var lat = ShardPrefHelper.getLat();
    var lng = ShardPrefHelper.getLng();
    print('LAT,LNG AND CITY IN UPLOAD POST :$lat $lng $city');

    String url = '$kBaseUrl/wall/create-post';

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    )
      ..headers['Cookie'] = cookies
      ..fields['title'] = title
      ..fields['content'] = content ?? ''
      ..fields['type'] = type
      ..fields['pollOptions'] = jsonEncode(options ?? [])
      ..fields['city'] = city
      ..fields['location[0]'] = lat.toString()
      ..fields['location[1]'] = lng.toString()
      ..fields['allowMultipleVotes'] = allowMultipleVotes.toString();

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

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    print('UPLOAD POST STATUS CODE: ${response.statusCode}.');
    print('UPLOAD POST RESPONSE: $responseString');
    if (response.statusCode == 403) {
      throw responseString;
    }
    if (response.statusCode == 200) {
    } else {
      String errorMessage = jsonDecode(responseString)['message'] ??
          jsonDecode(responseString)['error'] ??
          jsonDecode(responseString)['msg'] ??
          'oops something went wrong';
      throw ServerException(message: errorMessage);
    }
  }

// UPLOAD FILE
  @override
  Future<String> uploadFile({required File file}) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

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
      String errorMessage = jsonDecode(responseString)['message'] ??
          jsonDecode(responseString)['error'] ??
          jsonDecode(responseString)['msg'] ??
          'oops something went wrong';
      throw ServerException(message: errorMessage);
    }
  }
}

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
    print('...uploadPost start with');
    print('title:$title');
    print('content:$content');
    print('type:$type');
    print('location:$location');
    print('city:$city');
    print('options:$options');
    print('allowMultipleVotes:$allowMultipleVotes');
    print('multimedia:$multimedia');
    print('thumbnail:$thumbnail');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('No cookies found in uploadPost ');
      throw const ServerException(message: 'Something went wrong');
    }

    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/create-post';
    print('url:$url');
    var isLocationOn = ShardPrefHelper.getIsLocationOn();
    var isHome = isLocationOn ? 'false' : 'true';

    print('isHome in uploadPost: $isHome');
    Map<String, dynamic> queryParameters = {'home': isHome};

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
    print('Request Fields:');
    request.fields.forEach((key, value) {
      print('$key: $value');
    });

    /// Send the request and handle the response
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    print('Post uploaded response status code: ${response.statusCode}');
    print('Post uploaded response: $responseString');
    if (response.statusCode == 403) {
      throw responseString;
    }
    if (response.statusCode == 200) {
      print('Post uploaded successfully...');
    } else {
      print(
          'else error in Post uploaded: ${jsonDecode(responseString)['message']}');
      final errorMessage =
          jsonDecode(responseString)['message'] ?? 'Something went wrong';
      throw ServerException(message: errorMessage);
    }
  }

  @override
  Future<String> uploadFile({required File file}) async {
    print('...uploadFile start with');
    print('file:$file');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('No cookies found in uploadFile ');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/user/upload-file';
    print('url:$url');

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
    print('uploadFile response status code: ${response.statusCode}');
    print('uploadFile response: $responseString');

    if (response.statusCode == 200) {
      return jsonDecode(responseString)['url'];
    } else {
      print(
          'else error in uploadFile: ${jsonDecode(responseString)['message']}');
      throw ServerException(
          message:
              jsonDecode(responseString)['message'] ?? 'Something went wrong');
    }
  }
}

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
    var isLocationOn = ShardPrefHelper.getIsLocationOn();
    var isHome = isLocationOn ? 'false' : 'true';

    print('isHome in uploadPost ==> $isHome');
    Map<String, dynamic> queryParameters = {'home': isHome};
    print("city from post upload: $city");

    // Create JSON body
    Map<String, dynamic> body = {
      'title': title,
      'content': content ?? '',
      'multimedia': multimedia,
      // ? 'https://s3.amazonaws.com/www.neighborly.in/${multimedia.path.split('/').last}' // Adjust this URL based on your file upload requirements
      // : null,
      'location': location,
      'type': type,
      'city': city,
      'allowMultipleVotes': allowMultipleVotes,
      'pollOptions': options,
    };

    // Remove null values from the body
    body.removeWhere((key, value) => value == null);

    // Convert the map to a JSON string
    String jsonBody = jsonEncode(body);

    // Send the request
    final response = await http.post(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonBody,
    );

    // Handle the response
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('Post uploaded successfully');
    } else {
      print('Post upload error');
      final errorMessage =
          jsonDecode(response.body)['error'] ?? 'Unknown error';
      throw ServerException(message: errorMessage);
    }
  }

  // @override
  // Future<void> uploadPost({
  //   required String title,
  //   required List<double> location,
  //   String? content,
  //   required String type,
  //   File? multimedia,
  //   required String city,
  //   List<dynamic>? options,
  //   required bool allowMultipleVotes,
  // }) async {
  //   // Retrieve cookies
  //   List<String>? cookies = ShardPrefHelper.getCookie();
  //   if (cookies == null || cookies.isEmpty) {
  //     throw const ServerException(message: 'No cookies found');
  //   }
  //   String cookieHeader = cookies.join('; ');
  //   String url = '$kBaseUrl/wall/create-post';
  //   var isLocationOn = ShardPrefHelper.getIsLocationOn();
  //   var isHome = isLocationOn ? 'false' : 'true';

  //   print('isHome in uploadPost ==> $isHome');
  //   Map<String, dynamic> queryParameters = {'home': isHome};
  //   print("city from post upload ${city} ");

  //   // Create a multipart request
  //   final request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse(url).replace(queryParameters: queryParameters),
  //   )
  //     ..headers['Cookie'] = cookieHeader
  //     ..fields['title'] = title
  //     ..fields['content'] = content ?? ''
  //     ..fields['type'] = type
  //     ..fields['city'] = city
  //     ..fields['pollOptions'] = jsonEncode(options ?? [])
  //     ..fields['location'] = jsonEncode([location[0], location[1]])
  //     // ..fields['location'] =
  //     ..fields['allowMultipleVotes'] = allowMultipleVotes.toString();

  //   // Add multimedia file if available
  //   if (multimedia != null) {
  //     request.files.add(
  //       http.MultipartFile(
  //         'file', // Field name for the file
  //         multimedia.readAsBytes().asStream(),
  //         multimedia.lengthSync(),
  //         filename: multimedia.path.split('/').last,
  //       ),
  //     );
  //   }

  //   // Send the request and handle the response
  //   final response = await request.send();
  //   final responseString = await response.stream.bytesToString();

  //   print('Post uploaded ${responseString}');
  //   if (response.statusCode == 200) {
  //     print('Post uploaded successfully');
  //   } else {
  //     print('Post uploaded error');
  //     final errorMessage = jsonDecode(responseString)['error'];
  //     throw ServerException(message: errorMessage);
  //   }
  // }

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

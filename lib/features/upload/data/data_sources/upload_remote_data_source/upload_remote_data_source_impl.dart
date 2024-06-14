import 'dart:convert';

import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

import 'package:neighborly_flutter_app/features/upload/data/data_sources/upload_remote_data_source/upload_remote_data_source.dart';

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final http.Client client;

  UploadRemoteDataSourceImpl({required this.client});

  @override
  Future<void> uploadPost(
      {String? content,
      String? title,
      String? multimedia,
      required List<num> location}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/create-post';
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(<String, String>{
        'content': content ?? '',
        'title': title ?? '',
        'multimedia': multimedia ?? '',
        'location': location.join(',')
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw ServerException(message: jsonDecode(response.body)['error']);
    }
  }
}

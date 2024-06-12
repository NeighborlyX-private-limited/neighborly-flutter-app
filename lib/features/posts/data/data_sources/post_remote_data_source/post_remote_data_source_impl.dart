import 'dart:convert';

import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/posts/data/data_sources/post_remote_data_source/post_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/features/posts/data/model/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;
  // String? token = ShardPrefHelper.getToken();

  PostRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PostModel>> getAllPosts() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/fetch-posts';
    Map<String, dynamic> queryParameters = {'home': 'true'};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => PostModel.fromJson(data)).toList();
    } else {
      final message = jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  }
}

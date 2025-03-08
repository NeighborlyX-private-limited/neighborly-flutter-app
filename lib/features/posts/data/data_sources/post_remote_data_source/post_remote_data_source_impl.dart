import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/features/posts/data/model/specific_comment_model.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/models/post_model.dart';
import '../../../../../core/utils/set_auth.dart';
import '../../../../../core/utils/shared_preference.dart';
import '../../model/comments_model.dart';
import '../../model/reply_model.dart';
import 'post_remote_data_source.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;
  PostRemoteDataSourceImpl({required this.client});

  // GET ALL POSTS
  @override
  Future<List<PostModel>> getAllPosts() async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong.');
    }

    String url = '$kBaseUrl/wall/fetch-posts';

    Map<String, dynamic> queryParameters;
    double radius = ShardPrefHelper.getRadius() ?? 3.0;
    double lat = ShardPrefHelper.getLat() ?? 0.0;
    double lng = ShardPrefHelper.getLng() ?? 0.0;
    print('Lat in featch post:$lat');
    print('Lng in featch post:$lng');
    queryParameters = {
      'latitude': '$lat',
      'longitude': '$lng',
      'range': '$radius',
    };

    try {
      final response = await client.get(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Cookie': cookies,
        },
      );

      debugPrint('FEATCH ALL POST:${response.body}');
      if (response.statusCode == 200) {
        handleAuthHeaders(response.headers);
        final List<dynamic> jsonData = jsonDecode(response.body);
        List<PostModel> data =
            jsonData.map((data) => PostModel.fromJson(data)).toList();

        return data;
      } else {
        print('achha to yaha error hai');
        String errorMessage = jsonDecode(response.body)['error'] ??
            jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['msg'] ??
            'oops something went wrong';

        throw ServerException(message: errorMessage);
      }
    } on SocketException catch (e) {
      print('achha to yaha se error hai');
      throw ServerException(
        message: 'oops something went wrong',
      );
    } catch (e) {
      print('achha to yaha pr error hai $e');
      throw ServerException(
        message: 'oops something went wrong',
      );
    }
  }

  // REPORT POST
  @override
  Future<void> reportPost({
    required String type,
    required String reason,
    required String postId,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

    String url = '$kBaseUrl/wall/report';

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(<String, dynamic>{
        'id': postId,
        'type': type,
        'reason': reason,
      }),
    );
    debugPrint('REPORT POST:${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return;
    } else {
      String errorMessage = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          'oops something went wrong';

      throw ServerException(message: errorMessage);
    }
  }

  // FEEDBACK
  @override
  Future<void> feedback({
    required num id,
    required String feedback,
    required String type,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

    String url = '$kBaseUrl/wall/feedback';
    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode({
        'id': '$id',
        'feedback': feedback,
        'type': type,
      }),
    );
    print('FEEDBACK RESPONSE: ${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return;
    } else {
      String errorMessage = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          'oops something went wrong';

      throw ServerException(message: errorMessage);
    }
  }

  // GET POST BY POST ID
  @override
  Future<PostModel> getPostById({required num id}) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

    String url = '$kBaseUrl/wall/fetch-posts/$id';

    Map<String, dynamic> queryParameters = {'home': 'true'};
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    debugPrint('GET POST BY ID:${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => PostModel.fromJson(data)).toList()[0];
    } else {
      String errorMessage = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          'oops something went wrong';

      throw ServerException(message: errorMessage);
    }
  }

  // GET COMMENT BY COMMENT ID
  @override
  Future<SpecificCommentModel> getCommentById({required String id}) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

    String url = '$kBaseUrl/posts/get-comment/$id';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    debugPrint('GET COMMENT BY ID:${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return SpecificCommentModel.fromJson(jsonData);
    } else {
      String errorMessage = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          'oops something went wrong';

      throw ServerException(message: errorMessage);
    }
  }

  // GET COMMENTS BY POST ID
  @override
  Future<List<CommentModel>> getCommentsByPostId({
    required num postId,
    required String commentId,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

    int pagenumber = 1;
    String url =
        '$kBaseUrl/posts/fetch-comments/$postId?page=${pagenumber ?? 1}?limit=100';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    debugPrint('FEATCH ALL COMMENTS OF A POST:${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final List<dynamic> jsonData = jsonDecode(response.body)['comments'];
      return jsonData
          .map((data) => CommentModel.fromJson(data, postId))
          .toList();
    } else {
      String errorMessage = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          'oops something went wrong';

      throw ServerException(message: errorMessage);
    }
  }

  // DELETE POST OR POLL
  @override
  Future<void> deletePost({
    required num id,
    required String type,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

    String url = '$kBaseUrl/wall/delete/$type/$id';

    final response = await client.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    debugPrint('DELETE POST: ${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return;
    } else {
      String errorMessage = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          'oops something went wrong';

      throw ServerException(message: errorMessage);
    }
  }

  // COMMENTS ON A POST OR POLL
  @override
  Future<void> addComment({
    required num postId,
    required String text,
    num? commentId,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

    String url = '$kBaseUrl/posts/add-comment';

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(<String, dynamic>{
        'contentid': postId,
        'text': text,
        'parentCommentid': commentId,
      }),
    );
    debugPrint('ADD COMMENT :${response.body}');
    if (response.statusCode == 201) {
      handleAuthHeaders(response.headers);
      return;
    } else {
      String errorMessage = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          'oops something went wrong';

      throw ServerException(message: errorMessage);
    }
  }

  // GIVE A VOTE ON A POLL
  @override
  Future<void> votePoll({
    required num pollId,
    required num optionId,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

    String url = '$kBaseUrl/posts/send-poll-vote';

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(<String, dynamic>{
        'contentid': pollId,
        'optionid': optionId,
      }),
    );
    debugPrint('GIVE VOTE ON A POLL:${response.body}');
    if (response.statusCode == 201) {
      handleAuthHeaders(response.headers);
      return;
    } else {
      String errorMessage = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          'oops something went wrong';

      throw ServerException(message: errorMessage);
    }
  }

  // FEATCH REPLIES OF A COMMENT
  @override
  Future<List<ReplyModel>> fetchCommentReply({required num commentId}) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

    String url = '$kBaseUrl/posts/fetch-comment-thread/$commentId';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    debugPrint('FEATCH REPLY ON A COMMENT:${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final List<dynamic> jsonData = jsonDecode(response.body);

      return jsonData.map((data) => ReplyModel.fromJson(data)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          'oops something went wrong';

      throw ServerException(message: errorMessage);
    }
  }

  // GIVE AWARDS
  @override
  Future<void> giveAward({
    required num id,
    required String awardType,
    required String type,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Someting went wrong');
    }

    String url = '$kBaseUrl/wall/give-award';

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'awardType': awardType,
        'type': type,
      }),
    );
    debugPrint('GIVE AWARD :${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return;
    } else {
      String errorMessage = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          'oops something went wrong';

      throw ServerException(message: errorMessage);
    }
  }
}

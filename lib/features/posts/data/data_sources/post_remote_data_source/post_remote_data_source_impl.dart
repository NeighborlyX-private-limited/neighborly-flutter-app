import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/models/post_model.dart';
import '../../../../../core/utils/shared_preference.dart';
import '../../model/comments_model.dart';
import '../../model/reply_model.dart';
import 'post_remote_data_source.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;

  PostRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PostModel>> getAllPosts({
    required bool isHome,
  }) async {
    print('ishome in getAllPosts == $isHome');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found in getAllPosts');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/fetch-posts';

    Map<String, dynamic> queryParameters;
    if (isHome) {
      queryParameters = {'home': '$isHome'};
    } else {
      List<double> location = ShardPrefHelper.getLocation();
      double lat = location[0];
      double long = location[1];
      print('lat in getAllPosts ==> $lat');
      print('long in getAllPosts ==> $long');
      queryParameters = {
        'home': '$isHome',
        'latitude': '$lat',
        'longitude': '$long'
      };
    }
    print(
        'url in getAllPosts ==> : ${Uri.parse(url).replace(queryParameters: queryParameters)}');
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    final List<dynamic> jsonData = jsonDecode(response.body);
    print('fetch-posts api response in getAllPosts == > $jsonData');

    if (response.statusCode == 200) {
      return jsonData.map((data) => PostModel.fromJson(data)).toList();
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> reportPost(
      {required String reason,
      required String type,
      required num postId}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/report';
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(<String, dynamic>{
        'id': postId,
        'type': type,
        'reason': reason,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> feedback(
      {required num id, required String feedback, required String type}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/feedback';
    final response = await client.put(
      Uri.parse(url),
      headers: {
        'Cookie': cookieHeader,
      },
      body: {
        'id': '$id',
        'feedback': feedback,
        'type': type,
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  }

  @override
  Future<PostModel> getPostById({required num id}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/fetch-posts/$id';
    Map<String, dynamic> queryParameters = {'home': 'true'};
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => PostModel.fromJson(data)).toList()[0];
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<List<CommentModel>> getCommentsByPostId(
      {required num postId, required String commentId}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    /*
    TODO: Vinay here you have to replace fetch-comment-thread/$commentId with new commentid api , bharat will provide you and check
    fetch-comments and commentid both api response should be same model type else you will get error
    */

    //String url = commentId == '0'? '$kBaseUrl/posts/fetch-comments/$postId' : '$kBaseUrl/posts/fetch-comment-thread/$commentId';
    String url = '$kBaseUrl/posts/fetch-comments/$postId';
    print("url created $url");
    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    // print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)['comments'];
      return jsonData
          .map((data) => CommentModel.fromJson(data, postId))
          .toList();
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> deletePost({
    required num id,
    required String type,
  }) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/wall/delete/$type/$id';
    final response = await client.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> addComment(
      {required num postId, required String text, num? commentId}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/posts/add-comment';
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(<String, dynamic>{
        'contentid': postId,
        'text': text,
        'parentCommentid': commentId,
      }),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> votePoll({required num pollId, required num optionId}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/posts/send-poll-vote';
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(<String, dynamic>{
        'contentid': pollId,
        'optionid': optionId,
      }),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<List<ReplyModel>> fetchCommentReply({required num commentId}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/posts/fetch-comment-thread/$commentId';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      // print('Response Body: ${jsonData}');
      return jsonData.map((data) => ReplyModel.fromJson(data)).toList();
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> giveAward(
      {required num id,
      required String awardType,
      required String type}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/wall/give-award';
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'awardType': awardType,
        'type': type,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      throw ServerException(message: message);
    }
  }

  // @override
  // Future<void> replyComment(
  //     {required num commentId,
  //     required String text,
  //     required num postId}) async {
  //   List<String>? cookies = ShardPrefHelper.getCookie();
  //   if (cookies == null || cookies.isEmpty) {
  //     throw const ServerException(message: 'No cookies found');
  //   }
  //   String cookieHeader = cookies.join('; ');

  //   String url = '$kBaseUrl/posts/add-comment';
  //   final response = await client.post(
  //     Uri.parse(url),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Cookie': cookieHeader,
  //     },
  //     body: jsonEncode(<String, dynamic>{
  //       'parentCommentid': commentId,
  //       'contentid': postId,
  //       'text': text,
  //     }),
  //   );

  //   if (response.statusCode == 201) {
  //     return;
  //   } else {
  //     final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
  //     throw ServerException(message: message);
  //   }
  // }
}

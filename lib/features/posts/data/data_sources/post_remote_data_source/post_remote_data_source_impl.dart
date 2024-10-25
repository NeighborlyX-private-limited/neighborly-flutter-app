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
    print('....getAllPosts start with');
    print('isHome:$isHome');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in getAllPosts');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/fetch-posts';
    print('url:$url');

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

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    final List<dynamic> jsonData = jsonDecode(response.body);
    print('getAllPosts api response status code: ${response.statusCode}');

    print('getAllPosts api response: $jsonData');
    if (response.statusCode == 200) {
      return jsonData.map((data) => PostModel.fromJson(data)).toList();
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      print('else error in getAllPosts: $message');
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> reportPost({
    required String reason,
    required String type,
    required num postId,
  }) async {
    print('....reportPost start with');
    print('reason:$reason');
    print('type:$type');
    print('postId:$postId');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in getAllPosts');
      throw const ServerException(message: 'Something went wrong.');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/report';
    print('url:$url');
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
    print('reportPost api response status code: ${response.statusCode}');
    print('reportPost api response: ${response.body}');
    if (response.statusCode == 200) {
      return;
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      print('else error in reportPost: $message');
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> feedback({
    required num id,
    required String feedback,
    required String type,
  }) async {
    print('....feedback start with');
    print('id:$id');
    print('feedback:$feedback');
    print('type:$type');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in getAllPosts');
      throw const ServerException(message: 'Someting went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/feedback';
    print('url:$url');
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
    print('feedback api response status code: ${response.statusCode}');
    print('feedback api response: ${response.body}');
    if (response.statusCode == 200) {
      return;
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'Something went wrong';
      print('else error in feedback: $message');
      throw ServerException(message: message);
    }
  }

  @override
  Future<PostModel> getPostById({required num id}) async {
    print('....getPostById start with');
    print('id:$id');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in getPostById');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/wall/fetch-posts/$id';
    print('url:$url');
    Map<String, dynamic> queryParameters = {'home': 'true'};
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );
    print('getPostById api response status code: ${response.statusCode}');
    print('getPostById api response: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => PostModel.fromJson(data)).toList()[0];
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      print('else error in getPostById: $message');
      throw ServerException(message: message);
    }
  }

  @override
  Future<List<CommentModel>> getCommentsByPostId({
    required num postId,
    required String commentId,
  }) async {
    print('....getCommentsByPostId start with');
    print('postId:$postId');
    print('commentId:$commentId');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in getCommentsByPostId');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    /*
    TODO: Vinay here you have to replace fetch-comment-thread/$commentId with new commentid api , bharat will provide you and check
    fetch-comments and commentid both api response should be same model type else you will get error
    */

    //String url = commentId == '0'? '$kBaseUrl/posts/fetch-comments/$postId' : '$kBaseUrl/posts/fetch-comment-thread/$commentId';
    String url = '$kBaseUrl/posts/fetch-comments/$postId';
    print("url: $url");
    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    print(
        'getCommentsByPostId api response status code: ${response.statusCode}');
    print('getCommentsByPostId api response: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)['comments'];
      return jsonData
          .map((data) => CommentModel.fromJson(data, postId))
          .toList();
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      print('else error in getCommentsByPostId: $message');
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> deletePost({
    required num id,
    required String type,
  }) async {
    print('....deletePost start with');
    print('id:$id');
    print('type:$type');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in deletePost');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/wall/delete/$type/$id';
    print("url: $url");
    final response = await client.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
    );
    print('deletePost api response status code: ${response.statusCode}');
    print('deletePost api response: ${response.body}');
    if (response.statusCode == 200) {
      return;
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      print('else error in deletePost: $message');
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> addComment({
    required num postId,
    required String text,
    num? commentId,
  }) async {
    print('....addComment start with');
    print('postId:$postId');
    print('text:$text');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in addComment');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/posts/add-comment';
    print('url: $url');
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
    print('addComment api response status code: ${response.statusCode}');
    print('addComment api response: ${response.body}');

    if (response.statusCode == 201) {
      return;
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      print('else error in addComment: $message');
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> votePoll({
    required num pollId,
    required num optionId,
  }) async {
    print('....votePoll start with');
    print('pollId:$pollId');
    print('optionId:$optionId');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in votePoll');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/posts/send-poll-vote';
    print('url: $url');
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
    print('votePoll api response status code: ${response.statusCode}');
    print('votePoll api response: ${response.body}');
    if (response.statusCode == 201) {
      return;
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      print('else error in votePoll: $message');
      throw ServerException(message: message);
    }
  }

  @override
  Future<List<ReplyModel>> fetchCommentReply({required num commentId}) async {
    print('....fetchCommentReply start with');
    print('commentId:$commentId');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in fetchCommentReply');
      throw const ServerException(message: 'Something went wrong');
    }
    String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/posts/fetch-comment-thread/$commentId';
    print('url: $url');

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );
    print('fetchCommentReply api response status code: ${response.statusCode}');
    print('fetchCommentReply api response: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      return jsonData.map((data) => ReplyModel.fromJson(data)).toList();
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      print('else error in fetchCommentReply: $message');
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> giveAward(
      {required num id,
      required String awardType,
      required String type}) async {
    print('....giveAward start with');
    print('id:$id');
    print('awardType:$awardType');
    print('type:$type');
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in giveAward');
      throw const ServerException(message: 'Someting went wrong');
    }
    String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/wall/give-award';
    print('url: $url');
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
    print('giveAward api response status code: ${response.statusCode}');
    print('giveAward api response: ${response.body}');

    if (response.statusCode == 200) {
      return;
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      print('else error in giveAward: $message');
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

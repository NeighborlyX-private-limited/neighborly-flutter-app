import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/features/chat/data/model/nearby_user_model.dart';
import '../../../../../core/utils/set_auth.dart';
import '../../model/chat_message_model.dart';
import '../../model/chat_room_model.dart';
import '../../model/dm_message_model.dart';
import '../../model/interest_model.dart';
import '../../model/pinned_message_model.dart';
import 'chat_remote_data_source.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/utils/shared_preference.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;

  ChatRemoteDataSourceImpl({required this.client});

  // GET GROUP CHAT
  @override
  Future<List<ChatMessageModel>> getGroupRoomMessages({
    required String roomId,
    bool isreply = false,
    int page = 1,
  }) async {
    // List<String>? cookies = ShardPrefHelper.getCookie();
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    // String cookieHeader = cookies.join('; ');

    String url =
        '$kBaseUrl/chat/fetch-group-messages/$roomId?page=$page&limit=20';
    print('featch message with room it:$roomId');

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);

      return ChatMessageModel.fromJsonList(jsonDecode(response.body)).toList();
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops something went wrong';
      throw ServerException(message: message);
    }
  }

// GET ALL CHAT ROOMS
  @override
  Future<List<ChatRoomModel>> getAllChatRooms() async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }

    String url = '$kBaseUrl/chat/fetch-user-chats';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    debugPrint('GET ALL CHAT ROOMS RESPONSE: ${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return ChatRoomModel.fromJsonList(jsonDecode(response.body));
    } else {
      final message = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          'oops something went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<List<PinnedMessageModel>> featchPinnedMessages({
    required String groupId,
  }) async {
    // List<String>? cookies = ShardPrefHelper.getCookie();
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    // String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/chat/fetch-pinned-messages/$groupId';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    print('Pinned Message Response: ${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return PinnedMessageModel.fromJsonList(jsonDecode(response.body));
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops something went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<String> pinnedMessage({
    required String messageId,
  }) async {
    // List<String>? cookies = ShardPrefHelper.getCookie();
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    // String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/chat/pin-message/$messageId';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return (jsonDecode(response.body)['message']);
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops something went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<List<ChatMessageResponse>> getRoomMessages({
    required String chatId,
  }) async {
    // final fakeJson = json.decode(fakeData);
    // List<String>? cookies = ShardPrefHelper.getCookie();
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    // String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/dm/fetch-dm-message/$chatId';
    print('featch message with room it:$chatId');

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      print('res  of dm message : ${jsonDecode(response.body)}');
// return ChatMessageModel.fromJsonList(jsonDecode(response.body)).toList();
      List<ChatMessageResponse> data = ChatMessageResponse.fromJsonList(
              jsonDecode(response.body)['messages'])
          .toList();
      print('data: $data');
      return data;
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops something went wrong';
      throw ServerException(message: message);
    }
    // return ChatMessageModel.fromJsonList(fakeJson);
  }

  @override
  Future<InterestModel> getAllInterests() async {
    // List<String>? cookies = ShardPrefHelper.getCookie();
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    // String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/discover/interest-list';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final Map<String, dynamic> data = json.decode(response.body);
      return InterestModel.fromJson(data);

      // return InterestModel.fromJson
      //     .fromJsonList(jsonDecode(response.body))
      //     .toList();
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops something went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<List<NearbyUserModel>> getNearByUser() async {
    // List<String>? cookies = ShardPrefHelper.getCookie();
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    double? radius = ShardPrefHelper.getRadius();
    radius = 1000000000;
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    // String cookieHeader = cookies.join('; ');
    double lat = ShardPrefHelper.getLat() ?? 0.0;
    double long = ShardPrefHelper.getLng() ?? 0.0;
    String url = '$kBaseUrl/discover/fetch-neighbors'
        '?radius=$radius'
        '&latitude=$lat'
        '&longitude=$long';
    // String url = '$kBaseUrl/discover/fetch-neighbors?radius=$radius';
    print('url fetch-neighbors: $url');

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    print('nearby user fetch-neighbors: ${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      // final Map<String, dynamic> data = json.decode(response.body);
      // return NearbyUserModel.fromJson(data);
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> usersJson = data['nearbyUsers'];

      final List<NearbyUserModel> users =
          usersJson.map((json) => NearbyUserModel.fromJson(json)).toList();

      print('kuch: ${users}');

      return users;

      // return InterestModel.fromJson
      //     .fromJsonList(jsonDecode(response.body))
      //     .toList();
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops something went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> saveUserInterest({required List<String> userInterest}) async {
    // List<String>? cookies = ShardPrefHelper.getCookie();
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    // String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/discover/save-interests';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode({"userInterests": userInterest}),
    );

    print('res:${response.body}');
    if (response.statusCode == 200) {
      ShardPrefHelper.setUserInterests(userInterest);
      handleAuthHeaders(response.headers);
      final Map<String, dynamic> data = json.decode(response.body);
      print('data:$data');

      return;

      // return InterestModel.fromJson
      //     .fromJsonList(jsonDecode(response.body))
      //     .toList();
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops something went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<String> createDm({required String userId}) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops something went wrong');
    }
    // String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/dm/create-dm-chat';

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode({"user": userId}),
    );

    print('res chat cretae:${response.body}');
    print('res chat cretae:${response.statusCode}');
    if (response.statusCode == 200) {
      // ShardPrefHelper.setUserInterests(userInterest);
      handleAuthHeaders(response.headers);
      final Map<String, dynamic> data = json.decode(response.body);
      print('data:${data['chat']['_id']}');
      String chatId = data['chat']['_id'];

      return chatId;

      // return InterestModel.fromJson
      //     .fromJsonList(jsonDecode(response.body))
      //     .toList();
    } else if (response.statusCode == 400 &&
        jsonDecode(response.body)['msg']
            .toString()
            .contains('Chat already exists')) {
      // ShardPrefHelper.setUserInterests(userInterest);
      // handleAuthHeaders(response.headers);
      final Map<String, dynamic> data = jsonDecode(response.body);
      print('data:${data['existingChat']['_id']}');
      String chatId = data['existingChat']['_id'];

      return chatId;

      // return InterestModel.fromJson
      //     .fromJsonList(jsonDecode(response.body))
      //     .toList();
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops something went wrong';
      throw ServerException(message: message);
    }
  }
}

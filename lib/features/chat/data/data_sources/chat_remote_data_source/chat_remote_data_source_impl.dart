import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/utils/set_auth.dart';
import '../../model/chat_message_model.dart';
import '../../model/chat_room_model.dart';
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
        '$kBaseUrl/chat/fetch-group-messages/$roomId?page=$page&limit=15000';

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
      // print('CHAT MESSAGE PAGE: $page');
      // print('CHAT MESSAGE LIMIT: ${jsonDecode(response.body).length}');
      // print('CHAT MESSAGE: ${jsonDecode(response.body)}');
      return ChatMessageModel.fromJsonList(jsonDecode(response.body))
          .reversed
          .toList();
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops something went wrong';
      throw ServerException(message: message);
    }
  }

// GET ALL CHAT ROOMS
  @override
  Future<List<ChatRoomModel>> getAllChatRooms() async {
    // List<String>? cookies = ShardPrefHelper.getCookie();
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    // String cookieHeader = cookies.join('; ');

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
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops something went wrong';
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
  Future<List<ChatMessageModel>> getRoomMessages({
    required String roomId,
    String? dateFrom,
  }) async {
    if (dateFrom == null || dateFrom == '') {
      dateFrom = DateTime.now().toIso8601String();
    }

    // FAKE example
    await Future.delayed(Duration(seconds: 2));

    String fakeData = '''
      [
        {
          "id": "668164e760dbe07a2fd9df5b",           
          "text": "1 Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer",
          "date": "2024-08-02 11:34:00",
          "isMine": true, 
          "hasMore": false,
          "isReaded": true,
          "unreadedCount": 12
        },{
          "id": "668164e760dbe07a2fd9df5b",           
          "text": "2 Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer",
          "date": "2024-08-02 11:34:00",
          "isMine": true, 
          "hasMore": false,
          "isReaded": true,
          "unreadedCount": 12
        },{
          "id": "3 668164e760dbe07a2fd9df5b", 
          "text": "Lorem ipsum amet, consectetuer",
          "date": "2024-07-29 10:34:00",
          "isMine": false,
          "hasMore": false,
          "isReaded": true
        },{
          "id": "4 668164e760dbe07a2fd9df5b",  
          "text": "Lorem ipsum, consectetuer orem ipsum am, orem ipsum am orem ipsum am orem ipsum am, orem ipsum am orem ipsum am, orem ipsum amorem ipsum am ? ",
          "date": "2024-07-29 10:34:00",
          "isMine": false,
          "hasMore": false,
          "isReaded": true
        },{
          "id": "5 668164e760dbe07a2fd9df5b", 
          "pictureUrl": "https://img.freepik.com/fotos-gratis/capivara-no-habitat-natural-do-norte-do-pantanal-maior-rondent-america-selvagem-da-vida-selvagem-sul-americana-beleza-da-natureza_475641-2161.jpg?t=st=1722531645~exp=1722535245~hmac=940000ad880443f24ddfc51afec3f77a0116cd23c80063e5caecaf8ce3ac7c49&w=596",
          "text": "Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer",
          "date": "2024-07-29 10:34:00",
          "isMine": false,
          "hasMore": false,
          "isReaded": true
        },{
          "id": "6 668164e760dbe07a2fd9df5b", 
          "pictureUrl": "https://img.freepik.com/fotos-gratis/especialista-em-seguranca-cibernetica-a-trabalhar-com-tecnologia-em-luzes-de-neon_23-2151645661.jpg?t=st=1722573533~exp=1722577133~hmac=fc9a6c66bed1aef3fad7541423c49fa69ea858159e8d3d6903039c7edf5dde65&w=360",
          "text": "Lorem  dor amet, consect rem  dor amet, consectetuer",
          "date": "2024-07-28 10:34:00",
          "isMine": true,
          "hasMore": false,
          "isReaded": true
        },{
          "id": "7 668164e760dbe07a2fd9df5b", 
          "text": "....",
          "date": "2024-07-28 10:34:00",
          "isMine": false,
          "hasMore": false,
          "isReaded": true
        },{
          "id": "8 668164e760dbe07a2fd9df5b",           
          "text": "Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer",
          "date": "2024-07-28 11:34:00",
          "isMine": true, 
          "hasMore": false,
          "isReaded": true,
          "unreadedCount": 12
        }
      ]
      ''';

    final fakeJson = json.decode(fakeData);
    return ChatMessageModel.fromJsonList(fakeJson);
  }
}

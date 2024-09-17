import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/chat_message_model.dart';
import '../../model/chat_room_model.dart';
import 'chat_remote_data_source_thread.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/utils/shared_preference.dart';
import '../../model/chat_room_model.dart';

class ChatRemoteDataSourceImplThread implements ChatRemoteDataSourceThread {
  final http.Client client;

  ChatRemoteDataSourceImplThread({required this.client});
  @override
  Future<List<ChatRoomModel>> getAllChatRooms() async {
    print('... getAllChatRooms   ');

    // near by:   {{URL}}/group/nearby-groups?isHome=false
    // from user: {{URL}}/group//user-groups

    // FAKE example

    print('... get group rooms');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    print('cookies list $cookies');
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/chat/fetch-user-chats';

    print('cookie $cookieHeader');

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
         'Cookie': cookieHeader,
        //'Cookie': 'connect.sid=s%3ATNsUxcpmB530JPuGonUAMDf7UM75k6Q4.mxgR3Q0l1w8bXnJiiZlxe76Dlme%2FOEHdlLkM4ZHRoFA; refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2N2QwZDZkNjIxMDQxZGEyYzdiNzllOCIsImlhdCI6MTcyNjE1MTY5OCwiZXhwIjoxNzM5MTExNjk4fQ.nVVIIKSfktYn64zktVqexxi86sfXqkuKRjp9g13fuM0',
      },
    );
    print("message response api $response");
      
    if (response.statusCode == 200) {
      print("message API else ${jsonDecode(response.body)}");
      
      return ChatRoomModel.fromJsonList(jsonDecode(response.body));
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      print("message API else $message");
      throw ServerException(message: message);
    }

    // https://img.freepik.com/fotos-gratis/atletica-feminina-mirando-com-arco-e-flecha-em-direcao-as-arvores_181624-45692.jpg?t=st=1722575634~exp=1722579234~hmac=271cb8ee0b38db00249b1dd3c5a8ddd2ae4536f7dabde0584b1f08436c01badb&w=996
    /*String fakeData = '''
      [
        {
          "id": "668164e760dbe07a2fd9df5b",
          "name": "Capibaras goona wild",
          "avatarUrl": "https://img.freepik.com/fotos-gratis/capivara-no-habitat-natural-do-norte-do-pantanal-maior-rondent-america-selvagem-da-vida-selvagem-sul-americana-beleza-da-natureza_475641-2161.jpg?t=st=1722531645~exp=1722535245~hmac=940000ad880443f24ddfc51afec3f77a0116cd23c80063e5caecaf8ce3ac7c49&w=596",
          "lastMessage": "Lorem ipsum odor amet, consectetuer",
          "lastMessageDate": "2024-08-02 11:34:00",
          "isMuted": false,
          "isGroup": true,
          "unreadedCount": 12
        },{
          "id": "668164e760dbe07a2fd9df5b",
          "name": "Cyber Security Leaders",
          "avatarUrl": "https://img.freepik.com/fotos-gratis/especialista-em-seguranca-cibernetica-a-trabalhar-com-tecnologia-em-luzes-de-neon_23-2151645661.jpg?t=st=1722573533~exp=1722577133~hmac=fc9a6c66bed1aef3fad7541423c49fa69ea858159e8d3d6903039c7edf5dde65&w=360",
          "lastMessage": "Lorem ipsum amet, consectetuer",
          "lastMessageDate": "2024-08-01 10:34:00",
          "isMuted": false,
          "isGroup": true,
          "unreadedCount": 2
        },{
          "id": "668164e760dbe07a2fd9df5b",
          "name": "Laura Bin Laden",
          "avatarUrl": "https://moacir.net/avatars/10.jpg",
          "lastMessage": "Lorem ipsum, consectetuer",
          "lastMessageDate": "2024-08-01 10:34:00",
          "isMuted": false,
          "isGroup": false,
          "unreadedCount": 2
        },{
          "id": "668164e760dbe07a2fd9df5b",
          "name": "Hakan Murath",
          "avatarUrl": "https://moacir.net/avatars/77.jpg",
          "lastMessage": "Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer",
          "lastMessageDate": "2024-07-01 10:34:00",
          "isMuted": true,
          "isGroup": false,
          "unreadedCount": 0
        },{
          "id": "668164e760dbe07a2fd9df5b",
          "name": "Juris Hate Cris",
          "avatarUrl": "https://moacir.net/avatars/34.jpg",
          "lastMessage": "Lorem  dor amet, consect rem  dor amet, consectetuer",
          "lastMessageDate": "2024-06-01 10:34:00",
          "isMuted": false,
          "isGroup": false,
          "unreadedCount": 0
        },{
          "id": "668164e760dbe07a2fd9df5b",
          "name": "Dr Anonymous",
          "avatarUrl": "https://moacir.net/avatars/none.png",
          "lastMessage": "",
          "lastMessageDate": "2024-03-01 10:34:00",
          "isMuted": false,
          "isGroup": false,
          "unreadedCount": 0
        } 
      ]
      ''';*/

   //final fakeJson = json.decode(fakeData);
   // return ChatRoomModel.fromJsonList(fakeJson);

    // List<String>? cookies = ShardPrefHelper.getCookie();
    // if (cookies == null || cookies.isEmpty) {
    //   throw const ServerException(message: 'No cookies found');
    // }
    // String cookieHeader = cookies.join('; ');
    // String url = '$kBaseUrl/wall/fetch-posts';
    // Map<String, dynamic> queryParameters = {'home': '$isHome'};

    // final response = await client.get(
    //   Uri.parse(url).replace(queryParameters: queryParameters),
    //   headers: <String, String>{
    //     'Cookie': cookieHeader,
    //   },
    // );

    // if (response.statusCode == 200) {
    //   final List<dynamic> jsonData = jsonDecode(response.body);
    //   return jsonData.map((data) => CommunityModel.fromJson(data)).toList();
    // } else {
    //   final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
    //   throw ServerException(message: message);
    // }
  }

  @override
  Future<List<ChatMessageModel>> getRoomMessages(
      {required String roomId, String? dateFrom}) async {
    print('... getRoomMessages   \n roomId=$roomId \n dateFrom=$dateFrom');

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

  @override
  Future<List<ChatMessageModel>> getGroupRoomMessages(
      {required String roomId, String? dateFrom, bool isreply = false}) async {
    print('... getGroupRoomMessagesforthread -------------------------------------------------   \n roomId=$roomId \n dateFrom=$dateFrom');

    if (dateFrom == null || dateFrom == '') {
      dateFrom = DateTime.now().toIso8601String();
    }

    // FAKE example
    await Future.delayed(Duration(seconds: 2));

    //Get msg Api call here harsh 
    print('... get group room chat');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
       throw const ServerException(message: 'No cookies found');
    }
  
    String cookieHeader = cookies.join('; ');
   
      String url = '$kBaseUrl/chat/fetch-message-thread/'+'$roomId';
      final response = await client.get(
        Uri.parse(url),
        headers: <String, String>{
          'Cookie': cookieHeader,
        },
      );        
      if (response.statusCode == 200) {
        return ChatMessageModel.fromJsonList(jsonDecode(response.body)).reversed.toList();
      } else {
        final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
        throw ServerException(message: message);
      }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/chat_message_model.dart';
import '../../model/chat_room_model.dart';
import 'chat_remote_data_source.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;

  ChatRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ChatRoomModel>> getAllChatRooms() async {
    print('... getAllChatRooms   ');

    // near by:   {{URL}}/group/nearby-groups?isHome=false
    // from user: {{URL}}/group//user-groups

    // FAKE example
    await Future.delayed(Duration(seconds: 3));

    // https://img.freepik.com/fotos-gratis/atletica-feminina-mirando-com-arco-e-flecha-em-direcao-as-arvores_181624-45692.jpg?t=st=1722575634~exp=1722579234~hmac=271cb8ee0b38db00249b1dd3c5a8ddd2ae4536f7dabde0584b1f08436c01badb&w=996
    String fakeData = '''
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
      ''';

    final fakeJson = json.decode(fakeData);
    return ChatRoomModel.fromJsonList(fakeJson);

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
  Future<List<ChatMessageModel>> getRoomMessages({required String roomId, String? dateFrom}) async {
    print('... getRoomMessages   \n roomId=$roomId \n dateFrom=$dateFrom');

    if(dateFrom == null || dateFrom == ''){
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
  Future<List<ChatMessageModel>> getGroupRoomMessages({required String roomId, String? dateFrom}) async {
    print('... getGroupRoomMessages   \n roomId=$roomId \n dateFrom=$dateFrom');

    if(dateFrom == null || dateFrom == ''){
      dateFrom = DateTime.now().toIso8601String();
    }

    // FAKE example
    await Future.delayed(Duration(seconds: 2));
   
    String fakeData = '''
      [
        {
          "id": "XXX68164e760dbe07a2fd9df5b",           
          "text": "11111 Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer",
          "date": "2024-08-02 11:34:00",
          "isMine": true, 
          "hasMore": false,
          "isReaded": true,
          "unreadedCount": 12,
          "author": {
              "userId": "1111",
              "userName": "John Wick",
              "picture":"https://moacir.net/avatars/40.jpg",
              "karma": 1
          },
          "repliesCount": 8,
          "repliesAvatas": [
            "https://moacir.net/avatars/46.jpg",  
            "https://moacir.net/avatars/34.jpg",
            "https://moacir.net/avatars/40.jpg",
            "https://moacir.net/avatars/10.jpg",    
            "https://moacir.net/avatars/77.jpg",
            "https://moacir.net/avatars/16.jpg",    
            "https://moacir.net/avatars/none.png"
          ],
          "isAdmin": true,
          "isPinned": false, 
          "cheers": 5, 
          "bools": 2, 
          "boolOrCheer": "cheer" 
        },{
          "id": "668164e760dbe07a2fd9df5b",           
          "text": "2 Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer",
          "date": "2024-08-02 11:34:00",
          "isMine": true, 
          "hasMore": false,
          "isReaded": true,
          "unreadedCount": 12,
          "author": {
              "userId": "222",
              "userName": "Marta Wayne",
              "picture":"https://moacir.net/avatars/10.jpg",
              "karma": 1
          },
          "repliesCount": 1,
          "repliesAvatas": [ 
            "https://moacir.net/avatars/16.jpg" 
          ],
          "isAdmin": false,
          "isPinned": false, 
          "cheers": 1, 
          "bools": 4, 
          "boolOrCheer": "bool" 
        },{
          "id": "3 668164e760dbe07a2fd9df5b", 
          "text": "Lorem ipsum amet, consectetuer, Lorem ipsum amet, consectetuer Lorem ipsum amet, consectetuer",
          "date": "2024-07-29 10:34:00",
          "isMine": false,
          "hasMore": false,
          "isReaded": true,
          "author": {
              "userId": "333",
              "userName": "Peter Sulivan",
              "picture":"https://moacir.net/avatars/77.jpg",
              "karma": 1
          },
          "repliesCount": 3,
          "repliesAvatas": [
            "https://moacir.net/avatars/10.jpg",    
            "https://moacir.net/avatars/77.jpg",
            "https://moacir.net/avatars/16.jpg" 
          ],
          "isAdmin": false,
          "isPinned": false, 
          "cheers": 1, 
          "bools": 0, 
          "boolOrCheer": ""
        },{
          "id": "4 668164e760dbe07a2fd9df5b",  
          "text": "Lorem ipsum, consectetuer orem ipsum am, orem ipsum am orem ipsum am orem ipsum am, orem ipsum am orem ipsum am, orem ipsum amorem ipsum am ? ",
          "date": "2024-07-29 10:34:00",
          "isMine": false,
          "hasMore": false,
          "isReaded": true,
          "author": {
              "userId": "4444",
              "userName": "Teresa Madre",
              "picture":"https://moacir.net/avatars/16.jpg",
              "karma": 1
          },
          "repliesCount": 0,
          "repliesAvatas": [ 
          ],
          "isAdmin": false,
          "isPinned": true, 
          "cheers": 0, 
          "bools": 0, 
          "boolOrCheer": ""
        },{
          "id": "5 668164e760dbe07a2fd9df5b", 
          "pictureUrl": "https://img.freepik.com/fotos-gratis/capivara-no-habitat-natural-do-norte-do-pantanal-maior-rondent-america-selvagem-da-vida-selvagem-sul-americana-beleza-da-natureza_475641-2161.jpg?t=st=1722531645~exp=1722535245~hmac=940000ad880443f24ddfc51afec3f77a0116cd23c80063e5caecaf8ce3ac7c49&w=596",
          "text": "Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer",
          "date": "2024-07-29 10:34:00",
          "isMine": false,
          "hasMore": false,
          "isReaded": true,
          "author": {
              "userId": "4444",
              "userName": "Dr Anonymous",
              "picture":"https://moacir.net/avatars/none.png",
              "karma": 1
          },
          "repliesCount": 2,
          "repliesAvatas": [
            "https://moacir.net/avatars/46.jpg",  
            "https://moacir.net/avatars/34.jpg"
          ],
          "isAdmin": false,
          "isPinned": false, 
          "cheers": 0, 
          "bools": 0, 
          "boolOrCheer": "" 
        },{
          "id": "6 668164e760dbe07a2fd9df5b", 
          "pictureUrl": "https://img.freepik.com/fotos-gratis/especialista-em-seguranca-cibernetica-a-trabalhar-com-tecnologia-em-luzes-de-neon_23-2151645661.jpg?t=st=1722573533~exp=1722577133~hmac=fc9a6c66bed1aef3fad7541423c49fa69ea858159e8d3d6903039c7edf5dde65&w=360",
          "text": "Lorem  dor amet, consect rem  dor amet, consectetuer",
          "date": "2024-07-28 10:34:00",
          "isMine": true,
          "hasMore": false,
          "isReaded": true,
          "author": {
              "userId": "4444",
              "userName": "Teresa Madre",
              "picture":"https://moacir.net/avatars/16.jpg",
              "karma": 1
          },
          "repliesCount": 0,
          "repliesAvatas": [ 
          ],
          "isAdmin": false,
          "isPinned": false, 
          "cheers": 5, 
          "bools": 2, 
          "boolOrCheer": "cheer" 
        },{
          "id": "7 668164e760dbe07a2fd9df5b", 
          "text": "Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer",
          "date": "2024-07-28 10:34:00",
          "isMine": false,
          "hasMore": false,
          "isReaded": true,
          "author": {
              "userId": "222",
              "userName": "Johana Fudency",
              "picture":"https://moacir.net/avatars/46.jpg",
              "karma": 1
          },
          "repliesCount": 0,
          "repliesAvatas": [ 
          ],
          "isAdmin": false,
          "isPinned": false, 
          "cheers": 3, 
          "bools": 2, 
          "boolOrCheer": "" 
        },{
          "id": "8 668164e760dbe07a2fd9df5b",           
          "text": "Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer, Lorem  dor amet, consectetuer",
          "date": "2024-07-28 11:34:00",
          "isMine": true, 
          "hasMore": false,
          "isReaded": true,
          "unreadedCount": 12,
          "author": {
              "userId": "222",
              "userName": "Paul Bin Laden",
              "picture":"https://moacir.net/avatars/34.jpg",
              "karma": 1
          },
          "repliesCount": 0,
          "repliesAvatas": [ 
          ],
          "isAdmin": false,
          "isPinned": false, 
          "cheers": 0, 
          "bools": 0, 
          "boolOrCheer": "" 
        }
      ]
      ''';

    final fakeJson = json.decode(fakeData);
    return ChatMessageModel.fromJsonList(fakeJson);

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
}

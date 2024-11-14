import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../model/event_model.dart';
import 'event_remote_data_source.dart';

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final http.Client client;

  EventRemoteDataSourceImpl({required this.client});

  @override
  Future<List<EventModel>> getEvents({
    required String scope,
    required String myOrOngoing,
    required String searchTerm,
    required String filterDateStart,
    required String filterDateEnd,
    required String filterCategory,
    required String filterLocation,
  }) async {
// scope:  nearBy  fromUser
    print(
        '... getEvents scope=$scope  myOrOngoing=$myOrOngoing searchTerm=$searchTerm   ');
    print(
        '... getEvents filterDateStart=$filterDateStart filterDateEnd=$filterDateEnd');
    print(
        '... getEvents filterCategory=$filterCategory filterLocation=$filterLocation');

    // near by:   {{URL}}/group/nearby-groups?isHome=false
    // from user: {{URL}}/group//user-groups

    // FAKE example
    await Future.delayed(Duration(seconds: 3));
    String fakeDataFinal;

    String fakeData1 = '''
      [
        {
          "id": "668164e760dbe07a2fd9df5b",
          "title": "Hackton - Capibaras",
          "description": "Lorem ipsum odor amet, consectetuer adipiscing elit.Lorem ipsum odor amet, consectetuer adipiscing elit. Lorem ipsum odor amet, consectetuer adipiscing elit.",
          "avatarUrl": "https://img.freepik.com/fotos-gratis/capivara-no-habitat-natural-do-norte-do-pantanal-maior-rondent-america-selvagem-da-vida-selvagem-sul-americana-beleza-da-natureza_475641-2161.jpg?t=st=1722531645~exp=1722535245~hmac=940000ad880443f24ddfc51afec3f77a0116cd23c80063e5caecaf8ce3ac7c49&w=596",
          "locationStr": "Faridabad",
          "dateStart": "2024-07-29 07:00:00",
          "dateEnd": "2024-07-29 08:00:00", 
          "category": "Hackaton",
          "address": "Very far away Street, 34 - someOther Neighbor",
          "host":  {
              "userId": "1111",
              "userName": "John Wick",
              "picture":"https://moacir.net/avatars/40.jpg",
              "karma": 1
            },
          "isJoined": true,
          "isMine": true
        },     
        {
          "id": "668164e760dbe07a2fd9df5b",
          "title": "Hackton - Tech Crazy People Big Name",
          "description": "Lorem ipsum odor amet, consectetuer adipiscing elit.Lorem ipsum odor amet, consectetuer adipiscing elit. Lorem ipsum odor amet, consectetuer adipiscing elit.",
          "avatarUrl": "https://img.freepik.com/fotos-gratis/especialista-em-seguranca-cibernetica-a-trabalhar-com-tecnologia-em-luzes-de-neon_23-2151645661.jpg?t=st=1722573533~exp=1722577133~hmac=fc9a6c66bed1aef3fad7541423c49fa69ea858159e8d3d6903039c7edf5dde65&w=360",
          "locationStr": "Faridabad",
          "dateStart": "2024-07-29 07:00:00",
          "dateEnd": "2024-07-29 08:00:00", 
          "category": "Hackaton",
          "address": "Very far away Street, 34 - someOther Neighbor",
          "host":  {
              "userId": "222",
              "userName": "Marta Wayne",
              "picture":"https://moacir.net/avatars/77.jpg",
              "karma": 1
            },
          "isJoined": false,
          "isMine": false
        }     
      ]
      ''';

    String fakeData2 = '''
      [
        {
          "id": "668164e760dbe07a2fd9df5b",
          "title": "Hackton - Football",
          "description": "Lorem ipsum odor amet, consectetuer adipiscing elit.Lorem ipsum odor amet, consectetuer adipiscing elit. Lorem ipsum odor amet, consectetuer adipiscing elit.",
          "avatarUrl": "https://img.freepik.com/fotos-gratis/jogador-de-futebol-masculino-com-bola-no-campo-de-grama_23-2150821530.jpg?t=st=1722242078~exp=1722245678~hmac=b56686cc1b7765d81d7cf85c2e8792ee14e1b999ea2cce0558b9f855a504611b&w=740",
          "locationStr": "Faridabad",
          "dateStart": "2024-07-29 07:00:00",
          "dateEnd": "2024-07-29 09:00:00", 
          "category": "Hackaton",
          "address": "Very far away Street, 34 - someOther Neighbor",
          "host":   {
              "userId": "333",
              "userName": "Peter Sulivan",
              "picture":"https://moacir.net/avatars/77.jpg",
              "karma": 1
            },
          "isJoined": true,
          "isMine": true
        },     
        {
          "id": "668164e760dbe07a2fd9df5b",
          "title": "Hackton - Yoga",
          "description": "Lorem ipsum odor amet, consectetuer adipiscing elit.Lorem ipsum odor amet, consectetuer adipiscing elit. Lorem ipsum odor amet, consectetuer adipiscing elit.",
          "avatarUrl": "https://img.freepik.com/fotos-gratis/vista-frontal-da-mulher-em-casa-praticando-ioga_23-2148785141.jpg?t=st=1722256442~exp=1722260042~hmac=3b2b669dce173461a2bffaac9667e8ba419fa0e5a28fb567abd4252585e962c5&w=440",
          "locationStr": "Faridabad",
          "dateStart": "2024-07-29 07:00:00",
          "dateEnd": "2024-07-29 08:00:00", 
          "category": "Hackaton",
          "address": "Very far away Street, 34 - someOther Neighbor",
          "host": {
              "userId": "4444",
              "userName": "Teresa Madre",
              "picture":"https://moacir.net/avatars/16.jpg",
              "karma": 1
            },
          "isJoined": false,
          "isMine": false
        }     ,
 {
          "id": "668164e760dbe07a2fd9df5b",
          "title": "Hackton - Capibaras",
          "description": "Lorem ipsum odor amet, consectetuer adipiscing elit.Lorem ipsum odor amet, consectetuer adipiscing elit. Lorem ipsum odor amet, consectetuer adipiscing elit.",
          "avatarUrl": "https://img.freepik.com/fotos-gratis/capivara-no-habitat-natural-do-norte-do-pantanal-maior-rondent-america-selvagem-da-vida-selvagem-sul-americana-beleza-da-natureza_475641-2161.jpg?t=st=1722531645~exp=1722535245~hmac=940000ad880443f24ddfc51afec3f77a0116cd23c80063e5caecaf8ce3ac7c49&w=596",
          "locationStr": "Faridabad",
          "dateStart": "2024-07-29 07:00:00",
          "dateEnd": "2024-07-29 08:00:00", 
          "category": "Hackaton",
          "address": "Very far away Street, 34 - someOther Neighbor",
          "host":  {
              "userId": "1111",
              "userName": "John Wick",
              "picture":"https://moacir.net/avatars/40.jpg",
              "karma": 1
            },
          "isJoined": false,
          "isMine": true
        },     
        {
          "id": "668164e760dbe07a2fd9df5b",
          "title": "Hackton - Tech Crazy People Big Name",
          "description": "Lorem ipsum odor amet, consectetuer adipiscing elit.Lorem ipsum odor amet, consectetuer adipiscing elit. Lorem ipsum odor amet, consectetuer adipiscing elit.",
          "avatarUrl": "https://img.freepik.com/fotos-gratis/especialista-em-seguranca-cibernetica-a-trabalhar-com-tecnologia-em-luzes-de-neon_23-2151645661.jpg?t=st=1722573533~exp=1722577133~hmac=fc9a6c66bed1aef3fad7541423c49fa69ea858159e8d3d6903039c7edf5dde65&w=360",
          "locationStr": "Faridabad",
          "dateStart": "2024-07-29 07:00:00",
          "dateEnd": "2024-07-29 08:00:00", 
          "category": "Hackaton",
          "address": "Very far away Street, 34 - someOther Neighbor",
          "host":  {
              "userId": "222",
              "userName": "Marta Wayne",
              "picture":"https://moacir.net/avatars/77.jpg",
              "karma": 1
            },
          "isJoined": false,
          "isMine": false
        }   
      ]
      ''';

    if (scope == 'NearBy') {
      switch (filterLocation) {
        case 'local':
          fakeDataFinal = fakeData2;
          break;
        case 'my':
          fakeDataFinal = fakeData1;
          break;
        default:
          fakeDataFinal = fakeData1;
      }
    } else {
      switch (filterLocation) {
        case 'local':
          fakeDataFinal = fakeData1;
          break;
        case 'my':
          fakeDataFinal = fakeData2;
          break;
        default:
          fakeDataFinal = fakeData2;
      }
    }

    // return [];

    final fakeJson = json.decode(fakeDataFinal);
    return EventModel.fromJsonList(fakeJson);

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
  Future<void> cancelEvent({required EventModel event, String? reason}) {
    // TODO: implement cancelEvent
    throw UnimplementedError();
  }

  @override
  Future<void> createEvent(
      {required EventModel event, File? imageCover}) async {
    print('...DATASOURCE createEvent ');
    print('...DATASOURCE createEvent event=$event');
    print('...DATASOURCE createEvent imageCover=${imageCover?.path}');

    await Future.delayed(Duration(seconds: 3));
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
  Future<void> joinEvent({required EventModel event}) async {
    print('...DATASOURCE joinEvent ');
    print('...DATASOURCE joinEvent event=$event');

    await Future.delayed(Duration(seconds: 3));
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
  Future<void> updateEvent(
      {required EventModel event, File? imageCover}) async {
    print('...DATASOURCE createEvent ');
    print('...DATASOURCE createEvent event=$event');
    print('...DATASOURCE createEvent imageCover=${imageCover?.path}');

    await Future.delayed(Duration(seconds: 3));
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

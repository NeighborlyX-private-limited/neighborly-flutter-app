import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/utils/shared_preference.dart';
import '../../model/notification_model.dart';
import 'notification_remote_data_source.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final http.Client client;

  NotificationRemoteDataSourceImpl({required this.client});

  @override
  Future<String> updateFCMtoken() async {
    var currentToken = await FirebaseMessaging.instance.getToken();
    print('...currentToken=${currentToken}');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/user/save-fcm-token';
    String currentUser = ShardPrefHelper.getUserID() ?? '';

    final response = await client.post(Uri.parse(url),
        headers: <String, String>{
          'Cookie': cookieHeader,
        },
        body: {
          "fcmToken": currentToken,
          "userId": currentUser,
        });

    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      final jsonData = jsonDecode(response.body);

      print('...jsonData=${jsonData}');
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      // throw ServerException(message: message);
      print('...error=${message}');
    }

    return currentToken ?? '';
  }

  @override
  Future<List<NotificationModel>> getAllNotification({String? page}) async {
    print('... getAllNotification page=$page ');

    // FAKE
    await Future.delayed(Duration(seconds: 3));

/*
{
    "_id": "ObjectId",
    "userId": "String",
    "title": "String", 
 
    "data": {
   
  
 
    
 
    },
 
    "status": "String"
}
*/
    // final String action;  // award|boos|cheers|comment
    String fakeData = '''
      [
        {
          "_id": "668164e760dbe0734a2fd9df5b",
          "userId": "669bfe2c8486500123a10754",
          "message": "Your post has received 5 cheers. Check it out!",
          "title": "...",
          "triggerType": "cheers",      
          "data": {
            "notificationImage": "https://img.freepik.com/fotos-gratis/especialista-em-seguranca-cibernetica-a-trabalhar-com-tecnologia-em-luzes-de-neon_23-2151645661.jpg?t=st=1722573533~exp=1722577133~hmac=fc9a6c66bed1aef3fad7541423c49fa69ea858159e8d3d6903039c7edf5dde65&w=360",
            "postId": 163,
            "eventId": null,
            "messageId": null,
            "groupId": null, 
            "commentId": null,
            "userId": "669bfe2c8486500123a10754",
            "userName": "Marta Wayne"
          },
          "status": "String",
          "timestamp": "2024-08-15"
        },
        {
          "_id": "668164e760dbe0734a2fd9df5b",
          "userId": "669bfe2c8486500123a10754",
          "message": "Capibaras gonna Wild has been growing rapidly in you Neighborhood. Check them out!",
          "title": "Capibaras gonna Wild",
          "triggerType": "cheers",      
          "data": {
            "notificationImage": "https://img.freepik.com/fotos-gratis/capivara-no-habitat-natural-do-norte-do-pantanal-maior-rondent-america-selvagem-da-vida-selvagem-sul-americana-beleza-da-natureza_475641-2161.jpg?t=st=1722531645~exp=1722535245~hmac=940000ad880443f24ddfc51afec3f77a0116cd23c80063e5caecaf8ce3ac7c49&w=596",
            "postId": null,
            "eventId": null,
            "messageId": null,
            "groupId": "668164e760dbe07a2fd9df5b", 
            "commentId": null,
            "userId": "669bfe2c8486500123a10754",
            "userName": "Marta Wayne"
          },
          "status": "String",
          "timestamp": "2024-08-15"
        },
        {
          "_id": "668164e760dbe0734a2fd9df5b",
          "userId": "669bfe2c8486500123a10754",
          "message": "Check this new event on your Neighborhood",
          "title": "Capibaras gonna Wild",
          "triggerType": "cheers",      
          "data": {
            "notificationImage": "https://img.freepik.com/fotos-gratis/jogador-de-futebol-masculino-com-bola-no-campo-de-grama_23-2150821530.jpg?t=st=1722242078~exp=1722245678~hmac=b56686cc1b7765d81d7cf85c2e8792ee14e1b999ea2cce0558b9f855a504611b&w=740",
            "postId": null,
            "eventId": "668164e760dbe07a2fd9df5b",
            "messageId": null,
            "groupId": null, 
            "commentId": null,
            "userId": "669bfe2c8486500123a10754",
            "userName": "Marta Wayne"
          },
          "status": "String",
          "timestamp": "2024-08-15"
        },
        {
          "_id": "668164e760dbe0734a2fd9df5b",
          "userId": "669bfe2c8486500123a10754",
          "message": "Check this new event on your Neighborhood",
          "title": "sent you a message",
          "triggerType": "cheers",      
          "data": {
            "notificationImage": "https://moacir.net/avatars/40.jpg",
            "postId": null,
            "eventId": null,
            "messageId": "668164e760dbe07a2fd9df5b",
            "groupId": null, 
            "commentId": null,
            "userId": "669bfe2c8486500123a10754",
            "userName": "Marta Wayne"
          },
          "status": "String",
          "timestamp": "2024-08-15"
        }
      ]
      ''';

/*
{
          "id": "668164e760dbe07a2fd956df5b",
          "triggerType": "boos",
          "message": "some message",
          "timestamp": "2024-08-14",
          "group": {
            "id": "668164e760dbe07a2fd9df5b",
            "name": "CrazyPeople",
            "notificationImage": ""
          },
          "user":   {
              "userId": "669bfe2c8486500123a10754",
              "userName": "Teresa Madre",
              "picture":"https://moacir.net/avatars/none.png"
            }
        },
        {
          "id": "66813464e760dbe07a2fd9df5b",
          "triggerType": "award",
          "message": "some message",
          "timestamp": "2024-08-12",
          "group": {
            "id": "668164e760dbe07a2fd9df5b",
            "name": "Capibaras gonna Wild",
            "notificationImage": "https://img.freepik.com/fotos-gratis/capivara-no-habitat-natural-do-norte-do-pantanal-maior-rondent-america-selvagem-da-vida-selvagem-sul-americana-beleza-da-natureza_475641-2161.jpg?t=st=1722531645~exp=1722535245~hmac=940000ad880443f24ddfc51afec3f77a0116cd23c80063e5caecaf8ce3ac7c49&w=596"
          },
          "postId": 163,
          "user":  
            {
              "userId": "669bfe2c8486500123a10754",
              "userName": "Peter Sulivan",
              "picture":"https://moacir.net/avatars/77.jpg"
            } 
        },   
        {
          "id": "668164e760dbe07a2fd956df5b",
          "triggerType": "comment",
          "message": "some message",
          "timestamp": "2024-08-05",
          "group": {
            "id": "668164e760dbe07a2fd9df5b",
            "name": "Capibaras gonna Wild",
            "notificationImage": "https://img.freepik.com/fotos-gratis/capivara-no-habitat-natural-do-norte-do-pantanal-maior-rondent-america-selvagem-da-vida-selvagem-sul-americana-beleza-da-natureza_475641-2161.jpg?t=st=1722531645~exp=1722535245~hmac=940000ad880443f24ddfc51afec3f77a0116cd23c80063e5caecaf8ce3ac7c49&w=596"
          },
          "postId": 163,
          "user":  
            {
              "userId": "669bfe2c8486500123a10754",
              "userName": "John Wick",
              "picture":"https://moacir.net/avatars/40.jpg"
            }
        }   
*/
    final fakeJson = json.decode(fakeData);
    return NotificationModel.fromJsonList(fakeJson);

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

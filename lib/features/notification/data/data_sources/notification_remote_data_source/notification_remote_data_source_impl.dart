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

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    print('cookies list $cookies');
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrlNotification/notifications/fetch-notification?page=$page&limit=100';

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
      print('without decode ${jsonDecode(response.body)["notifications"]}');
      print("message API else ${jsonDecode(response.body)}");
      final fakeJson = jsonDecode(response.body)["notifications"];
      return NotificationModel.fromJsonList(fakeJson);
      // return jsonDecode(response.body)["notifications"];
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      print("message API else $message");
      throw ServerException(message: message);
    }
  }
}

  Future<int> getAllNotificationCount({String? page}) async {
    final http.Client client = http.Client();;
    print('... getAllNotification page=$page ');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    print('cookies list $cookies');
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrlNotification/notifications/fetch-notification?page=$page&limit=100';
    // String url = '$kBaseUrlNotification/notifications/fetch-notification?status=unread&page=$page&limit=100';

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
      print('without decode ${jsonDecode(response.body)["notifications"]}');
      print("message API else ${jsonDecode(response.body)}");
      final fakeJson = jsonDecode(response.body)["total"];
      print(fakeJson);
      return fakeJson != null ? fakeJson : 0;
      // return jsonDecode(response.body)["notifications"];
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      print("message API else $message");
      throw ServerException(message: message);
    }
  }

  Future<int> getNotificationUnreadCount() async {

    final http.Client client = http.Client();



    List<String>? cookies = ShardPrefHelper.getCookie();

    String? getAccessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }

    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrlNotification/notifications/get-unread-notification-count';

    print('cookie $cookieHeader');
    //var currentToken = await FirebaseMessaging.instance.getToken();
    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $getAccessToken',
        'Cookie': cookieHeader,
      },

    );

    if (response.statusCode == 200) {
      final fakeJson = jsonDecode(response.body)["unreadCount"];
      return fakeJson != null ? fakeJson : 0;
      return fakeJson;
    } else {

      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      print("message API else $message");
      throw ServerException(message: message);
    }
  }
import 'dart:convert';
import 'dart:io';
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
    print('...updateFCMtoken start');
    var currentToken = await FirebaseMessaging.instance.getToken();
    print('currentToken: $currentToken');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in updateFCMtoken');
      throw const ServerException(message: 'Someting went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/user/save-fcm-token';
    print('url: $url');
    String currentUser = ShardPrefHelper.getUserID() ?? '';
    print('currentUser: $currentUser');

    final response =
        await client.post(Uri.parse(url), headers: <String, String>{
      'Cookie': cookieHeader,
    }, body: {
      "fcmToken": currentToken,
      "userId": currentUser,
    });
    print('updateFCMtoken api response status code: ${response.statusCode}');
    print('updateFCMtoken api response: ${response.body}');
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      final jsonData = jsonDecode(response.body);
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      print('else error in updateFCMtoken: $message');
      // throw ServerException(message: message);
    }
    return currentToken ?? '';
  }

  @override
  Future<List<NotificationModel>> getAllNotification({String? page}) async {
    print('.....getAllNotification start with');
    print('page: $page');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in getAllNotification');
      throw const ServerException(message: 'Someting went wrong');
    }

    String cookieHeader = cookies.join('; ');
    String url =
        '$kBaseUrlNotification/notifications/fetch-notification?page=$page&limit=100';
    print('url: $url');

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );
    print(
        'getAllNotification api response status code: ${response.statusCode}');
    print('getAllNotification api response: ${response.body}');

    if (response.statusCode == 200) {
      final notifications = jsonDecode(response.body)["notifications"];
      return NotificationModel.fromJsonList(notifications);
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      print('else error in getAllNotification: $message');
      throw ServerException(message: message);
    }
  }
}

Future<int> getAllNotificationCount({String? page}) async {
  print('.....getAllNotificationCount start with');
  print('page: $page');
  final http.Client client = http.Client();
  List<String>? cookies = ShardPrefHelper.getCookie();
  if (cookies == null || cookies.isEmpty) {
    print('cookies not found in getAllNotificationCount');
    throw const ServerException(message: 'Someting went wrong');
  }

  String cookieHeader = cookies.join('; ');
  String url =
      '$kBaseUrlNotification/notifications/fetch-notification?page=$page&limit=100';
  print('url: $url');

  final response = await client.get(
    Uri.parse(url),
    headers: <String, String>{
      'Cookie': cookieHeader,
    },
  );
  print(
      'getAllNotificationCount api response status code: ${response.statusCode}');
  print('getAllNotificationCount api response: ${response.body}');
  if (response.statusCode == 200) {
    final notificationCount = jsonDecode(response.body)["total"];
    return notificationCount ?? 0;
  } else {
    final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
    print('else error in getAllNotificationCount: $message');
    throw ServerException(message: message);
  }
}

Future<int> getNotificationUnreadCount() async {
  print('.....getNotificationUnreadCount start');
  final http.Client client = http.Client();
  List<String>? cookies = ShardPrefHelper.getCookie();
  String? getAccessToken = ShardPrefHelper.getAccessToken();
  if (cookies == null || cookies.isEmpty) {
    print('cookies not found in getNotificationUnreadCount');
    throw const ServerException(message: 'Someting went wrong');
  }

  String cookieHeader = cookies.join('; ');
  String url =
      '$kBaseUrlNotification/notifications/get-unread-notification-count';
  print('url: $url');
  try {
    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $getAccessToken',
        'Cookie': cookieHeader,
      },
    );
    print(
        'getNotificationUnreadCount api response status code: ${response.statusCode}');
    print('getNotificationUnreadCount api response: ${response.body}');
    if (response.statusCode == 200) {
      final unreadCount = jsonDecode(response.body)["unreadCount"];
      return unreadCount ?? 0;
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
      print('else error in getNotificationUnreadCount: $message');
      throw ServerException(message: message);
    }
  } on SocketException catch (_) {
    throw ServerException(
      message: 'oops something went wrong',
    );
  } catch (e) {
    throw ServerException(
      message: 'oops something went wrong',
    );
  }
}

Future<void> updateNotificationStatus(List<String> notificationIds) async {
  print('...updateNotificationStatus start with');
  print('notificationIds: $notificationIds');
  // print('notificationIds $notificationId');

  final http.Client client = http.Client();
  List<String>? cookies = ShardPrefHelper.getCookie();
  String? getAccessToken = ShardPrefHelper.getAccessToken();

  if (cookies == null || cookies.isEmpty) {
    print('cookies not found in updateNotificationStatus');
    throw const ServerException(message: 'Someting went wrong');
  }

  String cookieHeader = cookies.join('; ');
  String url =
      // '$kBaseUrlNotification/notifications/update-notification-status?notificationId=$notificationId';
      '$kBaseUrlNotification/notifications/update-notification-status';

  print('url $url');

  final response = await client.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $getAccessToken',
      'Cookie': cookieHeader,
    },
    body: jsonEncode({
      'notificationIds': notificationIds,
    }),
  );
  print(
      'updateNotificationStatus api response status code: ${response.statusCode}');
  print('updateNotificationStatus api response: ${response.body}');
  if (response.statusCode == 200 ||
      jsonDecode(response.body)['message'] ==
          "Notification not found or already read") {
    print("Notification status updated successfully.");
  } else {
    final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
    print('else error in updateNotificationStatus: $message');
    throw ServerException(message: message);
  }
}

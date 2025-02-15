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
    var currentToken = await FirebaseMessaging.instance.getToken();

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Someting went wrong');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/user/save-fcm-token';

    String currentUser = ShardPrefHelper.getUserID() ?? '';

    final response =
        await client.post(Uri.parse(url), headers: <String, String>{
      'Cookie': cookieHeader,
    }, body: {
      "fcmToken": currentToken,
      "userId": currentUser,
    });

    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      final jsonData = jsonDecode(response.body);
    } else {
      // final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';
    }
    return currentToken ?? '';
  }

  @override
  Future<List<NotificationModel>> getAllNotification({String? page}) async {
    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Someting went wrong');
    }

    String cookieHeader = cookies.join('; ');
    String url =
        '$kBaseUrlNotification/notifications/fetch-notification?page=$page&limit=100';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {
      final notifications = jsonDecode(response.body)["notifications"];
      return NotificationModel.fromJsonList(notifications);
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';

      throw ServerException(message: message);
    }
  }
}

Future<int> getAllNotificationCount({String? page}) async {
  final http.Client client = http.Client();
  List<String>? cookies = ShardPrefHelper.getCookie();
  if (cookies == null || cookies.isEmpty) {
    throw const ServerException(message: 'Someting went wrong');
  }

  String cookieHeader = cookies.join('; ');
  String url =
      '$kBaseUrlNotification/notifications/fetch-notification?page=$page&limit=100';

  final response = await client.get(
    Uri.parse(url),
    headers: <String, String>{
      'Cookie': cookieHeader,
    },
  );

  if (response.statusCode == 200) {
    final notificationCount = jsonDecode(response.body)["total"];
    return notificationCount ?? 0;
  } else {
    final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';

    throw ServerException(message: message);
  }
}

Future<int> getNotificationUnreadCount() async {
  final http.Client client = http.Client();
  List<String>? cookies = ShardPrefHelper.getCookie();
  String? getAccessToken = ShardPrefHelper.getAccessToken();
  if (cookies == null || cookies.isEmpty) {
    throw const ServerException(message: 'Someting went wrong');
  }

  String cookieHeader = cookies.join('; ');
  String url =
      '$kBaseUrlNotification/notifications/get-unread-notification-count';

  try {
    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $getAccessToken',
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {
      final unreadCount = jsonDecode(response.body)["unreadCount"];
      return unreadCount ?? 0;
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops someting went wrong';

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
  final http.Client client = http.Client();
  List<String>? cookies = ShardPrefHelper.getCookie();
  String? getAccessToken = ShardPrefHelper.getAccessToken();

  if (cookies == null || cookies.isEmpty) {
    throw const ServerException(message: 'Someting went wrong');
  }

  String cookieHeader = cookies.join('; ');
  String url =
      // '$kBaseUrlNotification/notifications/update-notification-status?notificationId=$notificationId';
      '$kBaseUrlNotification/notifications/update-notification-status';

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

  if (response.statusCode == 200 ||
      jsonDecode(response.body)['message'] ==
          "Notification not found or already read") {
  } else {
    final message = jsonDecode(response.body)['msg'] ?? 'Someting went wrong';

    throw ServerException(message: message);
  }
}

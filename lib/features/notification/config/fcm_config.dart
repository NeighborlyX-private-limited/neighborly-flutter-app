import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'fcm_config_interface.dart';
import 'locale_notifications_manager.dart';
import 'message_behavior.dart';
import 'message_handler_helper.dart';

class FCMConfig extends FCMConfigInterface<AndroidNotificationDetails,
    DarwinNotificationDetails, AndroidNotificationSound, StyleInformation> {
  @override
  Future<RemoteMessage?> getInitialMessage() async {
    return await FirebaseMessaging.instance.getInitialMessage();
  }

  @override
  Future init({
    List<MessageBehavior> messageBehaviors = const <MessageBehavior>[],
    BackgroundMessageHandler? onBackgroundMessage,
    String? appAndroidIcon,
    String? androidChannelId,
    String? androidChannelName,
    String? androidChannelDescription,
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
    FirebaseOptions? options,
    String? name,
    bool displayInForeground = true,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    print('step 1');

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: alert,
      badge: badge,
      sound: sound,
    );

    if (onBackgroundMessage != null) {
      print('step 2');
      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    }

    await LocaleNotificationManager.init(
      appAndroidIcon,
      androidChannelId,
      androidChannelName,
      androidChannelDescription,
    );

    Future<void> handleMessage(RemoteMessage message) async {
      print('step 3: ${message.data}');
      MessageHandlerHelper(messageData: message.data).doTheJump();
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage notification) {
      if (displayInForeground && notification.notification != null) {
        LocaleNotificationManager.displayNotification(
          notification,
          androidChannelId,
          androidChannelName,
          androidChannelDescription,
        );
      }
    });
    LocaleNotificationManager.onLocaleClick.stream.listen(
      (message) => handleMessage(message),
      onError: (error) {},
      onDone: () {},
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => handleMessage(message),
      onError: (error) {},
      onDone: () {},
    );
  }

  @override
  Future<void> deleteToken({String? senderId}) =>
      FirebaseMessaging.instance.deleteToken();

  @override
  Future<String?> getAPNSToken() => FirebaseMessaging.instance.getAPNSToken();

  @override
  Future<NotificationSettings> getNotificationSettings() =>
      FirebaseMessaging.instance.getNotificationSettings();

  @override
  Future<String?> getToken({String? vapidKey}) =>
      FirebaseMessaging.instance.getToken(vapidKey: vapidKey);

  @override
  bool get isAutoInitEnabled => FirebaseMessaging.instance.isAutoInitEnabled;

  @override
  Stream<String> get onTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;

  @override
  Map get pluginConstants => FirebaseMessaging.instance.pluginConstants;

  @override
  Future<void> subscribeToTopic(String topic) =>
      FirebaseMessaging.instance.subscribeToTopic(topic);

  @override
  Future<void> unsubscribeFromTopic(String topic) =>
      FirebaseMessaging.instance.unsubscribeFromTopic(topic);

  @override
  void displayNotification({
    required String title,
    required String body,
    String? subTitle,
    int? id,
    String? category,
    String? collapseKey,
    AndroidNotificationSound? sound,
    String? androidChannelId,
    String? androidChannelName,
    String? androidChannelDescription,
    Map<String, dynamic>? data,
  }) {
    var localeNotification = FlutterLocalNotificationsPlugin();
    var iOS = DarwinNotificationDetails(subtitle: subTitle);
    var android = AndroidNotificationDetails(
      androidChannelId ?? 'FCM_Config',
      androidChannelName ?? 'FCM_Config',
      importance: Importance.high,
      priority: Priority.high,
      groupKey: collapseKey,
      showProgress: false,
      sound: sound,
      subText: subTitle,
    );
    var details = NotificationDetails(android: android, iOS: iOS);
    var id0 = id ?? DateTime.now().difference(DateTime(2021)).inSeconds;
    var notify = RemoteMessage(
        data: data ?? {},
        from: 'locale',
        sentTime: DateTime.now(),
        collapseKey: collapseKey,
        messageId: id0.toString(),
        category: category,
        contentAvailable: true,
        notification: RemoteNotification(
          title: title,
          body: body,
        ));

    localeNotification.show(
      id0,
      title,
      body,
      details,
      payload: jsonEncode(notify.toMap()),
    );
  }

  @override
  void displayNotificationWithAndroidStyle({
    required String title,
    required StyleInformation styleInformation,
    required String body,
    String? subTitle,
    int? id,
    String? category,
    String? collapseKey,
    AndroidNotificationSound? sound,
    String? androidChannelId,
    String? androidChannelName,
    String? androidChannelDescription,
    Map<String, dynamic>? data,
  }) {
    var localeNotification = FlutterLocalNotificationsPlugin();
    var iOS = DarwinNotificationDetails(subtitle: subTitle);
    var android = AndroidNotificationDetails(
      androidChannelId ?? 'FCM_Config',
      androidChannelName ?? 'FCM_Config',
      importance: Importance.high,
      priority: Priority.high,
      groupKey: collapseKey,
      sound: sound,
      subText: subTitle,
      styleInformation: styleInformation,
    );
    var details = NotificationDetails(android: android, iOS: iOS);
    var id0 = id ?? DateTime.now().difference(DateTime(2021)).inSeconds;
    var notify = RemoteMessage(
        data: data ?? {},
        from: 'locale',
        category: category,
        collapseKey: collapseKey,
        messageId: id0.toString(),
        sentTime: DateTime.now(),
        contentAvailable: true,
        notification: RemoteNotification(
          title: title,
          body: body,
        ));
    localeNotification.show(
      id0,
      title,
      body,
      details,
      payload: jsonEncode(notify.toMap()),
    );
  }

  @override
  void displayNotificationWith({
    required String title,
    String? body,
    int? id,
    Map<String, dynamic>? data,
    required AndroidNotificationDetails android,
    required DarwinNotificationDetails iOS,
  }) {
    var localeNotification = FlutterLocalNotificationsPlugin();
    var details = NotificationDetails(android: android, iOS: iOS);
    var id0 = id ?? DateTime.now().difference(DateTime(2021)).inSeconds;
    var notify = RemoteMessage(
        data: data ?? {},
        from: 'locale',
        sentTime: DateTime.now(),
        contentAvailable: true,
        collapseKey: Platform.isIOS ? iOS.threadIdentifier : android.groupKey,
        messageId: id0.toString(),
        notification: RemoteNotification(
          title: title,
          body: body,
        ));
    localeNotification.show(
      id0,
      title,
      body,
      details,
      payload: jsonEncode(notify.toMap()),
    );
  }

  @override
  void displayNotificationFrom({
    required RemoteMessage notification,
    int? id,
    String? androidChannelId,
    String? androidChannelName,
    String? androidChannelDescription,
  }) =>
      LocaleNotificationManager.displayNotification(
        notification,
        androidChannelId,
        androidChannelName,
        androidChannelDescription,
        id,
      );
}

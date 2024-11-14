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
    // if (!kIsWeb) {
    //   var initial = await LocaleNotificationManager.getInitialMessage();
    //   if (initial != null) return initial;
    // }
    return await FirebaseMessaging.instance.getInitialMessage();
  }

  @override
  Future init({
    /// List that contains functions to be executed depending on specific keys inside "data" field on the message
    List<MessageBehavior> messageBehaviors = const <MessageBehavior>[],

    /// this function will be excuted while application is in background
    /// Not work on the web
    BackgroundMessageHandler? onBackgroundMessage,

    /// Drawable icon works only in forground
    String? appAndroidIcon,

    /// Required to show head up notification in foreground
    String? androidChannelId,

    /// Required to show head up notification in foreground
    String? androidChannelName,

    /// Required to show head up notification in foreground
    String? androidChannelDescription,

    /// Request permission to display alerts. Defaults to `true`.
    ///
    /// iOS/macOS only.
    bool alert = true,

    /// Request permission for Siri to automatically read out notification messages over AirPods.
    /// Defaults to `false`.
    ///
    /// iOS only.
    bool announcement = false,

    /// Request permission to update the application badge. Defaults to `true`.
    ///
    /// iOS/macOS only.
    bool badge = true,

    /// Request permission to display notifications in a CarPlay environment.
    /// Defaults to `false`.
    ///
    /// iOS only.
    bool carPlay = false,

    /// Request permission for critical alerts. Defaults to `false`.
    ///
    /// Note; your application must explicitly state reasoning for enabling
    /// critical alerts during the App Store review process or your may be
    /// rejected.
    ///
    /// iOS only.
    bool criticalAlert = false,

    /// Request permission to provisionally create non-interrupting notifications.
    /// Defaults to `false`.
    ///
    /// iOS only.
    bool provisional = false,

    /// Request permission to play sounds. Defaults to `true`.
    ///
    /// iOS/macOS only.
    bool sound = true,

    /// Options to pass to core intialization method
    FirebaseOptions? options,

    ///Name of the firebase instance app
    String? name,
    bool displayInForeground = true,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();

    // await Firebase.initializeApp(
    //   name: name,
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );

    // await FirebaseMessaging.instance.requestPermission(
    //   alert: alert,
    //   announcement: announcement,
    //   criticalAlert: criticalAlert,
    //   badge: badge,
    //   carPlay: carPlay,
    //   sound: sound,
    //   provisional: provisional,
    // );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: alert,
      badge: badge,
      sound: sound,
    );

    if (onBackgroundMessage != null) {
      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    }

    await LocaleNotificationManager.init(
      appAndroidIcon,
      androidChannelId,
      androidChannelName,
      androidChannelDescription,
    );

    Future<void> handleMessage(RemoteMessage message) async {
      // this part works with the app in BACKGROUND
      print('...FCMConfig handleMessage: $message');
      print(
          '...FCMConfig handleMessage existe order?: ${(message.data["order"] != null)}');
      print(
          '...FCMConfig handleMessage existe valor? order?: ${message.data["order"]}');

      MessageHandlerHelper(messageData: message.data).doTheJump();
    }

    FirebaseMessaging.onMessage.listen((notification) {
      print('...FCMConfig listen - displayInForeground=$displayInForeground');
      print('...FCMConfig listen - notification=$notification');
      print(
          '...FCMConfig listen - notification.notification:${notification.notification}');
      print(
          '...FCMConfig listen - notification.notificationBODY:${notification.notification?.body}');
      print(
          '...FCMConfig listen - notification.notificationTITLE:${notification.notification?.title}');
      print(
          '...FCMConfig listen - notification.notificationDATA:${notification.notification}');
      if (displayInForeground && notification.notification != null) {
        // MessageHandlerHelper(messageData: notification.data).doTheJump();

        LocaleNotificationManager.displayNotification(
          notification,
          androidChannelId,
          androidChannelName,
          androidChannelDescription,
        );
      }
    });
    LocaleNotificationManager.onLocaleClick.stream
        .listen((message) => handleMessage(message), onError: (error) {
      print('...FCMConfig onLocaleClick error: $error');
    }, onDone: () {
      print('...FCMConfig onLocaleClick DONE');
    });
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage,
        onError: (error) {
      print('...FCMConfig onMessageOpenedApp error:$error');
    }, onDone: () {
      print('...FCMConfig onMessageOpenedApp DONE');
    });
  }

  ///Call to FirebaseMessaging.instance.deleteToken();
  @override
  Future<void> deleteToken({String? senderId}) =>
      FirebaseMessaging.instance.deleteToken();

  ///Call to FirebaseMessaging.instance.getAPNSToken();
  @override
  Future<String?> getAPNSToken() => FirebaseMessaging.instance.getAPNSToken();

  ///Call to FirebaseMessaging.instance.getNotificationSettings();
  @override
  Future<NotificationSettings> getNotificationSettings() =>
      FirebaseMessaging.instance.getNotificationSettings();

  ///Call to FirebaseMessaging.instance.getToken();
  @override
  Future<String?> getToken({String? vapidKey}) =>
      FirebaseMessaging.instance.getToken(vapidKey: vapidKey);

  ///Call to FirebaseMessaging.instance.isAutoInitEnabled();
  @override
  bool get isAutoInitEnabled => FirebaseMessaging.instance.isAutoInitEnabled;

  ///Call to FirebaseMessaging.instance.onTokenRefresh();
  @override
  Stream<String> get onTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;

  ///Call to FirebaseMessaging.instance.pluginConstants;
  @override
  Map get pluginConstants => FirebaseMessaging.instance.pluginConstants;

  ///Call to FirebaseMessaging.instance.sendMessage();
  // @override
  // Future<void> sendMessage({
  //   String? to,
  //   Map<String, String>? data,
  //   String? collapseKey,
  //   String? messageId,
  //   String? messageType,
  //   int? ttl,
  // }) =>
  //     FirebaseMessaging.instance.sendMessage(
  //       to: to,
  //       data: data,
  //       collapseKey: collapseKey,
  //       messageId: messageId,
  //       messageType: messageType,
  //       ttl: ttl,
  //     );

  ///Call to FirebaseMessaging.instance.subscribeToTopic();
  ///Not supported in web
  @override
  Future<void> subscribeToTopic(String topic) =>
      FirebaseMessaging.instance.subscribeToTopic(topic);

  ///Call to FirebaseMessaging.instance.unsubscribeFromTopic();
  ///Not supported in web
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
      // androidChannelDescription ?? 'FCM_Config',
      importance: Importance.high,
      priority: Priority.high,
      // category: category,
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

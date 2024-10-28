import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'fcm_extension.dart';

class LocaleNotificationManager {
  static final StreamController<RemoteMessage> onLocaleClick =
      StreamController<RemoteMessage>.broadcast();

  // static Future _onPayLoad(String? payload) async {
  //   if (payload == null) return;
  //   var message = RemoteMessage.fromMap(jsonDecode(payload));
  //   onLocaleClick.add(message);
  // }

  // static Future<RemoteMessage?> getInitialMessage() async {
  //   var _localeNotification = FlutterLocalNotificationsPlugin();
  //   var payload = await _localeNotification.getNotificationAppLaunchDetails();
  //   if (payload != null && payload.didNotificationLaunchApp) {
  //     return RemoteMessage.fromMap(jsonDecode(payload ?? ''));
  //   }
  //   return null;
  // }

  static Future init(
    /// Drawable icon works only in forground
    String? appAndroidIcon,

    /// Required to show head up notification in foreground
    String? androidChannelId,

    /// Required to show head up notification in foreground
    String? androidChannelName,

    /// Required to show head up notification in foreground
    String? androidChannelDescription,
  ) async {
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    //! Android settings
    var initializationSettingsAndroid = AndroidInitializationSettings(
      appAndroidIcon ?? '@mipmap/ic_launcher',
    );
    //! Ios setings
    const initializationSettingsIOS = DarwinInitializationSettings();
    //! macos setings
    // final initializationSettingsMac = MacOSInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      // macOS: initializationSettingsMac,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: _onPayLoad,
    );
  }

  static void displayNotification(
      RemoteMessage notification,
      String? androidChannelId,
      String? androidChannelName,
      String? androidChannelDescription,
      [int? id]) {
    if (notification.notification == null) return;

    print(
        '... LocaleNotificationManager displayNotification notification: ${notification.toString()}');
    var localeNotification = FlutterLocalNotificationsPlugin();
    var smallIcon = notification.notification?.android?.smallIcon;

    //! Android settings
    var _android = AndroidNotificationDetails(
      androidChannelId ??
          notification.notification?.android?.channelId ??
          'FCM_Config',
      androidChannelName ??
          notification.notification?.android?.channelId ??
          'FCM_Config',
      // androidChannelDescription ?? notification.notification?.android?.channelId ?? 'FCM_Config',
      importance: _getImportance(notification.notification!),
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        notification.notification?.body ?? '',
        htmlFormatBigText: true,
      ),
      ticker: notification.notification?.android?.ticker,
      icon: smallIcon == 'default' ? null : smallIcon,
      // category: notification.category,
      groupKey: notification.collapseKey,
      showProgress: false,
      sound: notification.isDefaultAndroidSound
          ? null
          : (notification.isAndroidRemoteSound
              ? UriAndroidNotificationSound(
                  notification.notification!.android!.sound!)
              : RawResourceAndroidNotificationSound(
                  notification.notification!.android!.sound)),
    );
    var badge = int.tryParse(notification.notification?.apple?.badge ?? '');
    var _ios = DarwinNotificationDetails(
      threadIdentifier: notification.collapseKey,
      sound: notification.notification?.apple?.sound?.name,
      badgeNumber: badge,
      subtitle: notification.notification?.apple?.subtitle,
      presentBadge: badge == null ? null : true,
    );
    var _mac = DarwinNotificationDetails(
      threadIdentifier: notification.collapseKey,
      sound: notification.notification?.apple?.sound?.name,
      badgeNumber: badge,
      subtitle: notification.notification?.apple?.subtitle,
      presentBadge: badge == null ? null : true,
    );
    var details = NotificationDetails(
      android: _android,
      iOS: _ios,
      macOS: _mac,
    );
    var _id = id ?? DateTime.now().difference(DateTime(2021)).inSeconds;

    print('...LocaleNotificationManager displayNotification _id: $_id');
    print(
        '...LocaleNotificationManager displayNotification title: ${notification.notification!.title}');
    print(
        '...LocaleNotificationManager displayNotification body: ${notification.notification!.body}');
    print(
        '...LocaleNotificationManager displayNotification _details: $details');
    print(
        '...LocaleNotificationManager displayNotification payload: ${jsonEncode(notification.toMap())}');
    try {
      localeNotification.show(
        _id,
        notification.notification!.title,
        notification.notification!.body,
        details,
        payload: jsonEncode(notification.toMap()),
      );
    } catch (e) {
      print('LocaleNotificationManager ERROR: $e');
    }
  }

  static Importance _getImportance(RemoteNotification notification) {
    if (notification.android?.priority == null) return Importance.high;
    switch (notification.android!.priority) {
      case AndroidNotificationPriority.minimumPriority:
        return Importance.min;
      case AndroidNotificationPriority.lowPriority:
        return Importance.low;
      case AndroidNotificationPriority.defaultPriority:
        return Importance.defaultImportance;
      case AndroidNotificationPriority.highPriority:
        return Importance.high;
      case AndroidNotificationPriority.maximumPriority:
        return Importance.max;
      default:
        return Importance.max;
    }
  }
}

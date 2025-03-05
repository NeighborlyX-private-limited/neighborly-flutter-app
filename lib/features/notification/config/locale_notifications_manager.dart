import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'fcm_extension.dart';

class LocaleNotificationManager {
  static final StreamController<RemoteMessage> onLocaleClick =
      StreamController<RemoteMessage>.broadcast();

  static Future init(
    String? appAndroidIcon,
    String? androidChannelId,
    String? androidChannelName,
    String? androidChannelDescription,
  ) async {
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = AndroidInitializationSettings(
      appAndroidIcon ?? '@mipmap/ic_launcher',
    );

    const initializationSettingsIOS = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static void displayNotification(
      RemoteMessage notification,
      String? androidChannelId,
      String? androidChannelName,
      String? androidChannelDescription,
      [int? id]) {
    if (notification.notification == null) return;

    var localeNotification = FlutterLocalNotificationsPlugin();
    var smallIcon = notification.notification?.android?.smallIcon;

    var android = AndroidNotificationDetails(
      androidChannelId ??
          notification.notification?.android?.channelId ??
          'FCM_Config',
      androidChannelName ??
          notification.notification?.android?.channelId ??
          'FCM_Config',
      importance: _getImportance(notification.notification!),
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        notification.notification?.body ?? '',
        htmlFormatBigText: true,
      ),
      ticker: notification.notification?.android?.ticker,
      icon: smallIcon == 'default' ? null : smallIcon,
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
    var ios = DarwinNotificationDetails(
      threadIdentifier: notification.collapseKey,
      sound: notification.notification?.apple?.sound?.name,
      badgeNumber: badge,
      subtitle: notification.notification?.apple?.subtitle,
      presentBadge: badge == null ? null : true,
    );
    var mac = DarwinNotificationDetails(
      threadIdentifier: notification.collapseKey,
      sound: notification.notification?.apple?.sound?.name,
      badgeNumber: badge,
      subtitle: notification.notification?.apple?.subtitle,
      presentBadge: badge == null ? null : true,
    );
    var details = NotificationDetails(
      android: android,
      iOS: ios,
      macOS: mac,
    );
    var id0 = id ?? DateTime.now().difference(DateTime(2021)).inSeconds;

    try {
      localeNotification.show(
        id0,
        notification.notification!.title,
        notification.notification!.body,
        details,
        payload: jsonEncode(notification.toMap()),
      );
    } catch (e) {}
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

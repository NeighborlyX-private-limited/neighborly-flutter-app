import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../dependency_injection.dart' as di;
import '../../features/notification/config/fcm_config.dart';
import '../../features/notification/config/message_behaviors/order_message_behavior.dart';
import '../../features/notification/config/push_notification_handler.dart';
import '../../firebase_options.dart';
import '../utils/shared_preference.dart';

class AppInitializers {
  static Future init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Firebase
    final fcmConfig = FCMConfig();
    const appName = 'Neighborly';
    await fcmConfig.init(
      messageBehaviors: [OrderMessageBehavior()],
      onBackgroundMessage: firebaseMessagingBackgroundHandler,
      androidChannelId: appName,
      androidChannelName: '$appName Channel',
      androidChannelDescription: appName,
      appAndroidIcon: '@mipmap/ic_launcher',
      displayInForeground: Platform.isAndroid,
    );

    await Hive.initFlutter();
    await Hive.openBox('postReactions');
    await Hive.openBox('commentReactions');
    await Hive.openBox('replyReactions');
    await Hive.openBox('pollVotes');
    di.init();
    await ShardPrefHelper.init();

    var FCMtoken = await fcmConfig.getToken() ?? '';
    ShardPrefHelper.setFCMtoken(FCMtoken);
    print('App Initializer - Token FCM: $FCMtoken ');
  }
}

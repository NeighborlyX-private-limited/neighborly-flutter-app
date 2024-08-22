import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Background push received!');
  debugPrint('Notification data: ${message.data}');
}

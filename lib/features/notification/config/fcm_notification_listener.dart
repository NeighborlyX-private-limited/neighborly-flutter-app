import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// This mixin can listen to incoming notification
mixin FCMNotificationMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<RemoteMessage>? _subscription;

  @override
  void initState() {
    _subscription = FirebaseMessaging.onMessage.listen(_onNewNotify);
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// Will be called whenever a new notification come and app is in foreground
  void onNotify(RemoteMessage notification);

  void _onNewNotify(RemoteMessage notification) {
    if (mounted) onNotify(notification);
  }
}

/// This stateful can listen to incoming notification instead of mixin
class FCMNotificationListener extends StatefulWidget {
  final Widget child;

  /// Will be called whenever a new notification come and app is in foreground
  final Function(RemoteMessage notification, VoidCallback setState)
      onNotification;

  const FCMNotificationListener({
    super.key,
    required this.child,
    required this.onNotification,
  });

  @override
  _FCMNotificationListenerState createState() =>
      _FCMNotificationListenerState();
}

class _FCMNotificationListenerState extends State<FCMNotificationListener>
    with FCMNotificationMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override

  /// Will be called whenever a new notification come and app is in foreground
  void onNotify(RemoteMessage notification) {
    widget.onNotification(
      notification,
      () {
        if (mounted) setState(() {});
      },
    );
  }
}

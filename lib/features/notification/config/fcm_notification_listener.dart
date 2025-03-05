import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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

  void onNotify(RemoteMessage notification);

  void _onNewNotify(RemoteMessage notification) {
    if (mounted) onNotify(notification);
  }
}

class FCMNotificationListener extends StatefulWidget {
  final Widget child;

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
  void onNotify(RemoteMessage notification) {
    widget.onNotification(
      notification,
      () {
        if (mounted) setState(() {});
      },
    );
  }
}

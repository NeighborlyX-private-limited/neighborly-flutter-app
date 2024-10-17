import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:convert';
import '../../../core/utils/shared_preference.dart';

class SocketService {
  io.Socket? _socket;
  // Callback to notify new message
  Function(Map<String, dynamic>)? onNewMessageReceived;

  void connect({String groupId = ''}) {
    _socket = io.io(
      'ws://54.90.230.2:3001',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 1000,
      },
    );

    _socket!.connect();

    // Handle socket events here
    _socket!.onConnect((_) {
      print('Connected to Socket.io server');
      joinRoom(groupId);
    });

    _socket!.on('connect', (_) {
      print('Connected to socket server $groupId');
      joinRoom(groupId);
    });

    _socket?.onReconnect((_) {
      print('Reconnected');
    });

    _socket?.onReconnectError((_) {
      print('Failed to reconnect');
    });

    _socket!.on('disconnect', (_) {
      print('Disconnected from socket server');
      if (groupId != '' && groupId.isNotEmpty) {
        String? name = ShardPrefHelper.getUsername();
        _socket!.emit('leave-room', {'name': name, 'groupId': groupId});
      }
    });
    _socket?.on('receive-message', (data) {
      print('New message received: ${jsonEncode(data)}');
      if (onNewMessageReceived != null) {
        onNewMessageReceived!(data);
      }
    });

    _socket!.onError((error) {
      print('Socket error: $error');
    });

    _socket!.onConnectError((error) {
      print('Connection error: $error');
    });

    _socket!.onDisconnect((_) {
      print('Disconnected from socket server');
    });
  }

  void sendMessage(String roomId, var payload, bool isMsg) {
    String? accessToken = ShardPrefHelper.getAccessToken();
    String? refreshtoken = ShardPrefHelper.getRefreshToken();
    payload['accessToken'] = accessToken;
    payload['refreshToken'] = refreshtoken;
    print('sending payload $payload');
    if (isMsg) {
      _socket?.emit('send-message', payload);
    } else {
      _socket?.emit('feedback', payload);
    }
  }

  void joinRoom(String groupId) {
    print('room id for join $groupId');
    if (groupId != '' && groupId.isNotEmpty) {
      String? name = ShardPrefHelper.getUsername();
      final payload = {'name': '$name', 'groupId': groupId};
      _socket!.emit('join-room', payload);
    }
  }

  void dispose(String roomId) {
    print("socket dispose");
    _socket?.disconnect();
    _socket?.dispose();
    if (roomId != '' && roomId.isNotEmpty) {
      String? name = ShardPrefHelper.getUsername();
      final payload = {'name': '$name', 'groupId': roomId};
      _socket!.emit('leave-room', payload);
    }
  }
}

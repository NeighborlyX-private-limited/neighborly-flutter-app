import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import '../data/model/chat_message_model.dart';

import '../../../core/utils/shared_preference.dart';

class SocketService {
  IO.Socket? _socket;
  Function(Map<String, dynamic>)? onNewMessageReceived; // Callback to notify new message

  void connect({String groupId = ''}) {
          _socket = IO.io('ws://54.90.230.2:3001', <String, dynamic>{
            'transports': ['websocket'],
            'autoConnect': true,
            'reconnection': true,   // Enable automatic reconnection
            'reconnectionAttempts': 5, // Limit the number of reconnection attempts
            'reconnectionDelay': 1000,
          });

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
            if(groupId != '' && groupId.length > 0) {
            String? name = ShardPrefHelper.getUsername();
            _socket!.emit('leave-room', { 'name': name, 'groupId': groupId });
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

  void sendMessage(String roomId, var payload,bool isMsg) {
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
      if(groupId != '' && groupId.length > 0) {
        String? name = ShardPrefHelper.getUsername();
        final payload = {
        'name': '$name',
        'groupId': '$groupId'
      };
      _socket!.emit('join-room', payload);
    }
  }

  void dispose(String roomId) {
    print("socket dispose");
    _socket?.disconnect();
    _socket?.dispose();
    if(roomId != '' && roomId.length > 0) {
      String? name = ShardPrefHelper.getUsername();
        final payload = {
          'name': '$name',
          'groupId': '$roomId'
        };
      _socket!.emit('leave-room', payload);
    }
  }
}

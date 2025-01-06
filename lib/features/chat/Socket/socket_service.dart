// import 'package:socket_io_client/socket_io_client.dart' as io;
// import 'dart:convert';
// import '../../../core/utils/shared_preference.dart';

// class SocketService {
//   io.Socket? _socket;
//   // Callback to notify new message
//   Function(Map<String, dynamic>)? onNewMessageReceived;

//   void connect({String groupId = ''}) {
//     _socket = io.io(
//       'ws://35.154.40.61:3001',
//       <String, dynamic>{
//         'transports': ['websocket'],
//         'autoConnect': true,
//         'reconnection': true,
//         'reconnectionAttempts': 5,
//         'reconnectionDelay': 1000,
//       },
//     );

//     _socket!.connect();

//     /// Handle socket events here
//     _socket!.onConnect((_) {
//       print('Connected to Socket.io server');
//       joinRoom(groupId);
//     });

//     _socket!.on('connect', (_) {
//       print('Connected to socket server $groupId');
//       joinRoom(groupId);
//     });

//     _socket?.onReconnect((_) {
//       print('Reconnected');
//     });

//     _socket?.onReconnectError((_) {
//       print('Failed to reconnect');
//     });

//     _socket!.on('disconnect', (_) {
//       print('Disconnected from socket server');
//       if (groupId != '' && groupId.isNotEmpty) {
//         String? name = ShardPrefHelper.getUsername();
//         _socket!.emit('leave-room', {'name': name, 'groupId': groupId});
//       }
//     });
//     _socket?.on('receive-message', (data) {
//       print('New message received: ${jsonEncode(data)}');
//       if (onNewMessageReceived != null) {
//         onNewMessageReceived!(data);
//       }
//     });

//     _socket!.onError((error) {
//       print('Socket error: $error');
//     });

//     _socket!.onConnectError((error) {
//       print('Connection error: $error');
//     });

//     _socket!.onDisconnect((_) {
//       print('Disconnected from socket server');
//     });
//   }

//   void sendMessage(String roomId, var payload, bool isMsg) {
//     String? accessToken = ShardPrefHelper.getAccessToken();
//     String? refreshtoken = ShardPrefHelper.getRefreshToken();
//     payload['accessToken'] = accessToken;
//     payload['refreshToken'] = refreshtoken;
//     print('sending payload $payload');
//     if (isMsg) {
//       _socket?.emit('send-message', payload);
//     } else {
//       _socket?.emit('feedback', payload);
//     }
//   }

//   void joinRoom(String groupId) {
//     print('room id for join $groupId');
//     if (groupId != '' && groupId.isNotEmpty) {
//       String? name = ShardPrefHelper.getUsername();
//       final payload = {'name': '$name', 'groupId': groupId};
//       _socket!.emit('join-room', payload);
//     }
//   }

//   void dispose(String roomId) {
//     print("socket dispose");
//     _socket?.disconnect();
//     _socket?.dispose();
//     if (roomId != '' && roomId.isNotEmpty) {
//       String? name = ShardPrefHelper.getUsername();
//       final payload = {'name': '$name', 'groupId': roomId};
//       _socket!.emit('leave-room', payload);
//     }
//   }
// }

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:convert';
import '../../../core/utils/shared_preference.dart';

class SocketService {
  io.Socket? _socket;

  void connect({String groupId = ''}) {
    ///check if already connected
    if (_socket != null && _socket!.connected) {
      print('Already connected to socket server');
      return;
    }

    _socket = io.io(
      'ws://35.154.40.61:3001',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 1000,
      },
    );

    /// on connect
    _socket!.onConnect((_) {
      print('Connected to Socket server');
      joinRoom(groupId);
    });

    /// onReconnect
    _socket?.onReconnect((_) => print('Reconnected'));

    /// onReconnectError
    _socket?.onReconnectError((_) => print('Failed to reconnect'));

    /// onDisconnect
    _socket!.onDisconnect((_) => print('Disconnected from socket server'));

    /// Listen to events
    _addListeners(groupId);
  }

  void _addListeners(String groupId) {
    _socket?.off('receive-message'); // Prevent duplicate listeners
    _socket?.on('receive-message', (data) {
      print('New message received: ${jsonEncode(data)}');
      onNewMessageReceived?.call(data);
    });

    _socket?.on('join-room-error', (data) {
      print('Error joining room: ${jsonEncode(data)}');
      // Handle error logic, like showing a UI message
    });

    _socket?.onError((error) => print('Socket error: $error'));
    _socket?.onConnectError((error) => print('Connection error: $error'));
  }

  void sendMessage(String roomId, Map<String, dynamic> payload, bool isMsg) {
    String? accessToken = ShardPrefHelper.getAccessToken();
    String? refreshToken = ShardPrefHelper.getRefreshToken();

    payload['accessToken'] = accessToken;
    payload['refreshToken'] = refreshToken;

    print('Sending payload: $payload');
    if (isMsg) {
      _socket?.emit('send-message', payload);
    } else {
      _socket?.emit('feedback', payload);
    }
  }

  /// Callback to notify new message
  Function(Map<String, dynamic>)? onNewMessageReceived;

  /// join grouo event
  void joinRoom(String groupId) {
    if (groupId.isNotEmpty) {
      String? name = ShardPrefHelper.getUsername();
      final payload = {
        'username': name,
        'group_id': groupId,
      };

      /// Emit the join-room event with a callback for acknowledgment
      try {
        _socket?.emitWithAck('join-room', payload, ack: (response) {
          print('response for join-room:$response');

          if (response != null && response['status'] == 'success') {
            print('Successfully joined room: $groupId');
          } else if (response != null && response['status'] == 'error') {
            print('Failed to join room: ${response['message']}');
          } else {
            print('No acknowledgment received for join-room');
          }
        });
      } catch (e) {
        print('error while joning room: $e');
      }
    }
  }

  // void joinRoom(String groupId) {
  //   if (groupId.isNotEmpty) {
  //     String? name = ShardPrefHelper.getUsername();
  //     final payload = {'username': name, 'group_id': groupId};
  //     _socket?.emit('join-room', payload);
  //     print('Joined room: $groupId');
  //   }
  // }

  /// dispose method for socket
  void dispose(String roomId) {
    if (roomId.isNotEmpty) {
      String? name = ShardPrefHelper.getUsername();
      final payload = {'username': name, 'group_id': roomId};
      _socket?.emitWithAck('leave-room', payload, ack: (response) {
        if (response != null && response['status'] == 'success') {
          print('Successfully leave room: $roomId');
        } else if (response != null && response['status'] == 'error') {
          print('Failed to leave room: ${response['message']}');
        } else {
          print('No acknowledgment received for leave-room');
        }
      });
      // _socket?.emit('leave-room', payload);
    }
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    print("Socket connection disposed");
  }
}

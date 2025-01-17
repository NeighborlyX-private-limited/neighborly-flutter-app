import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/utils/shared_preference.dart';

class SocketService {
  io.Socket? _socket;

  void connect({String groupId = ''}) {
    /// check if already connected
    if (_socket != null && _socket!.connected) {
      print('Already connected to socket server');
      return;
    }

    String? token = ShardPrefHelper.getJwtToken();
    print('token:$token');

    /// Initialize socket connection to the server with token authentication
    _socket = io.io(
      'http://35.154.40.61:3001',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    /// successfull connection
    _socket!.on("connect", (_) {
      print("Connected to the server");
      joinRoom(groupId);
    });

    /// on connection error
    _socket!.on("error", (err) {
      print("Connection error:  ${err['message']}");
    });

    /// user joined
    _socket!.on("user-joined", (userId) {
      print('User $userId joined the room.');
    });
    //  user leaving
    _socket!.on("user-left", (userId) {
      print('User $userId left the room.');
    });
    _socket!.on("error-message", (data) {
      print(' THIS $data');
    });
    _socket!.on("receive-message", (message) {
      if (onNewMessageReceived != null) {
        onNewMessageReceived!(message);
      }
    });
  }

  ///send message
  void sendMessage(String roomId, Map<String, dynamic> payload, bool isMsg) {
    print('Sending payload: $payload');
    if (isMsg) {
      _socket?.emit('send-message', payload);
    } else {
      _socket?.emit('feedback', payload);
    }
  }

  /// Callback to notify new message
  Function(Map<String, dynamic>)? onNewMessageReceived;

  // Join room method
  void joinRoom(String groupId) async {
    if (groupId.isNotEmpty) {
      final payload = {'groupId': groupId};
      // Emit join-room event and handle response
      _socket!.emit('join-room', payload);
    }
  }

  // leave room method
  void leaveRoom(String groupId) async {
    if (groupId.isNotEmpty) {
      final payload = {'groupId': groupId};
      // Emit leave-room event and handle response
      _socket!.emit('leave-room', payload);
    }
  }

  /// dispose method for socket
  void dispose(String roomId) {
    if (roomId.isNotEmpty) {
      leaveRoom(roomId);
    }
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    print("Socket connection disposed");
  }
}

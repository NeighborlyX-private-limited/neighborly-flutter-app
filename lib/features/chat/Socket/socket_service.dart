import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/constants/constants.dart';
import '../../../core/utils/shared_preference.dart';

class SocketService {
  io.Socket? _socket;

  void connect({String groupId = ''}) {
    // CHECK IF ALREADY CONNECTED TO SOCKET SERVER.
    if (_socket != null && _socket!.connected) {
      print('Already connected to socket server.');
      return;
    }
    // THIS IS ACCESS TOKEN NO NEED TO GET THIS JWT TOKEN
    String? token = ShardPrefHelper.getJwtToken();
    print('Token in socket:$token');

    // INIT SOCKET AND CONNECT TO SOCKET SERVER
    _socket = io.io(
      kBaseSocketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    _socket?.connect();

    // SUCCESSFULL CONNECT LISTENER
    _socket?.on("connect", (_) {
      print("Connected to the socket server.");
      print("Start joining room with groupId: $groupId");
      joinRoom(groupId);
    });

    // ON ERROR LISTENER
    _socket?.on("error", (err) {
      print("Connection error:  ${err['message']}");
    });
    // ON ERROR-MESSAGE LISTENER
    _socket?.on("error-message", (data) {
      print('error-message: $data');
    });
    // USER JOINED ROOM LISTENER
    _socket?.on("user-joined", (userId) {
      print('User joined the room with userId: $userId');
    });

    // USER LEAVE ROOM LISTENER
    _socket?.on("user-left", (userId) {
      print('User left the room with userId: $userId');
    });

    // RECEIVE NEW MESSAGE LISTENER
    _socket?.on("receive-message", (message) {
      print('NEW MESSAGE RECEIVE:$message');
      if (onNewMessageReceived != null) {
        onNewMessageReceived!(message);
      }
    });
  }

  // SEND MESSAGE EMITTER
  void sendMessage(
    String roomId,
    Map<String, dynamic> payload,
    bool isMsg,
  ) {
    _socket?.emit('send-message', payload);
  }

  // CALL BACK FOR NEW MESSAGE RECEIVE
  Function(Map<String, dynamic>)? onNewMessageReceived;

  // JOIN ROOM EMITTER
  void joinRoom(String groupId) async {
    if (groupId.isNotEmpty) {
      final payload = {'groupId': groupId};
      _socket?.emit('join-room', payload);
    }
  }

  // LEAVE ROOM EMITTER
  void leaveRoom(String groupId) async {
    if (groupId.isNotEmpty) {
      final payload = {'groupId': groupId};
      _socket?.emit('leave-room', payload);
    }
  }

  // DISPOSE
  void dispose(String roomId) {
    if (roomId.isNotEmpty) {
      leaveRoom(roomId);
    }
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    print("Socket connection disposed.");
    return;
  }
}

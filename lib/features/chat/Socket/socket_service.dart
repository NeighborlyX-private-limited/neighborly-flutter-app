import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/constants/constants.dart';
import '../../../core/utils/shared_preference.dart';

class SocketService {
  io.Socket? _socket;
  bool _isConnected = false;

  void connect({String groupId = ''}) {
    // CHECK IF ALREADY CONNECTED TO SOCKET SERVER.
    if (_socket != null && _socket!.connected) {
      print('ALREADY CONNECTED TO SOCKET SERVER.');
      return;
    }

    if (_isConnected) {
      return;
    }

    String? accessToken = ShardPrefHelper.getAccessToken();
    print('ACCESS TOKEN IN SOCKET:$accessToken');

    // INIT SOCKET AND CONNECT TO SOCKET SERVER
    _socket = io.io(
      kBaseSocketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': accessToken})
          .disableAutoConnect()
          .build(),
    );

    _socket?.connect();

    // SUCCESSFULL CONNECT LISTENER
    _socket?.on("connect", (_) {
      _isConnected = true;
      if (isSocketConnect != null) {
        isSocketConnect!(true);
      }
      print("SUCCESSFULLY CONNECTED TO SOCKET SERVER.");

      joinRoom(groupId);
    });

    // USER JOINED ROOM LISTENER
    _socket?.on("user-joined", (userId) {
      print('USER JOINED THE ROOM WITH USER ID: $userId');
    });

    // USER LEAVE ROOM LISTENER
    _socket?.on("user-left", (userId) {
      print('USER LEFT THE ROOM WITH USER ID: $userId');
    });

    // RECEIVE NEW MESSAGE LISTENER
    _socket?.on("receive-message", (message) {
      print('NEW MESSAGE RECEIVE:$message');
      if (onNewMessageReceived != null) {
        onNewMessageReceived!(message);
      }
    });

    // MESSAGE DELETED
    _socket?.on("message-deleted", (data) {
      print('MESSAGE DELETED :$data');
      String deletedMessageId = data["messageId"] ?? '';

      if (messageDeleted != null) {
        messageDeleted!(deletedMessageId);
      }
    });

    // ON ERROR LISTENER
    _socket?.on("error", (err) {
      print("CONNECTION ERROR:  ${err['message']}");
    });

    // ON ERROR-MESSAGE LISTENER
    _socket?.on("error-message", (data) {
      print('ERROR: $data');
    });
  }

  // DELETE MESSAGE
  void deleteMessage({required String groupId, required String messageId}) {
    print('DELETE MESSAGE WITH GROUP ID:$groupId AND MESSAGE ID $messageId');
    _socket?.emit(
      "delete-message",
      {
        "groupId": groupId,
        "messageId": messageId,
      },
    );
  }

  // SEND MESSAGE EMITTER
  void sendMessage(
    String roomId,
    Map<String, dynamic> payload,
    bool isMsg,
  ) {
    print('SEND MESSAGE WITH PAYLOAD:$payload');
    _socket?.emit('send-message', payload);
  }

  // CALL BACK FOR NEW MESSAGE RECEIVE
  Function(Map<String, dynamic>)? onNewMessageReceived;
  Function(String)? messageDeleted;
  Function(bool)? isSocketConnect;

  // JOIN ROOM EMITTER
  void joinRoom(String groupId) async {
    print('JOIN ROOM WITH GROUP ID:$groupId');
    if (groupId.isNotEmpty) {
      final payload = {'groupId': groupId};
      _socket?.emit('join-room', payload);
    }
  }

  // DISPOSE
  void dispose(String roomId) async {
    _isConnected = false;
    if (_socket == null) {
      print("SOCKET ALREADY DISPOSED.");
      return;
    }

    print('DISPOSE SOCKET WITH GROUP ID:$roomId');

    if (roomId.isNotEmpty) {
      final payload = {'groupId': roomId};
      _socket?.emit('leave-room', payload);
    }

    _socket?.disconnect();
    _socket?.dispose();

    _socket = null;

    print("SOCKET CONNECTION DISPOSE.");
  }
}

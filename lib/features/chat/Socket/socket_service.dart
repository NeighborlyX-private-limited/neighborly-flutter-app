import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/constants/constants.dart';
import '../../../core/utils/shared_preference.dart';

class SocketService {
  io.Socket? _socket;

  void connect({String groupId = ''}) {
    // CHECK IF ALREADY CONNECTED TO SOCKET SERVER.
    if (_socket != null && _socket!.connected) {
      print('ALREADY CONNECTED TO SOCKET SERVER.');
      return;
    }

    String? accessToken = ShardPrefHelper.getAccessToken();
    String? refreshToken = ShardPrefHelper.getRefreshToken();

    print('ACCESS TOKEN IN SOCKET:$accessToken');
    print('REFRESH TOKEN IN SOCKET:$refreshToken');

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
      print("SUCCESSFULLY CONNECTED TO SOCKET SERVER.");

      joinRoom(groupId);
    });

    // ON ERROR LISTENER
    _socket?.on("error", (err) {
      print("CONNECTION ERROR:  ${err['message']}");
    });
    // ON ERROR-MESSAGE LISTENER
    _socket?.on("error-message", (data) {
      print('ERROR: $data');
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
      print('MESSAGE DELETED:$data');
      String deletedMessageId = data["messageId"] ?? '';
      print("MESSAGE DELETED: $deletedMessageId");
      if (messageDeleted != null) {
        messageDeleted!(deletedMessageId);
      }
    });
  }

// DELETE MESSAGE
  void deleteMessage(String groupId, String messageId) {
    print('MESSAGE DELETE:$groupId $messageId');
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
    print('SEND MESSAGE:$payload');
    _socket?.emit('send-message', payload);
  }

  // CALL BACK FOR NEW MESSAGE RECEIVE
  Function(Map<String, dynamic>)? onNewMessageReceived;
  Function(String)? messageDeleted;

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
    print("SOCKET CONNECTION DISPOSE.");
    return;
  }
}

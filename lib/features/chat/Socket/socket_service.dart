import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/constants/constants.dart';
import '../../../core/utils/shared_preference.dart';

class SocketService {
  io.Socket? _socket;
  bool _isConnected = false;

  void connect({String? groupId, String? chatId}) {
    // void connect({String groupId = '', }) {
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
      if (groupId != null) {
        joinRoom(groupId);
      }
      if (chatId != null) {
        joinDm(chatId);
      }
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
    // ON ERROR LISTENER
    _socket?.on("active-users", (users) {
      print("USER CONNECTED:  ${users}");
    });
    _socket?.on("dm-new-message", (msg) {
      print("new dm :  ${msg}");
      if (onNewDmMessageReceived != null) {
        onNewDmMessageReceived!(msg['message']);
      }
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

  void sendDmMessage(
    String chatId,
    Map<String, dynamic> payload,
    bool isMsg,
  ) {
    print('SEND DM MESSAGE WITH PAYLOAD:$payload');
    _socket?.emitWithAck('dm-send-message', payload, ack: (data) {
      print('data: $data');
      // Handle callback response
      if (data['success'] == true) {
        // print('${data['message']}');
        print('success dm');
        // leaveDm(chatId);
      } else {
        // print( ${data['message']}');
        print('fail dm');
      }
    });
  }

  // CALL BACK FOR NEW MESSAGE RECEIVE
  Function(Map<String, dynamic>)? onNewMessageReceived;
  Function(Map<String, dynamic>)? onNewDmMessageReceived;
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

  // JOIN ROOM EMITTER
  void joinDm(String chatId) async {
    print('START JOINING DM ROOM WITH CHAT ID:$chatId');
    if (chatId.isNotEmpty) {
      final payload = {'chatId': chatId};
      // Emit join request
      _socket?.emitWithAck('dm-join', {'chatId': chatId}, ack: (data) {
        print('data: $data');
        // Handle callback response
        if (data['success'] == true) {
          // print('${data['message']}');
          print('success');
          // leaveDm(chatId);
        } else {
          // print( ${data['message']}');
          print('fail');
        }
      });

      // _socket?.emit('dm-join', payload);
    }
  }

  // JOIN ROOM EMITTER
  void leaveDm(String chatId) async {
    print('START Leaving DM ROOM WITH CHAT ID:$chatId');
    if (chatId.isNotEmpty) {
      final payload = {'chatId': chatId};
      // Emit join request
      _socket?.emitWithAck('dm-leave', {'chatId': chatId}, ack: (data) {
        print('data: $data');
        // Handle callback response
        if (data['success'] == true) {
          // print('${data['message']}');
          print('success');
        } else {
          // print( ${data['message']}');
          print('fail');
        }
      });

      // _socket?.emit('dm-join', payload);
    }
  }

  // DISPOSE
  void dispose({String? groupId, String? chatId}) async {
    _isConnected = false;
    if (_socket == null) {
      print("SOCKET ALREADY DISPOSED.");
      return;
    }

    // print('DISPOSE SOCKET WITH GROUP ID:$roomId');
    print('DISPOSE SOCKET WITH GROUP ID:$chatId');

    if (groupId != null) {
      final payload = {'groupId': groupId};
      _socket?.emit('leave-room', payload);
    }
    if (chatId != null) {
      final payload = {'chatId': chatId};
      leaveDm(chatId);
      // _socket?.emit('dm-leave', payload);
    }

    _socket?.disconnect();
    _socket?.dispose();

    _socket = null;

    print("SOCKET CONNECTION DISPOSE.");
  }
}

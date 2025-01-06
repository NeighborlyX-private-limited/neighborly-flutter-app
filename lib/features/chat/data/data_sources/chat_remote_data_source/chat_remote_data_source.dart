import '../../model/chat_message_model.dart';
import '../../model/chat_room_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatRoomModel>> getAllChatRooms();
  Future<List<ChatMessageModel>> getRoomMessages({
    required String roomId,
  });

  /// featch group chat room messages
  Future<List<ChatMessageModel>> getGroupRoomMessages({
    required String roomId,
    bool isreply = false,
    int page = 1,
  });
}

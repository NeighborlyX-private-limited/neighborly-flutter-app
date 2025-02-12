import '../../model/chat_message_model.dart';
import '../../model/chat_room_model.dart';
import '../../model/pinned_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatMessageModel>> getRoomMessages({
    required String roomId,
  });
  Future<List<PinnedMessageModel>> featchPinnedMessages({
    required String groupId,
  });
  Future<String> pinnedMessage({
    required String messageId,
  });
  // GET ALL CHAT ROOM
  Future<List<ChatRoomModel>> getAllChatRooms();
  // GET GROUP CHAT
  Future<List<ChatMessageModel>> getGroupRoomMessages({
    required String roomId,
    bool isreply = false,
    int page = 1,
  });
}

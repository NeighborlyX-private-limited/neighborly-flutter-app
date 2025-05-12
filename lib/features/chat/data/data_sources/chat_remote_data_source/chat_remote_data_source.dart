import '../../model/chat_message_model.dart';
import '../../model/chat_room_model.dart';
import '../../model/dm_message_model.dart';
import '../../model/interest_model.dart';
import '../../model/nearby_user_model.dart';
import '../../model/pinned_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatMessageResponse> getRoomMessages({
    required String chatId,
  });
  Future<List<PinnedMessageModel>> featchPinnedMessages({
    required String groupId,
  });
  Future<String> pinnedMessage({
    required String messageId,
  });
  Future<String> createDm({
    required String userId,
  });
  // GET ALL CHAT ROOMS
  Future<List<ChatRoomModel>> getAllChatRooms();
  // GET GROUP CHAT
  Future<List<ChatMessageModel>> getGroupRoomMessages({
    required String roomId,
    bool isreply = false,
    int page = 1,
  });

  Future<InterestModel> getAllInterests();
  Future<List<NearbyUserModel>> getNearByUser();
  Future<void> saveUserInterest({
    required List<String> userInterest,
  });
}

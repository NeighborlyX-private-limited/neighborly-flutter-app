import '../../model/chat_message_model.dart';
import '../../model/chat_room_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatRoomModel>> getAllChatRooms();
  Future<List<ChatMessageModel>> getRoomMessages(
      {required String roomId, String? dateFrom});
  Future<List<ChatMessageModel>> getGroupRoomMessages(
      {required String roomId, String? dateFrom});
}

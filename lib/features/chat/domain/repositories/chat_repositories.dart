import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../../data/model/chat_room_model.dart';
import '../../data/model/pinned_message_model.dart';

abstract class ChatRepositories {
  Future<Either<Failure, List<PinnedMessageModel>>> featchPinnedMessages({
    required String groupId,
  });
  Future<Either<Failure, List<ChatMessageModel>>> getRoomMessages({
    required String roomId,
    String? dateFrom,
  });
  Future<Either<Failure, String>> pinnedMessage({
    required String messageId,
  });
  // GET ALL CHAT ROOM
  Future<Either<Failure, List<ChatRoomModel>>> getAllChatRooms();
  // GET GROUP CHAT
  Future<Either<Failure, List<ChatMessageModel>>> getGroupRoomMessages({
    required String roomId,
    bool isreply = false,
    int page = 1,
  });
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../../data/model/chat_room_model.dart';

abstract class ChatRepositories {
  Future<Either<Failure, List<ChatRoomModel>>> getAllChatRooms();
  Future<Either<Failure, List<ChatMessageModel>>> getRoomMessages({
    required String roomId,
    String? dateFrom,
  });

  /// get group room messages
  Future<Either<Failure, List<ChatMessageModel>>> getGroupRoomMessages({
    required String roomId,
    String? dateFrom,
    bool isreply = false,
    int page = 1,
  });
}

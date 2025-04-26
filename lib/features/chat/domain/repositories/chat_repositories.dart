import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/features/chat/presentation/bloc/bloc/nearby_user_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../../data/model/chat_room_model.dart';
import '../../data/model/interest_model.dart';
import '../../data/model/nearby_user_model.dart';
import '../../data/model/pinned_message_model.dart';

abstract class ChatRepositories {
  Future<Either<Failure, List<PinnedMessageModel>>> featchPinnedMessages({
    required String groupId,
  });
  Future<Either<Failure, List<ChatMessageModel>>> getRoomMessages({
    required String chatId,
  });
  Future<Either<Failure, String>> pinnedMessage({
    required String messageId,
  });
  Future<Either<Failure, String>> createDm({
    required String userId,
  });
  // GET ALL CHAT ROOM
  Future<Either<Failure, List<ChatRoomModel>>> getAllChatRooms();
  Future<Either<Failure, InterestModel>> getAllInterests();
  Future<Either<Failure, List<NearbyUserModel>>> getNearByUser();
  Future<Either<Failure, void>> saveUserInterest({
    required List<String> userInterest,
  });
  // GET GROUP CHAT
  Future<Either<Failure, List<ChatMessageModel>>> getGroupRoomMessages({
    required String roomId,
    bool isreply = false,
    int page = 1,
  });
}

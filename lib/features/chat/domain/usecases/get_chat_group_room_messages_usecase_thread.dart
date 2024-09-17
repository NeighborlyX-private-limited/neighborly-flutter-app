import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../repositories/chat_repositories_thread.dart';

class GetChatGroupRoomMessagesUseCaseThread {
  final ChatRepositoriesThread repository;

  GetChatGroupRoomMessagesUseCaseThread(this.repository);

  Future<Either<Failure, List<ChatMessageModel>>> call({
    required String roomId,
    String? dateFrom,
    bool isreply = false
  }) async {
    return await repository.getGroupRoomMessages(
      roomId: roomId,
      dateFrom: dateFrom,
    );
  }
}

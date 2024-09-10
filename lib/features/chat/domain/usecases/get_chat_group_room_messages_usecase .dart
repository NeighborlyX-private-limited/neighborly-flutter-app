import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../repositories/chat_repositories.dart';

class GetChatGroupRoomMessagesUseCase {
  final ChatRepositories repository;

  GetChatGroupRoomMessagesUseCase(this.repository);

  Future<Either<Failure, List<ChatMessageModel>>> call({
    required String roomId,
    String? dateFrom,
  }) async {
    return await repository.getGroupRoomMessages(
      roomId: roomId,
      dateFrom: dateFrom,
    );
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../../data/model/dm_message_model.dart';
import '../repositories/chat_repositories.dart';

class GetChatRoomMessagesUseCase {
  final ChatRepositories repository;

  GetChatRoomMessagesUseCase(this.repository);

  Future<Either<Failure, ChatMessageResponse>> call({
    required String chatId,
  }) async {
    return await repository.getRoomMessages(
      chatId: chatId,
    );
  }
}

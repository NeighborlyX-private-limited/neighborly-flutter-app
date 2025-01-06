import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../repositories/chat_repositories.dart';

class GetChatGroupRoomMessagesUseCase {
  final ChatRepositories repository;

  GetChatGroupRoomMessagesUseCase(this.repository);

  Future<Either<Failure, List<ChatMessageModel>>> call({
    required String roomId,
    bool isreply = false,
    int page = 1,
  }) async {
    return await repository.getGroupRoomMessages(
      roomId: roomId,
      page: page,
    );
  }
}

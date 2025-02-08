import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/pinned_message_model.dart';
import '../repositories/chat_repositories.dart';

class FeatchPinnedMessagesUsecase {
  final ChatRepositories repository;

  FeatchPinnedMessagesUsecase(this.repository);

  Future<Either<Failure, List<PinnedMessageModel>>> call({
    required String groupId,
  }) async {
    return await repository.featchPinnedMessages(groupId: groupId);
  }
}

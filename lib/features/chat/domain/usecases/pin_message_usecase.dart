import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/chat_repositories.dart';

class PinnedMessagesUsecase {
  final ChatRepositories repository;

  PinnedMessagesUsecase(this.repository);

  Future<Either<Failure, String>> call({
    required String messageId,
  }) async {
    return await repository.pinnedMessage(messageId: messageId);
  }
}

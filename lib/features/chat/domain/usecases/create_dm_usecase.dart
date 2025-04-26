import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/chat_repositories.dart';

class CreateDmUsecase {
  final ChatRepositories repository;

  CreateDmUsecase(this.repository);

  Future<Either<Failure, String>> call({
    required String userId,
  }) async {
    return await repository.createDm(userId: userId);
  }
}

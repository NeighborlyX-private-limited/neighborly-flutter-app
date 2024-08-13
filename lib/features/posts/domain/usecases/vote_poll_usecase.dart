import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/posts/domain/repositories/post_repositories.dart';

class VotePollUsecase {
  final PostRepositories repository;

  VotePollUsecase(this.repository);

  Future<Either<Failure, void>> call(
      {required num pollId, required num optionId}) async {
    return await repository.votePoll(
      pollId: pollId,
      optionId: optionId,
    );
  }
}

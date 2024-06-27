import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/posts/domain/repositories/post_repositories.dart';

class GiveAwardUsecase {
  final PostRepositories repository;

  GiveAwardUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required num id,
    required String awardType,
    required String type,
  }) async {
    return await repository.giveAward(
      id: id,
      awardType: awardType,
      type: type,
    );
  }
}

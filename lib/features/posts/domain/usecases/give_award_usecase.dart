import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/post_repositories.dart';

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

import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/profile/domain/repositories/profile_repositories.dart';

class GetMyAwardsUsecase {
  final ProfileRepositories repository;

  GetMyAwardsUsecase(this.repository);

  Future<Either<Failure, List<dynamic>>> call() async {
    return await repository.getMyAwards();
  }
}

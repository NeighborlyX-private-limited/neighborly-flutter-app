import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repositories.dart';

class GetMyAwardsUsecase {
  final ProfileRepositories repository;

  GetMyAwardsUsecase(this.repository);

  Future<Either<Failure, List<dynamic>>> call() async {
    return await repository.getMyAwards();
  }
}

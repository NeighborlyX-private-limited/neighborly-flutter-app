import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/profile_repositories.dart';

class GetMyGroupUsecase {
  final ProfileRepositories repository;

  GetMyGroupUsecase(this.repository);

  Future<Either<Failure, List<dynamic>>> call({
    String? userId,
  }) async {
    return await repository.getMyGroups(
      userId: userId,
    );
  }
}

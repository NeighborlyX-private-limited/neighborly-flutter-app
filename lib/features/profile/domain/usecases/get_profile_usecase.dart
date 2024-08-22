import 'package:dartz/dartz.dart';

import '../../../../core/entities/auth_response_entity.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repositories.dart';

class GetProfileUsecase {
  final ProfileRepositories repository;

  GetProfileUsecase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call() async {
    return await repository.getProfile();
  }
}

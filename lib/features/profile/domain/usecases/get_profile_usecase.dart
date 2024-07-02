import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/entities/auth_response_entity.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/profile/domain/repositories/profile_repositories.dart';

class GetProfileUsecase {
  final ProfileRepositories repository;

  GetProfileUsecase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call() async {
    return await repository.getProfile();
  }
}

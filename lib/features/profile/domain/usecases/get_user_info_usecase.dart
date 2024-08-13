import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/entities/auth_response_entity.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/profile/domain/repositories/profile_repositories.dart';

class GetUserInfoUsecase {
  final ProfileRepositories repository;

  GetUserInfoUsecase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call({
    required String userId,
  }) async {
    return await repository.getUserInfo(
      userId: userId,
    );
  }
}

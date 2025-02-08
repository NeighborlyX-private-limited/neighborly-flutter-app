import 'package:dartz/dartz.dart';
import '../../../../core/entities/auth_response_entity.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repositories.dart';

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

import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/profile/domain/entities/post_with_comments_entity.dart';
import 'package:neighborly_flutter_app/features/profile/domain/repositories/profile_repositories.dart';

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

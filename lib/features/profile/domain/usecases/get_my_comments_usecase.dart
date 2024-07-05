import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/profile/domain/entities/post_with_comments_entity.dart';
import 'package:neighborly_flutter_app/features/profile/domain/repositories/profile_repositories.dart';

class GetMyCommentsUsecase {
  final ProfileRepositories repository;

  GetMyCommentsUsecase(this.repository);

  Future<Either<Failure, List<PostWithCommentsEntity>>> call({
    String? userId,
  }) async {
    return await repository.getMyComments(
      userId: userId,
    );
  }
}

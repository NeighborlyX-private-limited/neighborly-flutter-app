import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/post_with_comments_entity.dart';
import '../repositories/profile_repositories.dart';

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

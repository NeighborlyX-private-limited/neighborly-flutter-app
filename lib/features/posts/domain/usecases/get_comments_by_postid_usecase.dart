import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/comment_entity.dart';
import '../repositories/post_repositories.dart';

class GetCommentsByPostIdUsecase {
  final PostRepositories repository;

  GetCommentsByPostIdUsecase(this.repository);

  Future<Either<Failure, List<CommentEntity>>> call({
    required num id,
  }) async {
    return await repository.getCommentsByPostId(postId: id);
  }
}

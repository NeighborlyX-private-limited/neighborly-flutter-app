import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/comment_entity.dart';
import 'package:neighborly_flutter_app/features/posts/domain/repositories/post_repositories.dart';

class GetCommentsByPostIdUsecase {
  final PostRepositories repository;

  GetCommentsByPostIdUsecase(this.repository);

  Future<Either<Failure, List<CommentEntity>>> call({
    required num id,
  }) async {
    return await repository.getCommentsByPostId(postId: id);
  }
}

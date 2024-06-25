import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/posts/domain/repositories/post_repositories.dart';

class FetchCommentReplyUsecase {
  final PostRepositories repository;

  FetchCommentReplyUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required num commentId,
  }) async {
    return await repository.fetchCommentReply(
      commentId: commentId,
    );
  }
}

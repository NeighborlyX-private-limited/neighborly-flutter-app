import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/reply_entity.dart';
import 'package:neighborly_flutter_app/features/posts/domain/repositories/post_repositories.dart';

class FetchCommentReplyUsecase {
  final PostRepositories repository;

  FetchCommentReplyUsecase(this.repository);

  Future<Either<Failure, List<ReplyEntity>>> call({
    required num commentId,
  }) async {
    return await repository.fetchCommentReply(
      commentId: commentId,
    );
  }
}

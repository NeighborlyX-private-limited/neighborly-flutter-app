import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/reply_entity.dart';
import '../repositories/post_repositories.dart';

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

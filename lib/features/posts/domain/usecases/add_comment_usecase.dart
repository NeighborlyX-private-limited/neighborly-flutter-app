import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/posts/domain/repositories/post_repositories.dart';

class AddCommentUsecase {
  final PostRepositories repository;

  AddCommentUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required num id,
    required String text,
    num? commentId,
  }) async {
    return await repository.addComment(
      postId: id,
      text: text,
      commentId: commentId,
    );
  }
}

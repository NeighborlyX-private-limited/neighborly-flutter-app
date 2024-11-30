import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/post_repositories.dart';

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

import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/features/posts/data/model/specific_comment_model.dart';
import '../../../../core/error/failures.dart';
import '../repositories/post_repositories.dart';

class GetCommentByCommentIdUsecase {
  final PostRepositories repository;

  GetCommentByCommentIdUsecase(this.repository);

  Future<Either<Failure, SpecificCommentModel>> call({
    required String id,
  }) async {
    return await repository.getCommentById(
      id: id,
    );
  }
}

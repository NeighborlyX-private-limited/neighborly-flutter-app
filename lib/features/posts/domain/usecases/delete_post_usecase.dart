import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/posts/domain/repositories/post_repositories.dart';

class DeletePostUsecase {
  final PostRepositories repository;

  DeletePostUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required num id,
  }) async {
    return await repository.deletePost(
      id: id,
    );
  }
}

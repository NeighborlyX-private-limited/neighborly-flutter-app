import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';
import 'package:neighborly_flutter_app/features/posts/domain/repositories/post_repositories.dart';

class GetPostByIdUsecase {
  final PostRepositories repository;

  GetPostByIdUsecase(this.repository);

  Future<Either<Failure, PostEntity>> call({
    required num id,
  }) async {
    return await repository.getPostById(
      id: id,
    );
  }
}

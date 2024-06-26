import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';
import 'package:neighborly_flutter_app/features/posts/domain/repositories/post_repositories.dart';

class GetAllPostsUsecase {
  final PostRepositories repository;

  GetAllPostsUsecase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call({
    required bool isHome,
  }) async {
    return await repository.getAllPosts(
      isHome: isHome,
    );
  }
}

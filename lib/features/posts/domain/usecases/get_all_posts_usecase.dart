import 'package:dartz/dartz.dart';

import '../../../../core/entities/post_enitity.dart';
import '../../../../core/error/failures.dart';
import '../repositories/post_repositories.dart';

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

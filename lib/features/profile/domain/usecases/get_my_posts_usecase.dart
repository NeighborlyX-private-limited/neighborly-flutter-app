import 'package:dartz/dartz.dart';

import '../../../../core/entities/post_enitity.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repositories.dart';

class GetMyPostsUsecase {
  final ProfileRepositories repository;

  GetMyPostsUsecase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call({
    String? userId,
  }) async {
    return await repository.getMyPosts(
      userId: userId,
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/entities/post_enitity.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/profile/domain/repositories/profile_repositories.dart';

class GetMyPostsUsecase {
  final ProfileRepositories repository;

  GetMyPostsUsecase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call() async {
    return await repository.getMyPosts();
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/entities/post_enitity.dart';
import '../../../../core/error/failures.dart';
import '../repositories/post_repositories.dart';

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

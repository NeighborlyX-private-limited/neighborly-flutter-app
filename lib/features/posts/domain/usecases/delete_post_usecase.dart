import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/post_repositories.dart';

class DeletePostUsecase {
  final PostRepositories repository;

  DeletePostUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required num id,
    required String type,
  }) async {
    return await repository.deletePost(
      id: id,
      type: type,
    );
  }
}

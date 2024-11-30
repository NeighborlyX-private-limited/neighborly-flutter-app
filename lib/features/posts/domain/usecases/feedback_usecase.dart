import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/post_repositories.dart';

class FeedbackUsecase {
  final PostRepositories repository;

  FeedbackUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required num id,
    required String feedback,
    required String type,
  }) async {
    return await repository.feedback(
      id: id,
      feedback: feedback,
      type: type,
    );
  }
}

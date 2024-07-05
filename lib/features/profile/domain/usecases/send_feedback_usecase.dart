import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/profile/domain/repositories/profile_repositories.dart';

class SendFeedbackUsecase {
  final ProfileRepositories repository;

  SendFeedbackUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String feedback,
  }) async {
    return await repository.sendFeedback(
      feedback: feedback,
    );
  }
}

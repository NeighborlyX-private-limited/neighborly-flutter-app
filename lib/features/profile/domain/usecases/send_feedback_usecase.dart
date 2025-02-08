import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repositories.dart';

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

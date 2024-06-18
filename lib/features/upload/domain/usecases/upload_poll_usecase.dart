import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/upload/domain/repositories/upload_repositories.dart';

class UploadPollUsecase {
  final UploadRepositories repository;

  UploadPollUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String question,
    required List<String> options,
  }) async {
    return await repository.uploadPoll(
      question: question,
      options: options,
    );
  }
}

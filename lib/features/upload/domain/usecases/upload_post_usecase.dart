import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/upload/domain/repositories/upload_repositories.dart';

class UploadPostUsecase {
  final UploadRepositories repository;

  UploadPostUsecase(this.repository);

  Future<Either<Failure, void>> call(
      {String? content,
      String? title,
      String? multimedia,
      required List<num> location}) async {
    return await repository.uploadPost(
        content: content,
        multimedia: multimedia,
        location: location,
        title: title);
  }
}

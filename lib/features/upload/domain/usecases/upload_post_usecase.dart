import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/upload/domain/repositories/upload_repositories.dart';

class UploadPostUsecase {
  final UploadRepositories repository;

  UploadPostUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String title,
    String? content,
    required String type,
    String? multimedia,
    required List<num> location,
    required String city,
    List<dynamic>? options,
    bool? allowMultipleVotes,
  }) async {
    return await repository.uploadPost(
      title: title,
      content: content,
      type: type,
      multimedia: multimedia,
      allowMultipleVotes: allowMultipleVotes,
      location: location,
      city: city,
      options: options,
    );
  }
}

import 'dart:io';

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
    File? multimedia,
    required String city,
    List<dynamic>? options,
    required bool allowMultipleVotes,
  }) async {
    return await repository.uploadPost(
      title: title,
      content: content,
      type: type,
      multimedia: multimedia,
      allowMultipleVotes: allowMultipleVotes,
      city: city,
      options: options,
    );
  }
}

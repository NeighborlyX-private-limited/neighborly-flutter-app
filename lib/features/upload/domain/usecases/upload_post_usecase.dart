import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/upload_repositories.dart';

class UploadPostUsecase {
  final UploadRepositories repository;

  UploadPostUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String title,
    required List<double> location,
    String? content,
    required String type,
    List<File>? multimedia,
    required String city,
    List<dynamic>? options,
    required bool allowMultipleVotes,
    File? thumbnail,
  }) async {
    return await repository.uploadPost(
      title: title,
      content: content,
      type: type,
      multimedia: multimedia,
      allowMultipleVotes: allowMultipleVotes,
      city: city,
      options: options,
      location: location,
      thumbnail: thumbnail,
    );
  }
}

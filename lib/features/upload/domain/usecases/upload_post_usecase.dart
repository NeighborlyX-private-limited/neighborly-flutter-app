import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/upload_repositories.dart';

class UploadPostUsecase {
  final UploadRepositories repository;

  UploadPostUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String type,
    required String title,
    String? content,
    List<dynamic>? options,
    required bool allowMultipleVotes,
    List<File>? multimedia,
    File? thumbnail,
    required List<double> location,
    required String city,
  }) async {
    return await repository.uploadPost(
      type: type,
      title: title,
      content: content,
      options: options,
      allowMultipleVotes: allowMultipleVotes,
      multimedia: multimedia,
      thumbnail: thumbnail,
      location: location,
      city: city,
    );
  }
}

import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/upload_repositories.dart';

class UploadFileUsecase {
  final UploadRepositories repository;

  UploadFileUsecase(this.repository);

  Future<Either<Failure, String>> call({required File file}) async {
    return await repository.uploadFile(file: file);
  }
}

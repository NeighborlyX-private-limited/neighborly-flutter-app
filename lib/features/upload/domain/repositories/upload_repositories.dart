import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class UploadRepositories {
  Future<Either<Failure, void>> uploadPost({
    required String title,
    String? content,
    required String type,
    String? multimedia,
    required List<num> location,
    required String city,
  });
  Future<Either<Failure, String>> uploadFile({required File file});
  Future<Either<Failure, void>> uploadPoll({
    required String question,
    required List<String> options,
  });
}

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
    List<dynamic>? options,
    bool? allowMultipleVotes,
  });
  Future<Either<Failure, String>> uploadFile({required File file});
}

import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class UploadRepositories {
  Future<Either<Failure, void>> uploadPost({
    required String title,
    required List<double> location,
    String? content,
    required String type,
    File? multimedia,
    required String city,
    List<dynamic>? options,
    required bool allowMultipleVotes,
  });
  Future<Either<Failure, String>> uploadFile({required File file});
}
